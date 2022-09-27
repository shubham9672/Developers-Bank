import streamlit as st
from PIL import Image 
from predict import predict_score
from tensorflow.keras.models import load_model
import numpy as np


@st.cache(allow_output_mutation=True)
def load_model():
    model = load_model('python/tensorflow-streamlit/model/model_resnet50.h5')
    return model

model = load_model()

st.title("--Image Quality Evaluate App--")
st.write('\n')

st.sidebar.title("Upload Image")

#Disabling warning
st.set_option('deprecation.showfileUploaderEncoding', False)
#Choose your own image
uploaded_files = st.sidebar.file_uploader(" ",type=['png', 'jpg', 'jpeg'], accept_multiple_files=True)


if st.sidebar.button("Click Here to Classify"):
    if uploaded_files is None:
        st.sidebar.write("Please upload an Image to Classify")
    else:
        for uploaded_file in uploaded_files:
            img = np.array(Image.open(uploaded_file))
            predictions = predict_score(model, img)
            st.image(img)
            st.latex(predictions)

#  Run App: streamlit run app.py 