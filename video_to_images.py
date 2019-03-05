import shutil

import cv2
import numpy as np
from keras import backend as K
from keras.layers import (Activation, Conv2D, Dense, Dropout, Flatten,
                          MaxPooling2D)
from keras.models import Sequential
from keras.preprocessing.image import ImageDataGenerator
from pathlib2 import Path


"""
depth videos -> images
(ignore color videos)


[`video_data_dirs`: directory structure of immediately after video recode]
--------------------------------------------------------------------------
raw_data/
    good_morning/
        depth/
            1_depth.avi
            2_depth.avi
            ...
    grad/
        depth/
            1_depth.avi
            2_depth.avi
            ...
    thanks/
        depth/
            1_depth.avi
            2_depth.avi
            ...

[`data_dir`: directory structure of learning possible]
------------------------------------------------------
data/
    train/
        good_morning/
            1.png
            2.png
            ...
        grad/
            1.png
            2.png
            ...
        thanks/
            1.png
            2.png
            ...
    validation/
        good_morning/
            1.png
            2.png
            ...
        grad/
            1.png
            2.png
            ...
        thanks/
            1.png
            2.png
            ...
"""


# if data directory tree exist, remove it
def clean_data_dir(data_dir):
    if data_dir.exists():
        shutil.rmtree(data_dir)


# create data directory tree
def create_data_dir(video_data_dirs, data_dir):
    '''
    create data dir

    Parameters
    ----------
    video_data_dirs: Path
        Path list of `raw_data` directorys
        e.g)
        [PosixPath('raw_data/thanks'),
         PosixPath('raw_data/good_morning'),
         PosixPath('raw_data/grad')]

    Returns
    -------
    save_dir_dic: dict[dict]
        Created directory names
        e.g)
        data/train/xxxxx
        data/validation/xxxxx
    '''
    # `data/train/xxxxx`
    save_dir_dic = {"train": {}, "validation": {}}
    for d in video_data_dirs:
        Path(data_dir / "train" / d.name).mkdir(parents=True, exist_ok=True)
        save_dir_dic["train"][d.name] = Path(data_dir / "train" / d.name)
    # `data/validation/xxxxx`
    for d in video_data_dirs:
        Path(data_dir / "validation" / d.name).mkdir(
            parents=True, exist_ok=True)
        save_dir_dic["validation"][d.name] = \
            Path(data_dir / "validation" / d.name)

    return save_dir_dic


# translate video to images(./raw_data -> ./data)
def video_in_data_dir_to_images(video_data_dirs, save_dir_dic):
    def video_to_images(video_file, save_dir, index):
        # Video to frames
        cap = cv2.VideoCapture(video_file)
        while cap.isOpened():
            flag, image = cap.read()  # Capture frame-by-frame
            if not flag:
                break
            index += 1
            cv2.imwrite("{}/{}".format(save_dir, str(index) + ".png"), image)

        cap.release()  # When everything done, release the capture
        return index

    for d in video_data_dirs:
        index = 0
        videos = list(d.glob("*depth*"))
        for video in videos:
            index = video_to_images(
                str(video), str(save_dir_dic["train"][d.name]), index
            )


def zero_origin_numbering(dir_name):
    dir_name.mkdir(exist_ok=True)
    temp_dir_name = Path(str(dir_name) + '_temp')
    temp_dir_name.mkdir(exist_ok=True)

    # 0 origin numbering
    for i, f in enumerate(dir_name.iterdir()):
        move_src = str(f)
        move_dst = '{}/{}.png'.format(str(temp_dir_name), i)
        shutil.move(move_src, move_dst)

    for f in temp_dir_name.iterdir():
        shutil.move(str(f), str(dir_name))

    temp_dir_name.rmdir()


def divide_into_train_and_validation(
        train_dir, division_num=0.1):
    # train_dir = Path('data/train')

    # scanning tree train_dir tree
    train_dirs = [f for f in train_dir.iterdir() if f.is_dir()]

    # get file count of each directorys
    file_count_dict = {}
    for d in train_dirs:
        file_count_dict[d] = len(list(d.iterdir()))

    # calc validate count
    for name, count in file_count_dict.items():
        if count < 10:
            raise RuntimeError(
                'Too few data count: data count is {}'.format(count))
        sampling_count = int(count * division_num)
        # sampling_nums = np.random.choice(count, sampling_count, replace=False)
        sampling_start_num = count - sampling_count
        # move any file: train -> validation
        sampling_num = 0
        for i in range(sampling_start_num, count):
            move_src = Path(name / '{}.png'.format(i))
            move_dst = Path(
                '{}/{}.png'.format(
                    str(name).replace('train', 'validation'), sampling_num
                )
            )
            sampling_num += 1
            shutil.move(move_src, move_dst)


def create_model(channel_num=1, img_width=150, img_height=150):

    if K.image_data_format() == "channels_first":
        input_shape = (channel_num, img_width, img_height)
    else:
        input_shape = (img_width, img_height, channel_num)

    model = Sequential()
    model.add(Conv2D(32, (3, 3), input_shape=input_shape))
    model.add(Activation("relu"))
    model.add(MaxPooling2D(pool_size=(2, 2)))

    model.add(Conv2D(32, (3, 3)))
    model.add(Activation("relu"))
    model.add(MaxPooling2D(pool_size=(2, 2)))

    model.add(Conv2D(64, (3, 3)))
    model.add(Activation("relu"))
    model.add(MaxPooling2D(pool_size=(2, 2)))

    model.add(Flatten())
    model.add(Dense(64))
    model.add(Activation("relu"))
    model.add(Dropout(0.5))
    model.add(Dense(1))
    model.add(Activation("sigmoid"))

    model.compile(loss="binary_crossentropy", optimizer="rmsprop",
                  metrics=["accuracy"])

    return model


def generate_input_data(
        train_data_dir="data/train",
        validation_data_dir="data/validation",
        img_width=150,
        img_height=150,
        batch_size=16,
        class_mode="binary"):
    # this is the augmentation configuration we will use for training
    train_datagen = ImageDataGenerator(
        rescale=1.0 / 255, shear_range=0.2, zoom_range=0.2, horizontal_flip=True
    )

    # this is the augmentation configuration we will use for testing:
    # only rescaling
    test_datagen = ImageDataGenerator(rescale=1.0 / 255)

    train_generator = train_datagen.flow_from_directory(
        train_data_dir,
        target_size=(img_width, img_height),
        batch_size=batch_size,
        class_mode=class_mode,
    )

    validation_generator = test_datagen.flow_from_directory(
        validation_data_dir,
        target_size=(img_width, img_height),
        batch_size=batch_size,
        class_mode=class_mode,
    )

    return train_generator, validation_generator


# def prepare():
#     # `data` directory is for training directory
#     data_dir = Path("data")
#
#     # raw video data
#     video_data_root_dir = Path("raw_data")
#     video_data_dirs = [d for d in video_data_root_dir.iterdir() if d.is_dir()]
#
#     # clean to save directory
#     clean_data_dir(data_dir)
#
#     # create `data` directory
#     save_dir_dic = create_data_dir(video_data_dirs, data_dir)
#
#     # translate videos to images
#     video_in_data_dir_to_images(video_data_dirs, save_dir_dic)

def prepare():
    # `data` directory is for training directory
    data_dir = Path("data")

    # raw video data
    video_data_root_dir = Path("raw_data")
    video_data_dirs = [d for d in video_data_root_dir.iterdir() if d.is_dir()]

    # clean to save directory
    clean_data_dir(data_dir)

    # create `data` directory
    save_dir_dic = create_data_dir(video_data_dirs, data_dir)

    # copy data(raw_data -> data/train)
    # TODO

    # translate videos to images
    divide_into_train_and_validation(Path('data/train'))


def main():
    # prepare()

    model = create_model(channel_num=3, img_width=320, img_height=240)

    train_generator, validation_generator = generate_input_data(
        img_width=320, img_height=240)

    batch_size = 16
    nb_train_samples = 1500
    nb_validation_samples = 100

    model.fit_generator(
        train_generator,
        steps_per_epoch=nb_train_samples // batch_size,
        epochs=50,
        validation_data=validation_generator,
        validation_steps=nb_validation_samples // batch_size,
    )

    # save model
    model_json = model.to_json()
    open('hand_sign_model.json', 'w').write(model_json)
    model.save_weights("hand_sign_model.h5")


main()
# for f in Path('data/train').iterdir():
#     if f.is_dir():
#         zero_origin_numbering(f)
# divide_into_train_and_validation(Path('data/train'))
# prepare()
# main()
