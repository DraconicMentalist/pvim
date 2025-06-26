#!/usr/bin/python
import os
from pathlib import Path

file_dir = Path(os.path.dirname(os.path.abspath(__file__)))
pvim_path = f'{file_dir}/start-pvim.py'
name = 'pvim' #what the program will be named. Good for variant versions.

def install():
    os.system(f'chmod +x {pvim_path}')
    os.system(f'ln -sf {pvim_path} ~/bin/{name}')

def main():
    install()

if __name__ == "__main__":
    main()
