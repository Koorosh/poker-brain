import requests
import json
import numpy as np
from PIL import Image


# TODO: Tensorflow API provides equal functionality
def load_image_into_numpy_array(image_data):
  (im_width, im_height) = image_data.size
  return np.array(image_data.getdata()).reshape(
      (im_height, im_width, 3)).astype(np.uint8)


image = Image.open('/Users/avor/lab/poker-brain/data/test_images/test_image_1.jpg')

image = load_image_into_numpy_array(image)

image = np.expand_dims(image, 0)

data = json.dumps({"instances":  image.tolist()})

json_response = requests.post("http://localhost:8501/v1/models/saved_model:predict", data=data)

print(json_response.text)
