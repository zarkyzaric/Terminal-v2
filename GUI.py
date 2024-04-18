import tkinter as tk
import subprocess

def write_to_file(input_text):
    with open('input.txt', 'w') as file:
        file.write(input_text)
    subprocess.run(['c:/Program Files/AutoHotkey/v2/AutoHotkey64.exe', 'Terminal.ahk'])

root = tk.Tk()
entry = tk.Entry(root)
entry.pack()

button = tk.Button(root, text="Send to AHK", command=lambda: write_to_file(entry.get()))
button.pack()

root.mainloop()

