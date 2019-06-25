# * http://rudrapoudel.com/docs/Poudel_ISVC2013.pdf
# * https://www.cv-foundation.org/openaccess/content_cvpr_2014/papers/
#   Qian_Realtime_and_Robust_2014_CVPR_paper.pdf

import matplotlib.pyplot as plt
import numpy as np
from sklearn import preprocessing
import pyrealsense2 as rs
import cv2
from keras.models import load_model
from keras.preprocessing.image import img_to_array, load_img
from keras.models import model_from_json


FACE_CASCADE_PATH = 'haarcascade_frontalface_default.xml'
EYES_CASCADE_PATH = 'haarcascade_eye_tree_eyeglasses.xml'
FACE_COLOR_HS_MAP = np.zeros(256*256).reshape(256, 256)
GLOBAL_HS_MAP = np.arange(256*256).reshape(256, 256).astype(bool)
GLOBAL_HS_MAP[:] = False


def draw_rect(img, roi, rect_color=(255, 0, 0)):
    '''
    Draw rectangle(wapper cv2.rectangle)
    '''
    cv2.rectangle(img, (roi.x, roi.y), (roi.ex, roi.ey), rect_color, 2)


def skin_color_filter_with_hs_space(filtered_img, hsv_img, face_color_hs_map):
    '''
    Skin color is drawn with black color.
    '''
    for y, pixel_line in enumerate(hsv_img):
        for x, pixel in enumerate(pixel_line):
            h, s, v = pixel
            if face_color_hs_map.item(h, s) == 1:
                filtered_img[y][x] = [0, 0, 0]


def reduce_color(color_img):
    '''
    Reduce color in img by kmean
    '''
    img_array = color_img.reshape((-1, 3))
    img_array = np.float32(img_array)

    class_num = 3
    # define criteria, number of clusters(class_num) and apply kmeans()
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 10, 1.0)
    _, label, center = cv2.kmeans(img_array, class_num, None, criteria, 10,
                                  cv2.KMEANS_RANDOM_CENTERS)

    # Now convert back into uint8, and make original image
    center = np.uint8(center)
    res = center[label.flatten()]
    return res.reshape((color_img.shape))


def display_hist(img):
    '''
    Display histogram
    '''
    def min_max(x, axis=None):
        min_value = x.min(axis=axis, keepdims=True)
        max_value = x.max(axis=axis, keepdims=True)
        return (x - min_value) / (max_value - min_value)

    # img = min_max(img)
    hist, bins = np.histogram(img, bins=256)
    # print(hist)
    scales = []
    for i in range(1, len(bins)):
        scales.append((bins[i-1]+bins[i])/2)
    plt.bar(scales, hist)
    plt.pause(.00001)


def extract_contours(gray_img):
    '''
    Extract contours
    '''
    contours, _ = cv2.findContours(gray_img,
                                   cv2.RETR_LIST,
                                   cv2.CHAIN_APPROX_NONE)
    rois = []
    for contour in contours:
        # calc contours area
        area = cv2.contourArea(contour)

        # removeing noise(`too big` area and `too small` area)
        if area < (1e4//3) or 1e5 < area:
            continue

        # get rect
        if contour.size > 0:
            x, y, w, h = cv2.boundingRect(contour)
            rois.append(Roi(x, y, w, h))
    return rois


SAVE_IMG_COUNT = 0


def predict_sign_language(imgs, model):
    print('------------prediction----------')
    predictions = model.predict(imgs, batch_size=1, verbose=0)

    count = [0] * len(predictions[0])
    for pre in predictions:
        index = np.argmax(pre)
        count[index] += 1
        print(index)

    print('count: {}\n argmax: {}'.format(count, np.argmax(np.array(count))))


def detect_hand_with_depth(depth_gray_img, color_img):
    global SAVE_IMG_COUNT
    global GLOBAL_HS_MAP
    min_value = np.amin(depth_gray_img)
    # print(min_value)
    extract_area_map = ((depth_gray_img < (min_value + 70)) &
                        (depth_gray_img > (min_value + 30))) * depth_gray_img

    rois = extract_contours(extract_area_map)
    rois.sort(key=lambda r: r.area)
    rois.reverse()

    # binary image
    _, hand_bi_img = cv2.threshold(extract_area_map, 30, 70, cv2.THRESH_BINARY)

    hand_area_bi_imgs = []
    skin_rois = []
    for i, roi in enumerate(rois):
        if i > 2:
            break
        skin_rois.append(roi)
        hand_area_bi_imgs.append(hand_bi_img[roi.y:roi.ey, roi.x:roi.ex])
        # display_hist(hand_area_bi_imgs)
        cv2.imwrite('temp/{}.png'.format(SAVE_IMG_COUNT), hand_area_bi_imgs[i])
        SAVE_IMG_COUNT = SAVE_IMG_COUNT + 1

    # draw roi
    for roi in skin_rois:
        c_roi = roi.get_center_roi()
        draw_rect(color_img, roi, (0, 255, 0))
        draw_rect(color_img, c_roi, (0, 255, 0))

    return extract_area_map, hand_bi_img, hand_area_bi_imgs


class Roi():
    def __init__(self, x, y, w, h):
        self.x = x
        self.y = y
        self.w = w
        self.h = h
        self.ex = x + w
        self.ey = y + h
        self.area = w * h

    def get_center_roi(self):
        x = self.x + (self.w//2) - 10
        y = self.y + (self.h//2) - 10
        w = 20
        h = 20
        return Roi(x, y, w, h)


def get_hs_map_in_roi(roi, color_img):
    hs_map = np.arange(256*256).reshape(256, 256).astype(bool)
    hs_map[:] = False

    skin_roi_img = color_img[roi.y: roi.ey, roi.x:roi.ex]
    hsv_img = cv2.cvtColor(skin_roi_img, cv2.COLOR_BGR2HSV)
    for pixel_line in hsv_img:
        for pixel in pixel_line:
            h, s, v = pixel
            hs_map[h][s] = True

    return hs_map


class HandDetection():
    '''
    Hand regions detector.
    '''
    def __init__(self):
        pass


class RealSenseControl():
    '''
    Real Sense Controler.
    '''
    def __init__(self, img_width=640, img_height=480, fps=30,
                 target_distance=2.0):
        '''
        Initialize real sense camera
        '''
        # Configure depth and color streams
        pipeline = rs.pipeline()
        config = rs.config()
        config.enable_stream(
            rs.stream.depth, img_width, img_height, rs.format.z16, fps)
        config.enable_stream(
            rs.stream.color, img_width, img_height, rs.format.bgr8, fps)

        # start streaming
        profile = pipeline.start(config)

        # get depth scale
        #   distance[m] = depth * depth_scale
        depth_sensor = profile.get_device().first_depth_sensor()
        depth_scale = depth_sensor.get_depth_scale()

        #   threshold of target region(unit of target_distance is meter)
        distance_max = target_distance/depth_scale
        print('Depth Scale = {} -> {}'.format(depth_scale, distance_max))

        # align
        align_to = rs.stream.color
        align = rs.align(align_to)

        self.pipeline = pipeline
        self.distance_max = distance_max
        self.align = align

    def get_distance_max(self):
        return self.distance_max

    def get_imgs(self):
        '''
        get frames(depth/color)
        '''
        frames = self.pipeline.wait_for_frames()
        # Align the depth frame to color frame
        aligned_frames = self.align.process(frames)
        # Get aligned frames and get images
        return (np.asanyarray(aligned_frames.get_depth_frame().get_data()),
                np.asanyarray(aligned_frames.get_color_frame().get_data()))

    def stop(self):
        '''
        stop pipeline
        '''
        self.pipeline.stop()


def main():
    '''
    entry point
    '''
    rsc = RealSenseControl()
    # for prediction
    sign_start = False
    pred_imgs = []
    # model = load_model('hand_sign_model.h5')
    model = model_from_json(open('hand_sign_model.json').read())
    try:
        while True:
            depth_img, color_img = rsc.get_imgs()
            if depth_img is None or color_img is None:
                continue
            color_img = cv2.resize(color_img, dsize=(480, 360))

            # Depth画像前処理(2m以内を画像化)
            depth_img = cv2.resize(depth_img, dsize=(480, 360))

            # distance_maxより低いもののみ抽出
            depth_img = (depth_img < rsc.get_distance_max()) * depth_img
            depth_graymap = depth_img * 255. / rsc.get_distance_max()
            depth_graymap = depth_graymap.reshape((360, 480)).astype(np.uint8)

            hand_gray_img, hand_bi_img, hand_area_bi_imgs = detect_hand_with_depth(
                depth_graymap, color_img)

            if not sign_start and len(hand_area_bi_imgs) > 1:
                sign_start = True
            if sign_start and len(hand_area_bi_imgs) > 1:
                hand_area_bi_imgs[0] = cv2.resize(
                    hand_area_bi_imgs[0], dsize=(320, 240))
                hand_area_bi_imgs[1] = cv2.resize(
                    hand_area_bi_imgs[1], dsize=(320, 240))
                pred_imgs.append(
                    hand_area_bi_imgs[0].reshape(320, 240, 1) / 255.0)
                pred_imgs.append(
                    hand_area_bi_imgs[1].reshape(320, 240, 1) / 255.0)
            if sign_start and len(hand_area_bi_imgs) < 2:
                predict_sign_language(np.array(pred_imgs), model)
                sign_start = False
                pred_imgs = []

            depth_graymap = depth_graymap.reshape((360, 480)).astype(np.uint8)

            # display
            cv2.namedWindow('RealSense', cv2.WINDOW_AUTOSIZE)
            # cv2.namedWindow('RealSense2', cv2.WINDOW_AUTOSIZE)
            cv2.namedWindow('RealSense3', cv2.WINDOW_AUTOSIZE)
            cv2.namedWindow('RealSense4', cv2.WINDOW_AUTOSIZE)
            cv2.namedWindow('RealSense5', cv2.WINDOW_AUTOSIZE)
            imgs = cv2.hconcat([color_img])
            cv2.imshow('RealSense', imgs)
            # cv2.imshow('RealSense2', hand_gray_img)
            cv2.imshow('RealSense3', hand_bi_img)
            # if len(hand_area_bi_imgs) > 1:
            #     cv2.imshow('RealSense4', hand_area_bi_imgs[0])
            #     cv2.imshow('RealSense5', hand_area_bi_imgs[1])
            if cv2.waitKey(1) & 0xff == 27:
                break

    finally:
        # ストリーミング停止
        rsc.stop()
        cv2.destroyAllWindows()


main()
