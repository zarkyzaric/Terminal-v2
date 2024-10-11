import time
import os
import random
import pygame

os.chdir(os.path.dirname(os.path.abspath(__file__)))
LOCAL_PATH_TO_BACKGROUND_mp3 = r''
END_mp3 = 'bell.wav'
BACKGROUND_mp3 = 'brown_noise.mp3'
for file in os.listdir(os.getcwd()):
    if file.endswith(".mp3") and (file != "brown_noise.mp3" or file != "brown_noise_light.mp3"):
        BACKGROUND_mp3 = file

if not os.path.exists(BACKGROUND_mp3):
    if LOCAL_PATH_TO_BACKGROUND_mp3 != '' and os.path.exists(LOCAL_PATH_TO_BACKGROUND_mp3):
        BACKGROUND_mp3 = LOCAL_PATH_TO_BACKGROUND_mp3
    else:
        BACKGROUND_mp3 = 'brown_noise.mp3'
def countdown_timer(total_time,END_mp3=END_mp3,BACKGROUND_mp3=BACKGROUND_mp3):
    pygame.mixer.init()
    # Load beep sound
    end_sound = pygame.mixer.Sound(END_mp3)
    pygame.mixer.music.load(BACKGROUND_mp3)
    pygame.mixer.music.play(loops=-1)  # Play in an infinite loop
    
    # Pause for 2 seconds to pass the BG noise gap of pause
    # time.sleep(2)
    # pygame.mixer.music.load(BACKGROUND_mp3)
    # pygame.mixer.music.play(loops=-1)  # Play in an infinite loop
    
    half_time = total_time / 2
    pause_duration = random.uniform(0,half_time)
    # print(f'pause duration = {oause_duration}')
    freeze_time = random.uniform(0,total_time)

    start_time = time.time()
    remaining_time = total_time
    print(total_time)
    WAS_PAUSED = False
    
    while remaining_time > 0:
        current_time = time.time()

        elapsed_time = current_time - start_time
        remaining_time = total_time - elapsed_time
        # print(elapsed_time, end='')
        # print(remaining_time, end='\n')
        if remaining_time <= 0:
            break
        
        print(f"Time remaining: {int(remaining_time)} seconds", end='\r')
        time.sleep(1)

        if elapsed_time >= freeze_time and WAS_PAUSED == False:
            # print(f"\nClock frozen for {pause_duration:.2f} seconds.")
            time.sleep(pause_duration)
            WAS_PAUSED = True

    print("\nTime's up!")
    # end_sound.play()
    
    time.sleep(2.5)  # Ensure beep sound plays before the script ends
#---------------------------------------------------------------------------------
import sys
import re

if len(sys.argv) == 2: # for one string arg
    args = [arg for arg in sys.argv[1].split()]
elif 2 < len(sys.argv) <= 4: # for multi string args
    args = [arg for arg in sys.argv[1:]]

SECONDS,MINUTES,HOURS = 0,0,0

for arg in args:
    if 's' in arg:
        SECONDS = int(arg.replace('s', '')) 
    elif 'm' in arg:
        MINUTES = int(arg.replace('m', ''))
    elif 'h' in arg:
        HOURS = int(arg.replace('h', ''))
    else:
        if SECONDS == 0:
            SECONDS = int(arg)
        elif MINUTES == 0:
            MINUTES = int(arg)
        elif HOURS == 0:
            HOURS = int(arg)

T = SECONDS + MINUTES * 60 + HOURS * 3600 # print(T)

# Start
countdown_timer(T)