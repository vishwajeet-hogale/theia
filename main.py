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

vocab = None 
# with open('vocab.pkl', 'rb') as f:
#     vocab = pickle.load(f)

@app.route('/')
def index():
    return "Backend running on port 8080"

@app.route('/predict', methods=['POST','GET'])
def test():
    with open('vocab.pkl', 'rb') as f:
        vocab = pickle.load(f)
    if request.method == 'POST':
        # with open('vocab.pkl', 'rb') as f:
        #     vocab = pickle.load(f)  
        file = request.files['image']
        img = Image.open(file.stream)
        img = img.save("img1.jpeg")
        text=caption(vocab,'img1.jpeg')
        text=text[8:-5]


        return {"predicted": text}
    else :
        return "I'm alive!"
if __name__ == "__main__":
    with open('vocab.pkl', 'rb') as f:
        vocab = pickle.load(f)
    f = open("vocab.pkl","rb")
    vocab = pickle.load(f)
    f.close()


    app.run(debug=True,port=8080)
