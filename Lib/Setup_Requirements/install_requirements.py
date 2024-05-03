import subprocess
import sys

# List of required libraries
required_libraries = ['pytube', 'moviepy', 'requests', 'beautifulsoup4']

# Check if required libraries are installed
missing_libraries = [lib for lib in required_libraries if lib not in sys.modules]

if missing_libraries:
    print("Some required libraries are missing. Installing them now...")
    
    # Install missing libraries using pip
    for lib in missing_libraries:
        subprocess.check_call([sys.executable, "-m", "pip", "install", lib])

    print("All required libraries installed successfully.")

