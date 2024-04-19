import tkinter as tk
from ctypes import windll

def write_to_file(input_text):
    with open('input.txt', 'w') as file:
        file.write(input_text)
    subprocess.run(['c:/Program Files/AutoHotkey/v2/AutoHotkey.exe', 'S.ahk'], start_new_session=True)
    root.destroy()

# This function will make the window recognize the alpha channel
def transparent_window(root, width, height, x, y):
    # Hide the window while configuring
    root.withdraw()
    # Set the window to be transparent
    root.attributes("-alpha", 0.0)
    # Make the window appear on top
    root.attributes("-topmost", True)
    # Set the window position
    root.geometry(f"{width}x{height}+{x}+{y}")
    # Remove window decorations
    root.overrideredirect(True)
    # Make the background of the window itself transparent
    root.config(bg='systemTransparent')
    # Show the window again
    root.deiconify()

# DPI awareness to address font blurriness on high-resolution screens
windll.shcore.SetProcessDpiAwareness(1)

root = tk.Tk()

# Window size and position
window_width = 300
window_height = 50
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()
x = (screen_width // 2) - (window_width // 2)
y = (screen_height // 4) - (window_height // 2)

transparent_window(root, window_width, window_height, x, y)

# Create the canvas with rounded corners
canvas = tk.Canvas(root, width=window_width, height=window_height, bg='white', highlightthickness=0)
canvas.pack()

# Radius for rounded corners
radius = 15
# Rounded rectangle
canvas.create_arc((0, 0, radius * 2, radius * 2), start=90, extent=90, fill='white', outline='')
canvas.create_arc((0, window_height - radius * 2, radius * 2, window_height), start=180, extent=90, fill='white', outline='')
canvas.create_arc((window_width - radius * 2, 0, window_width, radius * 2), start=0, extent=90, fill='white', outline='')
canvas.create_arc((window_width - radius * 2, window_height - radius * 2, window_width, window_height), start=270, extent=90, fill='white', outline='')
canvas.create_rectangle((radius, 0, window_width - radius, window_height), fill='white', outline='')
canvas.create_rectangle((0, radius, radius * 2, window_height - radius), fill='white', outline='')
canvas.create_rectangle((window_width - radius * 2, radius, window_width, window_height - radius), fill='white', outline='')

# Entry widget on the canvas
entry = tk.Entry(root, bd=0, font=('Helvetica', 16, 'bold'), justify='center')
canvas.create_window(window_width // 2, window_height // 2, window=entry, width=window_width - 2 * radius, height=30)

entry.focus_set()
entry.bind('<Return>', lambda event: write_to_file(entry.get()))

root.mainloop()
