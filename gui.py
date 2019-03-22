# -*- coding: utf-8 -*-

import sys,os
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import (QWidget, QApplication, QLineEdit,
                             QHBoxLayout, QTextEdit, QGridLayout,
                             QMainWindow, QLabel, QGraphicsView,
                             QGraphicsScene, QGraphicsPixmapItem)
import numpy as np
import cv2
from depth_gray import *
from keras.models import model_from_json
import time


class LearnViewer(QWidget):
    def __init__(self, parent=None, video_path=None):
        super().__init__()
        self.setFixedSize(320, 240)
        self.layout = QHBoxLayout()
        self.setup_video_window(video_path)
        self.setLayout(self.layout)

    def mousePressEvent(self, event):
        if self.timer.isActive():
            self.timer.stop()
        else:
            self.timer.start(10)

    def setup_video_window(self, video_path):
        self.capture = cv2.VideoCapture(video_path)
        if not self.capture.isOpened():
            raise 'Video IO Error'
        # self.capture.set(cv2.CAP_PROP_FRAME_WIDTH, self.v_width)
        # self.capture.set(cv2.CAP_PROP_FRAME_HEIGHT, self.v_height)
        # self.setGeometry(0, 0, 300, 300)

        self.item = None
        self.video_view = QGraphicsView()
        self.video_scene = QGraphicsScene()
        self.video_view.setScene(self.video_scene)

        self.set()

        # update timer
        self.timer = QtCore.QTimer(self.video_view)
        self.timer.timeout.connect(self.set)
        self.timer.start(1)
        self.timer.stop()

    def set(self):
        ret, color_img = self.capture.read()
        if not ret:
            self.capture.set(cv2.CAP_PROP_POS_FRAMES, 0)
            return
        color_img = cv2.resize(color_img, dsize=(300, 200))
        color_img = cv2.cvtColor(color_img, cv2.COLOR_BGR2RGB)
        height, width, dim = color_img.shape
        bytes_perline = dim * width
        self.image = QtGui.QImage(
            color_img.data, width, height, bytes_perline,
            QtGui.QImage.Format_RGB888
        )
        if self.item is not None:
            self.video_scene.removeItem(self.item)
        self.item = QGraphicsPixmapItem(
            QtGui.QPixmap.fromImage(self.image))
        self.video_scene.addItem(self.item)
        self.video_view.setScene(self.video_scene)

        self.layout.addWidget(self.video_view)
        self.setLayout(self.layout)


class MainViewer(QMainWindow):

    repeatTime = 0  # ms
    is_reco = False
    font = QtGui.QFont('Times', 40, QtGui.QFont.Bold)
    sign_start = False
    pred_imgs = []
    model = model_from_json(open('hand_sign_model.json').read())
    model.load_weights('hand_sign_model.h5')

    def __init__(self, parent=None):
        super(MainViewer, self).__init__(parent)

        self.setFixedSize(1010, 820)
        # setup realsense
        self.rsc = RealSenseControl()

        self.widget = QWidget()
        self.grid = QGridLayout()

        # setup window
        self.setup_recognition_window()
        self.setup_labels()

        # sub window
        self.grid.addWidget(QLabel('<font size=6 color="BLUE">"おはよう"のサンプル手話</font>'), 0, 700)
        self.grid.addWidget(LearnViewer(video_path='test1.mp4'), 1, 700)
        self.grid.addWidget(QLabel('<font size=6 color="RED">"うれしい"のサンプル手話</font>'), 16, 700)
        self.grid.addWidget(LearnViewer(video_path='test2.mp4'), 17, 700)
        self.grid.addWidget(QLabel('<font size=6 color="GREEN">"ありがとう"のサンプル手話</font>'), 29, 700)
        self.grid.addWidget(LearnViewer(video_path='test3.mp4'), 30, 700)

        self.widget.setLayout(self.grid)
        self.setCentralWidget(self.widget)

    def setup_labels(self):
        self.predicted_label_dict = {
            'good_morning': '<font color="BLUE">おはよう</font>',
            'grad': '<font color="RED">うれしい</font>',
            'thanks': '<font color="GREEN">ありがとう</font>',
            'in_recognition': '<font color="BLACK">認識中{}</font>'
        }
        prepare_label = QLabel(
            '<font color="BLACK">カメラ映像をクリック!!<br>\
            手話の認識を開始します。</font>')
        prepare_label.setFont(self.font)
        self.label = prepare_label
        self.label.setObjectName('label')
        self.grid.addWidget(self.label, 30, 2)

    def setup_recognition_window(self):
        self.item = None
        self.reco_view = QGraphicsView()
        self.reco_scene = QGraphicsScene()
        self.reco_view.setScene(self.reco_scene)

        self.reco()
        # update timer
        timer = QtCore.QTimer(self.reco_view)
        timer.timeout.connect(self.reco)
        timer.start(self.repeatTime)

    def mousePressEvent(self, event):
        if self.is_reco:
            self.is_reco = False
            self.label.setText(
                '<font color="BLACK">カメラ映像をクリック!!<br>\
                手話の認識を開始します。</font>')
        else:
            self.is_reco = True
            self.label.setText('<font color="BLACK">手話を行ってください</font>')

    def reco(self):
        depth_img, color_img = self.rsc.get_imgs(fill=False)
        if depth_img is None or color_img is None:
            return

        color_img = cv2.resize(color_img, dsize=(480, 360))

        # Depth画像前処理(2m以内を画像化)
        depth_img = cv2.resize(depth_img, dsize=(480, 360))

        # distance_maxより低いもののみ抽出
        depth_img = (depth_img < self.rsc.get_distance_max()) * depth_img
        depth_img = depth_img * 255. / self.rsc.get_distance_max()
        depth_img = \
            depth_img.reshape((360, 480)).astype(np.uint8)

        _, _, hand_area_img = \
            detect_hand_with_depth(depth_img, color_img)

        if self.is_reco:
            if not self.sign_start and hand_area_img is not None:
                self.sign_start = True
            if self.sign_start and hand_area_img is not None:
                pass
                hand_area_img = cv2.resize(
                    hand_area_img, dsize=(320, 320))
                self.pred_imgs.append(
                    hand_area_img.reshape(320, 320, 1) / 255.0)
                if len(self.pred_imgs) > 4:
                    self.label.setText(
                        self.predicted_label_dict['in_recognition'].format(
                            '.' * int(len(self.pred_imgs) / 3)))
            if self.sign_start and hand_area_img is None and \
                    len(self.pred_imgs) > 5:
                sign = predict_sign_language(np.array(self.pred_imgs), self.model)
                # update label
                self.label.setText(self.predicted_label_dict[sign])
                self.sign_start = False
                self.pred_imgs = []

        color_img = cv2.resize(color_img, dsize=(640, 480))
        color_img = cv2.cvtColor(color_img, cv2.COLOR_BGR2RGB)

        height, width, dim = color_img.shape
        bytes_perline = dim * width
        self.image = QtGui.QImage(
            color_img.data, width, height, bytes_perline,
            QtGui.QImage.Format_RGB888
        )
        if self.item is not None:
            self.reco_scene.removeItem(self.item)
        self.item = QGraphicsPixmapItem(
            QtGui.QPixmap.fromImage(self.image))
        self.reco_scene.addItem(self.item)
        self.reco_view.setScene(self.reco_scene)
        self.grid.addWidget(self.reco_view, 0, 0, 30, 5)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    viewer = MainViewer()
    viewer.show()
    # viewer = LearnViewer()
    # viewer.show()
    sys.exit(app.exec_())
