# -*- coding: utf-8 -*-

#############################################
#      D415 Depth画像の表示&キャプチャ
#############################################
import pyrealsense2 as rs
import numpy as np
import cv2


face_cascade_path = 'haarcascade_frontalface_default.xml'
face_color_hs_map = np.zeros(256*256).reshape(256, 256)


def face_detect(color_img):
    img = color_img.copy()
    face_cascade = cv2.CascadeClassifier(face_cascade_path)

    src_gray = cv2.cvtColor(color_img, cv2.COLOR_BGR2GRAY)

    faces = face_cascade.detectMultiScale(src_gray)

    for x, y, w, h in faces:
        cv2.rectangle(img, (x, y), (x + w, y + h), (255, 0, 0), 2)
        cx = x + (w//2)
        cy = y + (h//2)
        cv2.rectangle(img, (cx+20, cy+20), (cx-20, cy-20), (0, 255, 0), 2)
        hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        small_face = hsv_img[cy-20: cy+20, cx-20: cx+20]
        # face_gray = src_gray[y: y + h, x: x + w]

        for pixel_line in small_face:
            for pixel in pixel_line:
                h, s, v = pixel
                face_color_hs_map[h][s] = 1

    return img


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

# OUTPUT_VIDEO_FILE = 'sample_depth.avi'
# Output file
# fourcc = cv2.VideoWriter_fourcc(*'DIVX')
# out = cv2.VideoWriter(OUTPUT_VIDEO_FILE, fourcc, 24, (640, 480))
#
# if not out.isOpened():
#     print('File {0} open error.'.format(OUTPUT_VIDEO_FILE))
#     exit()

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
            face_detect_count += 1
            face_img = face_detect(color_img)

        hsv_img = cv2.cvtColor(color_img, cv2.COLOR_BGR2HSV)
        skin_color_filter_with_hs_space(color_img, hsv_img, face_color_hs_map)
        # Depth画像前処理(2m以内を画像化)
        depth_image = np.asanyarray(depth_frame.get_data())
        depth_image = (depth_image < distance_max) * depth_image
        depth_graymap = depth_image * 255. / distance_max
        depth_graymap = depth_graymap.reshape((480, 640)).astype(np.uint8)
        depth_colormap = cv2.cvtColor(depth_graymap, cv2.COLOR_GRAY2BGR)

        # 膨張/収縮処理
        # color_img = cv2.morphologyEx(color_img,
        #                              cv2.MORPH_CLOSE,
        #                              np.ones((3, 3), np.uint8))
        color_img = cv2.dilate(color_img, np.ones((3, 3), np.uint8),
                               iterations=1)

        # エッジ検出
        # canny_img = cv2.Canny(depth_colormap, 100, 200)
        # canny_img = cv2.copyMakeBorder(depth_colormap,
        #                                1, 1, 1, 1, cv2.BORDER_REPLICATE)

        # 領域補間
        # cv2.floodFill(depth_colormap, canny_img, (120, 120), (0, 255, 255))

        # 入力画像表示
        cv2.namedWindow('RealSense', cv2.WINDOW_AUTOSIZE)
        cv2.imshow('RealSense', depth_colormap)
        # out.write(depth_colormap)
        if cv2.waitKey(1) & 0xff == 27:
            break

finally:
    # ストリーミング停止
    pipeline.stop()
    cv2.destroyAllWindows()
