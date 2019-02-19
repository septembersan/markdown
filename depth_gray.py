# -*- coding: utf-8 -*-
# references
# * chrome-extension://lcopgfbpbmionefhhgbamgmejggljpbb/http://rudrapoudel.com/docs/Poudel_ISVC2013.pdf
# * chrome-extension://lcopgfbpbmionefhhgbamgmejggljpbb/https://www.cv-foundation.org/openaccess/content_cvpr_2014/papers/Qian_Realtime_and_Robust_2014_CVPR_paper.pdf

#############################################
#      D415 Depth画像の表示&キャプチャ
#############################################
import pyrealsense2 as rs
import numpy as np
import cv2


face_cascade_path = 'haarcascade_frontalface_default.xml'
eyes_cascade_path = 'haarcascade_eye_tree_eyeglasses.xml'
face_color_hs_map = np.zeros(256*256).reshape(256, 256)


def face_detect(color_img):
    is_detected = False

    img = color_img.copy()
    src_gray = cv2.cvtColor(color_img, cv2.COLOR_BGR2GRAY)

    face_cascade = cv2.CascadeClassifier(face_cascade_path)
    eyes_cascade = cv2.CascadeClassifier(eyes_cascade_path)

    faces = face_cascade.detectMultiScale(src_gray)

    for x, y, w, h in faces:
        cv2.rectangle(img, (x, y), (x + w, y + h), (255, 0, 0), 2)
        hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        eyes = eyes_cascade.detectMultiScale(src_gray)

        if len(eyes) < 2:
            continue
        is_detected = True

        # draw eyes region
        for (ex, ey, ew, eh) in eyes:
            cv2.rectangle(img, (ex, ey), (ex + ew, ey + eh), (0, 0, 255), 2)

        # get nose region
        ex1, ey1, ew1, eh1 = eyes[0]
        ex2, ey2, ew2, eh2 = eyes[1]

        nose_points = []
        if ex1 < ex2:
            # ex1 is left eye
            nose_points += [ey1+eh1, ey1+eh1+eh1, ex1+ew1, ex2]
        else:
            # ex2 is left eye
            nose_points += [ey2+eh2, ey2+eh2+eh2, ex2+ew2, ex1]

        cv2.rectangle(img,
                      (nose_points[2], nose_points[0]),
                      (nose_points[3], nose_points[1]),
                      (0, 125, 255), 2)
        small_face = hsv_img[nose_points[0]:nose_points[1],
                             nose_points[2]:nose_points[3]]

        for pixel_line in small_face:
            for pixel in pixel_line:
                h, s, v = pixel
                face_color_hs_map[h][s] = 1

    return is_detected, img


def skin_color_filter_with_hs_space(filtered_img, hsv_img, face_color_hs_map):
    # filtered_img = color_img.copy()

    for y, pixel_line in enumerate(hsv_img):
        for x, pixel in enumerate(pixel_line):
            h, s, v = pixel
            if face_color_hs_map.item(h, s) == 1:
                filtered_img[y][x] = [0, 0, 0]

    # return filtered_img


# meter
TARGET_DISTANCE = 2.0

# Configure depth and color streams
pipeline = rs.pipeline()
config = rs.config()
config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)
config.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

# ストリーミング開始
profile = pipeline.start(config)

# Depthスケール取得
#   距離[m] = depth * depth_scale
depth_sensor = profile.get_device().first_depth_sensor()
depth_scale = depth_sensor.get_depth_scale()
# 対象範囲の閾値
distance_max = TARGET_DISTANCE/depth_scale
print('Depth Scale = {} -> {}'.format(depth_scale, distance_max))


def detect_edge_with_depth(depth_gray_img):
    xsobel = cv2.Sobel(depth_gray_img, cv2.CV_32F, 1, 0)
    ysobel = cv2.Sobel(depth_gray_img, cv2.CV_32F, 0, 1)

    # 8ビット符号なし整数変換
    gray_abs_sobelx = cv2.convertScaleAbs(xsobel)
    gray_abs_sobely = cv2.convertScaleAbs(ysobel)

    # 重み付き和
    return cv2.addWeighted(gray_abs_sobelx, 0.5, gray_abs_sobely, 0.5, 0)


def detect_hand_with_depth(depth_gray_img):
    max_value = np.amax(depth_gray_img)
    hand_img = np.where(depth_gray_img >= max_value, 255, 0)
    # depth_normlized = depth_gray_img / np.amax(depth_gray_img)
    # depth_normlized = cv2.normalize(depth_gray_img, None, 0.0, 1.0, norm_type=cv2.NORM_MINMAX)
    # depth_binary = np.where(depth_normlized >= 1.0, 1, 0)
    # return hand_img
    return depth_gray_img


FACE_DETECT_NUM = 20
face_detect_count = 0

try:
    while True:
        # フレーム待ち(Depth & Color)
        frames = pipeline.wait_for_frames()
        depth_frame = frames.get_depth_frame()
        color_frame = frames.get_color_frame()
        if not depth_frame or not color_frame:
            continue
        color_img_src = np.asanyarray(color_frame.get_data())
        color_img = cv2.resize(color_img_src, dsize=(480, 360))
        if face_detect_count < FACE_DETECT_NUM:
            is_detected, face_img = face_detect(color_img)
            if is_detected:
                face_detect_count += 1

        hsv_img = cv2.cvtColor(color_img, cv2.COLOR_BGR2HSV)
        skin_color_filter_with_hs_space(color_img, hsv_img, face_color_hs_map)
        # Depth画像前処理(2m以内を画像化)
        depth_image = np.asanyarray(depth_frame.get_data())
        depth_image = cv2.resize(depth_image, dsize=(480, 360))
        depth = depth_image.copy()

        # distance_maxより低いもののみ抽出
        depth_image = (depth_image < distance_max) * depth_image
        depth_graymap = depth_image * 255. / distance_max

        hand_img = detect_hand_with_depth(depth)
        hand_img = hand_img.reshape((360, 480)).astype(np.uint8)

        depth_graymap = depth_graymap.reshape((360, 480)).astype(np.uint8)
        depth_colormap = cv2.cvtColor(depth_graymap, cv2.COLOR_GRAY2BGR)
        sobel = detect_edge_with_depth(depth_graymap)
        # cv2.floodFill(color_img, sobel, (120, 120), (0, 255, 255))

        # 入力画像表示
        cv2.namedWindow('RealSense', cv2.WINDOW_AUTOSIZE)
        cv2.namedWindow('RealSense2', cv2.WINDOW_AUTOSIZE)
        imgs = cv2.hconcat([face_img, color_img])
        cv2.imshow('RealSense', imgs)
        cv2.imshow('RealSense2', hand_img)
        if cv2.waitKey(1) & 0xff == 27:
            break

finally:
    # ストリーミング停止
    pipeline.stop()
    cv2.destroyAllWindows()
