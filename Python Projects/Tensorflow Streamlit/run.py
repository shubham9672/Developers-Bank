from predict import predict_score
from fastapi import FastAPI, Request
from PIL import Image
import requests
from io import BytesIO
import numpy as np

app = FastAPI()

@app.get("/")
async def root():   
    return {"message": "Hello World"}


@app.post("/predict-score-quality-image/")
async def create_upload_file(request: Request):
    body = await request.json()
    image  = body['image'] 
    if image.startswith('http'):
        response = requests.get(image)
        img = np.array(Image.open(BytesIO(response.content)))
        score, quality = predict_score(img)

    return {"Score: ": score,
            "Quality: ":quality}

# uvicorn run:app