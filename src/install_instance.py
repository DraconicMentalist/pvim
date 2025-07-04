#!/usr/bin/python
import os
from pathlib import Path
import instance as inst

pvim_path = f'{inst.file_dir}/pvim_startup.py'

def install():
    os.system(f'chmod +x {pvim_path}')
    os.system(f'ln -sf {pvim_path} ~/bin/{inst.NAME}')

def main():
    install()

if __name__ == "__main__":
    main()
