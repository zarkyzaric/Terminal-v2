import pytesseract
from PIL import ImageGrab, Image
import pyperclip
import tempfile
import os

# Configure the path to the Tesseract executable
#! Replace r'C:\Path\To\tesseract.exe' with your actually path in the same format (r'Path Here')
pytesseract.pytesseract.tesseract_cmd =  r'C:\Path\To\tesseract.exe'

def image_to_text_clipboard():
    try:
        # Grab the image from the clipboard
        img = ImageGrab.grabclipboard()
        if isinstance(img, Image.Image):
            # Save the image to a temporary file
            with tempfile.NamedTemporaryFile(delete=False, suffix='.png') as tmp:
                img.save(tmp.name)
                # Ensure the file is closed before reading it again
                tmp.close()
            
            # Read the image back from the temporary file
            with Image.open(tmp.name) as img:
                # Use Tesseract to extract text from the image
                text = pytesseract.image_to_string(img)
                # Copy the extracted text back to the clipboard
                pyperclip.copy(text)
                print("Text copied to clipboard.")
            
            # Delete the temporary file after ensuring it's no longer in use
            os.unlink(tmp.name)
        else:
            print("No image found on the clipboard.")
    except Exception as e:
        print(f"An error occurred: {e}")

# Run the function
image_to_text_clipboard()
