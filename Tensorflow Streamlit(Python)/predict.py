
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
from utils.utils import calc_mean_score
import numpy as np
import cv2


THRESHOLD = 5


def convert_rgr_rgb(img):
    if img.ndim == 3 and img.shape[2] > 3:
        img = img[:, :, :3]
    img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)

    return img


def predict_score(model, cv_img):

    img_load_dims = (224, 224)
    img = convert_rgr_rgb(cv_img)
    img = cv2.resize(img, img_load_dims) 

    np_img = np.expand_dims(img, axis=0)
    predictions = model.predict(np_img)

    score = calc_mean_score(predictions)
    if score > 5:
        quality = "Hight"
    else:
        quality = "Low"
    return score, quality
