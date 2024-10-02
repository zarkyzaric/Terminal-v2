from pytube import YouTube
import moviepy.editor as mp
import os,sys
import re
import requests as req
from bs4 import BeautifulSoup as bs
# Folder to save the MP3
user_path = os.path.expanduser('~')

save_path = os.path.join(user_path,'Music','Downloads')
# save_path = os.path.join('.','Music','Rodj')
def get_title(video_url):
    response = req.get(video_url)
    soup = bs(response.text,"html.parser")
    title_elem = soup.find('title')
    if title_elem:
        title = title_elem.text
    else:
        title = "Title not found"
    return title

# def get_cover(video_url):
#     pass

def clear_title(title,trash):
    # print("before:\n" + title)
    for i in range(len(trash)):
        title = re.sub(trash[i],'',title,flags=re.IGNORECASE)
    # print("after:\n" + title)
    return title

def download_audio(url, output_path):
    yt = YouTube(url)
    audio_stream = yt.streams.get_audio_only()
    audio_stream.download(output_path=output_path)
    return audio_stream.default_filename

def convert_to_mp3(input_file, output_file):
    clip = mp.AudioFileClip(input_file)
    clip.write_audiofile(output_file)
    clip.close()




# save path is current user Music directory subfolder "Youtube Downloads" (created if doesn't exist)
# passes url argument: ex: https://www.youtube.com/watch?v=dQw4w9WgXcQ
video_url = 'https://www.youtube.com/watch?v=giWyK6CW5qI' #*

# Getting title
title = get_title(video_url)
# Trash strings in taht can appear in title
trash = [

    # Example pattern to remove '- Youtube'
    r'\s*\-\s*Youtube',        
    r'\s?\((OFFICIAL\s)?(MUSIC\s)?(VIDEO|AUDIO)\s?\d*\)', #
    r'\s?\((320|128)\s?(kbps)?\)',                  #
    r'\s?\(Snap2s\.com\)',                          #  
    r'\s?\((\s*)?\)',   
    r'\s*-\s*HD',
    r'\sHD\s*',
    r'\s*LYRICS\s*',
    # ()
    # r'\s?Prod\.\sby[^.]+',                          # Handles Prod. by *
    # r'#\S+',
    r'\s-',
    ]

# Regex parse for cleaning up the title
title = clear_title(title,trash)

# downloads audio only
audio_filename = download_audio(video_url, save_path) # = re.sub(r'\.mp4$','',download_audio(video_url, save_path))

# creates a name for a new mp3 file
output_filename = title + ".mp3" #*

# getting full file paths for convert_to_mp3
audio_filepath = os.path.join(save_path, audio_filename)
output_filepath = os.path.join(save_path, output_filename)

# converts audio to mp3 and places it into a save path
convert_to_mp3(audio_filepath,output_filepath)

# deletes audio only file
os.remove(audio_filepath)

#__________________________________________________________________________
#__________________________________________________________________________
