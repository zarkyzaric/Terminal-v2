from pytube import YouTube
import moviepy.editor as mp
import os
import re
import requests as req
from bs4 import BeautifulSoup as bs
import sys
# Folder to save the MP3
user_path = os.path.expanduser('~')
save_path = os.path.join(user_path, 'Music')
if not os.path.exists(save_path):
    os.makedirs(save_path)

def get_title(video_url):
    response = req.get(video_url)
    soup = bs(response.text, "html.parser")
    title_elem = soup.find('title')
    if title_elem:
        title = title_elem.text
    else:
        title = "Title not found"
    return title

def clear_title(title, trash):
    for pattern in trash:
        title = re.sub(pattern, '', title, flags=re.IGNORECASE)
    return title

def download_audio(url, output_path):
    try:
        yt = YouTube(url)
        audio_stream = yt.streams.filter(only_audio=True).first()
        if not audio_stream:
            raise Exception("No audio stream found")
        audio_stream.download(output_path=output_path)
        return audio_stream.default_filename
    except Exception as e:
        print(f"Error downloading audio: {e}")
        sys.exit(1)

def convert_to_mp3(input_file, output_file):
    try:
        clip = mp.AudioFileClip(input_file)
        clip.write_audiofile(output_file)
        clip.close()
    except Exception as e:
        print(f"Error converting to MP3: {e}")
        sys.exit(1)

# save path is current user Music directory subfolder "Youtube Downloads" (created if doesn't exist)
# passes url argument: ex: https://www.youtube.com/watch?v=dQw4w9WgXcQ

video_url = "https://www.youtube.com/watch?v=MIrlVhEH_g8"

# Getting title
title = get_title(video_url)
# Trash strings that can appear in title
trash = [
    r'\s*\-\s*Youtube',
    r'\s?\((OFFICIAL\s)?(MUSIC\s)?(VIDEO|AUDIO)\s?\d*\)',
    r'\s?\((320|128)\s?(kbps)?\)',
    r'\s?\(Snap2s\.com\)',
    r'\s?\((\s*)?\)',
    r'\s*-\s*HD',
    r'\sHD\s*',
    r'\s*LYRICS\s*',
    r'\s-',
]

# Regex parse for cleaning up the title
title = clear_title(title, trash)

# downloads audio only
audio_filename = download_audio(video_url, save_path)

# creates a name for a new mp3 file
output_filename = title + ".mp3"

# getting full file paths for convert_to_mp3
audio_filepath = os.path.join(save_path, audio_filename)
output_filepath = os.path.join(save_path, output_filename)

#
