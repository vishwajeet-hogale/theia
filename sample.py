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


# Device configuration
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

def load_image(image_path, transform=None):
    image = Image.open(image_path).convert('RGB')
    image = image.resize([224, 224], Image.LANCZOS)
    
    if transform is not None:
        image = transform(image).unsqueeze(0)
    
    return image

def caption(vocab,imagepath):
    
    # Image preprocessing
    transform = transforms.Compose([
        transforms.ToTensor(), 
        transforms.Normalize((0.485, 0.456, 0.406), 
                             (0.229, 0.224, 0.225))])
    
    # Load vocabulary wrapper
    

    # Build models
    encoder = EncoderCNN(256).eval()  # eval mode (batchnorm uses moving mean/variance)
    decoder = DecoderRNN(256, 512, len(vocab), 1)
    encoder = encoder.to(device)
    decoder = decoder.to(device)

    # Load the trained model parameters
    encoder.load_state_dict(torch.load('models/encoder-5-3000.pkl'))
    decoder.load_state_dict(torch.load('models/decoder-5-3000.pkl'))

    # Prepare an image
    image = load_image(imagepath, transform)
    image_tensor = image.to(device)
    
    # Generate an caption from the image
    feature = encoder(image_tensor)
    sampled_ids = decoder.sample(feature)
    sampled_ids = sampled_ids[0].cpu().numpy()          # (1, max_seq_length) -> (max_seq_length)
    
    # Convert word_ids to words
    sampled_caption = []
    for word_id in sampled_ids:
        word = vocab.idx2word[word_id]
        sampled_caption.append(word)
        if word == '<end>':
            break
    sentence = ' '.join(sampled_caption)
    
    # Print out the image and the generated caption
    print (sentence)
    image = Image.open('png/example.png')
    plt.imshow(np.asarray(image))
    return (sentence)
##if __name__ == '__main__':
##    parser = argparse.ArgumentParser()
##    parser.add_argument('--image', type=str, required=True, help='input image for generating caption')
##    parser.add_argument('--encoder_path', type=str, default='models/encoder-5-3000.pkl', help='path for trained encoder')
##    parser.add_argument('--decoder_path', type=str, default='models/decoder-5-3000.pkl', help='path for trained decoder')
##    parser.add_argument('--vocab_path', type=str, default='data/vocab.pkl', help='path for vocabulary wrapper')
##    
##    # Model parameters (should be same as paramters in train.py)
##    parser.add_argument('--embed_size', type=int , default=256, help='dimension of word embedding vectors')
##    parser.add_argument('--hidden_size', type=int , default=512, help='dimension of lstm hidden states')
##    parser.add_argument('--num_layers', type=int , default=1, help='number of layers in lstm')
##    args = parser.parse_args()
##    caption()
