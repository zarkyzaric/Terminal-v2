import os
import sys

def create_and_open_file():
    if len(sys.argv) < 3:
        print("Usage: create_and_open_any_file.py <filename> <directory_path>")
        # filename example: My New File (with or without file extension (.txt is default))
        # dir is last opened folder
        return
    
    file_name = sys.argv[1]
    file_path = sys.argv[2]

    # Append "NewFile" if the filename starts with a dot
    if "." not in file_name:
        file_name = file_name + ".txt"
    elif file_name.startswith('.'):
        file_name = "NewFile" + file_name


    # Combine the file path and file name to create the full path
    full_file_path = os.path.join(file_path, file_name)

    # Create the file
    with open(full_file_path, 'w') as file:
        file.write("")  # Creates an empty text file
    
    # Open the file with the default application
    os.system(f'start "" "{full_file_path}"')
    
    print(f"'{full_file_path}' has been created and opened in its default application.")

if __name__ == "__main__":
    create_and_open_file()
