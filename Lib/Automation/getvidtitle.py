import requests as req
from bs4 import BeautifulSoup as bs
import re

video_url = "https://www.youtube.com/watch?v=xPKLILuqx_E"

response = req.get(video_url)

soup = bs(response.text,"html.parser")

title_elem = soup.find('title')

if title_elem:
    full_title = title_elem.text
else:
    full_title = "Title not found"
cleaned_title = re.sub(r'\s*-\sYoutube','',full_title,flags=re.IGNORECASE)
print(cleaned_title)
