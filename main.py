from flask import Flask, request, Response,jsonify
from sample import caption
import torch
import matplotlib.pyplot as plt
import numpy as np 
import argparse
import pickle 
import os
from torchvision import transforms 
from build_vocab import Vocabulary
from model import EncoderCNN, DecoderRNN
from PIL import Image
import pyttsx3
from flask import make_response, send_file
app = Flask(__name__)
import os
@app.route('/')
def index():
    return "Backend running on port 5000"

@app.route('/predict', methods=['POST','GET'])
def test():
    if request.method == 'POST':
        file = request.files['image']
        img = Image.open(file.stream)
        img = img.save("img1.jpeg")
        text=caption(vocab,'img1.jpeg')
        text=text[8:-5]

        return {"predicted": text}
    else :
        return "I'm alive!"
if __name__ == "__main__":
    with open('data/vocab.pkl', 'rb') as f:
        vocab = pickle.load(f)
    
    
    app.run(debug=True,port=8080)
