import io
import os

# Imports the Google Cloud client library
from google.cloud import speech
from google.cloud.speech import enums, types

# Instantiates a client
client = speech.SpeechClient()

# Loads the audio into memory
with io.open("path/to/audio.mp3", "rb") as audio_file:
    content = audio_file.read()
    audio = types.RecognitionAudio(content=content)

# Configures the audio file to be transcribed
config = types.RecognitionConfig(
    encoding=enums.RecognitionConfig.AudioEncoding.LINEAR16,
    sample_rate_hertz=16000,
    language_code="en-US"
)

# Performs speech recognition on the audio file
response = client.recognize(config, audio)

# Prints the transcribed text
for result in response.results:
    print(result.alternatives[0].transcript)
