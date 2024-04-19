import tkinter as tk
import subprocess

def write_to_file(input_text):
    with open('input.txt', 'w') as file:
        file.write(input_text)
    # Ensure you pass the script path correctly in quotes within the list
    subprocess.run(['c:/Program Files/AutoHotkey/v2/AutoHotkey64.exe', 'Terminal.ahk'], start_new_session=True)
    root.destroy()

root = tk.Tk()
root.overrideredirect(True)  # This removes the window decorations and title bar

window_width = 300
window_height = 50
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()
x = (screen_width // 2) - (window_width // 2)
y = (screen_height // 4) - (window_height // 2)
root.geometry(f"{window_width}x{window_height}+{x}+{y}")
# entry = tk.Entry(root, bd=0, font=('Consolas', 17), justify='center')
entry = tk.Entry(root, bd=0, font=('Helvetica', 16, 'bold'), justify='center')

entry.pack(fill=tk.BOTH, expand=True)
entry.focus_set()  # Set focus to the entry widget so user can start typing immediately
entry.bind('<Return>', lambda event: write_to_file(entry.get()))  # Bind the Enter key to write_to_file function

root.mainloop()
root.destroy()
import sys
sys.exit()

