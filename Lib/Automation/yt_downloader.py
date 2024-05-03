from pytube import YouTube
import tkinter as tk
from tkinter import messagebox
import os

# Folder to save the MP3
# Folder to save the MP3
sep = os.sep
save_path = os.path.expanduser("~" + sep + "Music" + sep + "YT Download" )
def auto_close_messagebox(title, message, duration=3000):  # Duration in milliseconds
    """
    Display a custom message box that closes after a specified duration.
    """
    box = tk.Toplevel(root)
    box.title(title)
    message_label = tk.Label(box, text=message, height=4, width=50)  # Adjust size as needed
    message_label.pack()

    # Center the messagebox on the screen
    box_width = 300
    box_height = 100
    screen_width = box.winfo_screenwidth()
    screen_height = box.winfo_screenheight()
    center_x = int(screen_width / 2 - box_width / 2)
    center_y = int(screen_height / 2 - box_height / 2)
    box.geometry(f'{box_width}x{box_height}+{center_x}+{center_y}')

    # Automatically close the box after 'duration' milliseconds
    box.after(duration, box.destroy)

def download_video():
    url = url_entry.get()  # Get URL from the entry widget
    if not url.strip():
        messagebox.showerror("Error", "Please enter a valid YouTube URL")
        return
    
    try:
        video = YouTube(url)
        audio_stream = video.streams.get_audio_only()
        audio_stream.download(output_path=save_path, filename=video.title + ".mp3")
        auto_close_messagebox("Success", f"Downloaded successfully to {save_path}", 3000)  # Auto-closes after 3 seconds
        root.destroy()  # Close the GUI after successful download
    except Exception as e:
        messagebox.showerror("Error", f"Failed to download: {str(e)}")

# Create the main window
root = tk.Tk()
root.title("YouTube Audio Downloader")

# Automatically use the native theme if available (for newer Tkinter versions)
try:
    from tkinter import ttk
    ttk_style = ttk.Style()
    ttk_style.theme_use(ttk_style.theme_use())
except ImportError:
    pass  # Fallback to default theme if ttk is not available

# Calculate position for the window to be centered on the screen
window_width = 500
window_height = 100
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()
center_x = int(screen_width / 2 - window_width / 2)
center_y = int(screen_height / 2 - window_height / 2)
root.geometry(f'{window_width}x{window_height}+{center_x}+{center_y}')

# Frame for Entry and Button widgets
frame = tk.Frame(root)
frame.pack(pady=20)

# URL entry widget
url_entry = tk.Entry(frame, width=40)
url_entry.grid(row=0, column=0, padx=(0, 10))
url_entry.focus_set()  # Set focus to the URL entry widget

# Download button
download_button = tk.Button(frame, text="Download", command=download_video)
download_button.grid(row=0, column=1)
# Bind the Enter key to the download_video function
root.bind('<Return>', lambda event: download_video())

root.mainloop()
