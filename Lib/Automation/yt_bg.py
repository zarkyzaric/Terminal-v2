from pytube import YouTube
import os,sys
# Folder to save the MP3
save_path = "C:/Users/LEPALALA/Music/YT Download/"

# Get YT object
video = YouTube(sys.argv[1])

# Get audio only
audio_stream = video.streams.first()

# Download and format File name
audio_stream.download(output_path=save_path, filename=video.title + ".mp3")
