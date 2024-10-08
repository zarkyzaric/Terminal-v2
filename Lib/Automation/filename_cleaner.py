import os,re

def clean_filenames(start_directory,trash_patterns):

    # Iterate over all files in the directory
    for current_dir,dirnames,filenames in os.walk(start_directory):
        for filename in filenames:
            original_filename = filename
            cleaned_filename = filename

            # Apply all trash patterns to the filename
            for pattern in trash_patterns:
                cleaned_filename = re.sub(pattern, '', cleaned_filename, flags=re.IGNORECASE)
                # Removes any double or more spaces in a row with a single one
                cleaned_filename = re.sub(r'\s+',' ',cleaned_filename,flags=re.IGNORECASE)

            # If the filename has changed, rename the file
            if cleaned_filename != original_filename:
                original_filepath = os.path.join(start_directory, original_filename)
                cleaned_filepath = os.path.join(start_directory, cleaned_filename)
                os.rename(original_filepath, cleaned_filepath)
                # print(f'Renamed "{original_filename}" to "{cleaned_filename}"')

# List of regex patterns to remove from filenames
trash = [

    # Example pattern to remove '- Youtube'
    r'\s*\-\s*Youtube',        
    r'\s?\((OFFICIAL\s)?(MUSIC\s)?(VIDEO|AUDIO)\s?\d*\)', #
    r'\s?\((320|128)\s?(kbps)?\)',                  #
    r'\s?\(Snap2s\.com\)',                          #  
    r'\s?\((\s*)?\)',                               # ()
    r'^\[SPOTIFY-DOWNLOADER\.COM\]\s',
    r'^\s+',
    r'\s+$',
    # r'\s?Prod\.\sby[^.]+',                          # Handles Prod. by
    # r'#.+',
    ]

# Get the directory of the current script
current_directory = os.path.dirname(os.path.realpath(__file__))

# Clean all filenames in the script's directory
clean_filenames(start_directory=current_directory,trash_patterns=trash)
