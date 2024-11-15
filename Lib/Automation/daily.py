import os
import subprocess as sp
user_path = os.path.expanduser('~')

def join(path, *paths): return os.path.join(path, *paths)
def run(path): return os.startfile(path)
def isFile(path): return os.path.isfile(path)
def exists(path): return os.path.exists(path)
def isDir(path): return os.path.isdir(path)
def listDir(path): return os.listdir(path)

# folder_path = join(user_path, 'Main', 'daily')
folder_path = join(user_path, 'Desktop', 'Daily')
if exists(folder_path) and isDir(folder_path):
    for item in listDir(folder_path):
        item_path = join(folder_path, item)
        if isFile(item_path):
            os.startfile(item_path)

