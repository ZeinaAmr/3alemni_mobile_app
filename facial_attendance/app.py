from flask import Flask, request, jsonify
import numpy as np
from PIL import Image, ImageOps
import io
import torch
from facenet_pytorch import InceptionResnetV1, MTCNN

app = Flask(__name__)
mtcnn = MTCNN(image_size=160, margin=20)
model = InceptionResnetV1(pretrained='vggface2').eval()

known_user = {'embedding': None}

def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

@app.route('/register', methods=['POST'])
def register():
    file = request.files['image']
    img = Image.open(io.BytesIO(file.read()))
    img = ImageOps.exif_transpose(img).convert('RGB')

    face = mtcnn(img)
    if face is None:
        return jsonify({'success': False, 'message': '❌ No face detected'})

    embedding = model(face.unsqueeze(0)).detach().numpy()[0]
    known_user['embedding'] = embedding.tolist()
    return jsonify({'success': True, 'message': '✅ Face registered'})

@app.route('/verify', methods=['POST'])
def verify():
    if known_user['embedding'] is None:
        return jsonify({'success': False, 'message': '❌ No registered face'})

    file = request.files['image']
    img = Image.open(io.BytesIO(file.read()))
    img = ImageOps.exif_transpose(img).convert('RGB')

    face = mtcnn(img)
    if face is None:
        return jsonify({'success': False, 'message': '❌ No face detected'})

    embedding = model(face.unsqueeze(0)).detach().numpy()[0]
    similarity = cosine_similarity(embedding, np.array(known_user['embedding']))
    matched = bool(similarity > 0.6)

    return jsonify({'success': True, 'matched': matched, 'similarity': float(similarity)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
