from pytube import YouTube
import moviepy.editor as mp
import os,sys
import requests as req
from bs4 import BeautifulSoup as bs
import re
# Folder to save the MP3
sep = os.sep
# save path is current user Music directory subfolder "Youtube Downloads" (created if doesn't exist)
save_path = os.path.expanduser("~" + sep + "Music" + sep + "Youtube Downloads" )
# passes url argument: ex: https://www.youtube.com/watch?v=dQw4w9WgXcQ
video_url = sys.argv[1]

# Getting cleaned title
response = req.get(video_url)
soup = bs(response.text,"html.parser")  
title_elem = soup.find('title')
if title_elem:
    full_title = title_elem.text
else:
    full_title = "Title not found"
cleaned_title = re.sub(r'\s*-\sYoutube','',full_title,flags=re.IGNORECASE)
# print(cleaned_title)


def download_audio(url, output_path):
    yt = YouTube(url)
    audio_stream = yt.streams.get_audio_only()
    audio_stream.download(output_path=output_path)
    return audio_stream.default_filename

def convert_to_mp3(input_file, output_file):
    clip = mp.AudioFileClip(input_file)
    clip.write_audiofile(output_file)
    clip.close()

# downloads audio only
audio_filename = download_audio(video_url, save_path)

# creates a name for a new mp3 file
output_filename = cleaned_title + ".mp3"

# converts audio to mp3 and places it into a save path
convert_to_mp3(os.path.join(save_path, audio_filename), os.path.join(save_path, output_filename))

# deletes audio only file
os.remove(os.path.join(save_path, audio_filename))

# def delete_file(file_path):
#     if os.path.exists(file_path):
#         os.remove(file_path)
#         print(f"Deleted: {file_path}")
#     else:
#         print(f"The file does not exist: {file_path}")

# delete_file(os.path.join(save_path,audio_filename))
