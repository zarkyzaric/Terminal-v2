import os,sys
import re
#TODO add removing all of the spaces that are on the end of the file name
def show(label,var):
    print( 40 * '-' + ' ' + label + ':')
    print(var)

def clean(input_string,strings_to_remove):
    pattern = '|'.join(re.escape(s) for s in strings_to_remove)
    regex = re.compile(pattern, re.IGNORECASE)
    result = regex.sub('',input_string)
    return result

ex = "RICK - NEVER GONNA GIVE YOU UP (OFFICIAL VIDEO)"
trash = [
    ' (OFFICIAL VIDEO)','(OFFICIAL VIDEO)',
    ' (OFFICIAL MUSIC VIDEO)','(OFFICIAL MUSIC VIDEO)',
    ' (AUDIO)','(AUDIO)',' (OFFICIAL AUDIO)',
    '(320 kbps)','(128 kbps)','(320)','(128)'
    '(Snap2s.com)', '()'
 ]

ex = clean(ex,trash)

if (' - ')  in ex:
    part = ex.split(' - ')
    artist = part[0]
    song_name = part[1]
    show('og name',ex)
    show('artist', artist)
    show('song name',song_name)
else:
    song_name = ex
    show('og name',ex)
    show('song name',song_name)

# Define the suffix to remove
suffix_to_remove = " (320 kbps) (Snap2s.com)"
# Get a list of all files in the current directory
files = os.listdir('.')

# Loop through the files
for file_name in files:
    # Check if the file name contains the suffix
    if suffix_to_remove in file_name:
        # Create the new name by removing the suffix
        new_name = file_name.replace(suffix_to_remove, '')
        # Rename the file
        os.rename(file_name, new_name)
        print(f'Renamed "{file_name}" to "{new_name}"')
