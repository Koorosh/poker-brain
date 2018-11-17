import requests
import json
import numpy as np
from PIL import Image


# TODO: Tensorflow API provides equal functionality
def load_image_into_numpy_array(image_data):
  (im_width, im_height) = image_data.size
  return np.array(image_data.getdata()).reshape(
      (im_height, im_width, 3)).astype(np.uint8)


image = Image.open('/Users/avor/projects/koorosh/poker-vision/images/POKER20181114/Poker2018/JPEGImages/table_001.jpg')

image = load_image_into_numpy_array(image)

image = np.expand_dims(image, 0)

data = json.dumps({"instances":  image.tolist()})

json_response = requests.post("http://localhost:8501/v1/models/2018-11-14_faster_rcnn_inception_v2_coco:predict", data=data)

print(json_response.text)
