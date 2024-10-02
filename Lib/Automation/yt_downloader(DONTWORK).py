import tkinter as tk
from tkinter import messagebox, filedialog
import os
import re
import sys
import requests as req
from bs4 import BeautifulSoup as bs
from pytube import YouTube
import moviepy.editor as mp

# Folder to save the MP3
save_path = os.path.expanduser("~" + os.sep + "Music" + os.sep + "Goggins")
if not os.path.exists(save_path):
    os.makedirs(save_path)

def get_title(video_url):
    response = req.get(video_url)
    soup = bs(response.text, "html.parser")
    title_elem = soup.find('title')
    if title_elem:
        return title_elem.text.replace(" - YouTube", "")
    return "Title not found"

def clear_title(title, trash):
    for pattern in trash:
        title = re.sub(pattern, '', title, flags=re.IGNORECASE)
    return title.strip()

def download_audio(url, output_path):
    yt = YouTube(url)
    audio_stream = yt.streams.get_audio_only()
    default_filename = audio_stream.default_filename
    audio_stream.download(output_path=output_path, filename=default_filename)
    return default_filename

def convert_to_mp3(input_file, output_file):
    clip = mp.AudioFileClip(input_file)
    clip.write_audiofile(output_file)
    clip.close()
    os.remove(input_file)  # Delete the original audio file after conversion

def handle_download():
    url = url_entry.get().strip()
    if not url:
        messagebox.showerror("Error", "Please enter a valid YouTube URL")
        return

    try:
        title = get_title(url)
        trash_patterns = [
            r'\s*\-\s*YouTube', r'\s*\((OFFICIAL\s)?(MUSIC\s)?(VIDEO|AUDIO)\s?\d*\)', r'\s*\(\d{2,3}kbps\)',
            r'\s*\[\w+\]', r'\s*HD', r'\s*LYRICS', r'\s*-', r'\s*Official Music Video'
        ]
        clean_title = clear_title(title, trash_patterns)
        audio_filename = download_audio(url, save_path)
        output_filename = clean_title + ".mp3"
        audio_filepath = os.path.join(save_path, audio_filename)
        output_filepath = os.path.join(save_path, output_filename)
        convert_to_mp3(audio_filepath, output_filepath)
        messagebox.showinfo("Success", f"Downloaded and converted successfully to {output_filepath}")
    except Exception as e:
        messagebox.showerror("Error", f"Failed to download: {str(e)}")

root = tk.Tk()
root.title("YouTube Audio Downloader")

# Entry for YouTube URL
url_entry = tk.Entry(root, width=60)
url_entry.pack(padx=20, pady=20)

# Button to trigger download
download_button = tk.Button(root, text="Download MP3", command=handle_download)
download_button.pack(pady=10)


root.mainloop()


# Create the main window
root = tk.Tk()
root.title("YouTube Audio Downloader")

# Positioning the window
window_width = 500
window_height = 150
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()
center_x = int(screen_width / 2 - window_width / 2)
center_y = int(screen_height / 2 - window_height / 2)
root.geometry(f'{window_width}x{window_height}+{center_x}+{center_y}')

# Frame for widgets
frame = tk.Frame(root)
frame.pack(pady=20)

# URL entry widget
url_label = tk.Label(frame, text="YouTube URL:")
url_label.grid(row=0, column=0, sticky='e')
url_entry = tk.Entry(frame, width=40)
url_entry.grid(row=0, column=1, padx=10)
url_entry.focus_set()

# Save path entry widget
path_label = tk.Label(frame, text="Save Path:")
path_label.grid(row=1, column=0, sticky='e')
path_entry = tk.Entry(frame, width=30)
path_entry.grid(row=1, column=1, padx=10)
path_entry.insert(0, default_save_path)  # Set default save path

# Browse button to change path
browse_button = tk.Button(frame, text="Browse...", command=browse_path)
browse_button.grid(row=1, column=2)

# Download button
download_button = tk.Button(frame, text="Download", command=download_video)
download_button.grid(row=2, column=1, pady=10)

# Bind the Enter key to the download_video function
root.bind('<Return>', lambda event: download_video())

root.mainloop()
