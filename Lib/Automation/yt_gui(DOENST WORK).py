from pytube import YouTube
import moviepy.editor as mp
import os
import sys
import re
import requests as req
from bs4 import BeautifulSoup as bs
from tkinter import Tk, filedialog

# Function to get the title of the YouTube video
def get_title(video_url):
    response = req.get(video_url)
    soup = bs(response.text, "html.parser")
    title_elem = soup.find('title')
    return title_elem.text if title_elem else "Title not found"

# Function to clean up the title using regex
def clear_title(title, trash):
    for pattern in trash:
        title = re.sub(pattern, '', title, flags=re.IGNORECASE)
    return title

# Function to download audio from the YouTube video
def download_audio(url, output_path):
    yt = YouTube(url)
    audio_stream = yt.streams.get_audio_only()
    audio_stream.download(output_path=output_path)
    return audio_stream.default_filename

# Function to convert downloaded audio to mp3
def convert_to_mp3(input_file, output_file):
    clip = mp.AudioFileClip(input_file)
    clip.write_audiofile(output_file)
    clip.close()

# Main function
if __name__ == "__main__":
    # Tkinter setup for folder selection
    root = Tk()
    root.withdraw()  # Hide the main Tkinter window
    save_path = filedialog.askdirectory(title="Select Folder to Save MP3")

    # If no folder is selected, use default Music directory
    if not save_path:
        save_path = os.path.expanduser("~" + os.sep + "Music" + os.sep + "Youtube Downloads")

    # Get the video URL from command line argument
    video_url = 'https://www.youtube.com/watch?v=giWyK6CW5qI'

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
    ]

    # Clean up the title
    title = clear_title(title, trash)

    # Download audio only
    audio_filename = download_audio(video_url, save_path)

    # Create a name for the new mp3 file
    output_filename = title + ".mp3"

    # Get full file paths for convert_to_mp3
    audio_filepath = os.path.join(save_path, audio_filename)
    output_filepath = os.path.join(save_path, output_filename)

    # Convert audio to mp3 and place it into the save path
    convert_to_mp3(audio_filepath, output_filepath)

    # Delete the audio-only file
    os.remove(audio_filepath)
