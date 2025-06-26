#!/usr/bin/python
import os
import argparse
from pathlib import Path
import instance as inst

nvim_installed = False
neovide_installed = False
portable = False
neovide_mode = False

appfile_name = ""

parser = argparse.ArgumentParser()
extra_args = ''



def setup_parser():
    parser.add_argument('file', nargs='?', type=str, action='store', help="path of the file to open.") 
    parser.add_argument('args', nargs='?', type=str, action='store', help='pass along the arguments to neovim or neovide.')
    parser.add_argument('-n', '--neovide', action='store_true', help="open a neovide window instead of running neovim.")
    parser.add_argument('-p', '--portable', action='store_true', help=f"run in portable mode. looks for appimages in {inst.file_dir}, and downloads them if they're not there.")

def process_arguments():
    args = parser.parse_args()
    global neovide_mode
    global portable
    portable = args.portable
    neovide_mode = args.neovide
    return args

def verify_installs():
    global neovide_installed
    global nvim_installed
    global portable
    err_str = ""
    nvim_installed = os.system('nvim --help >> /dev/null') == 0
    neovide_installed = os.system('neovide --help >> /dev/null') == 0

    #if nvim_installed == False and neovide_installed == False:
        #err_str = "Neovim and neovide are both not installed, or aren't available by their normal commands. Neovim at least is needed to run this. Terminating program."
    #elif nvim_installed == False:
        #err_str = "Neovim isnt' installed, or isn't available by running the nvim command. That's required to run this, so fix that before running this again. Terminating program."
    #elif nvim_installed == True and neovide_installed == False and neovide_mode:
        #err_str = "Neovide is not available, so this program will not be able to launch in neovide mode."



def does_appimage_exist(filename):
    exists = os.path.isfile(f'{inst.file_dir}/{filename}')
    if exists: os.system(f'chmod +x {inst.file_dir}/{appfile_name}')
    return exists

def satisfy_portable():
    if os.system('wget --help >> /dev/null 2>&1') != 0:
        raise Exception("wget command doesn't work! This is likely because it isn't installed, so please go install that.")


    if nvim_installed is False:
        if does_appimage_exist("nvim-linux-x86_64.appimage") is False:
            print('portable mode: neovim not installed on system. Attempting to download neovim!')
            install_dependency(f'https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.appimage')
            os.system(f'chmod +x {inst.file_dir}/nvim-linux-x86_64.appimage')

    if neovide_installed is False and neovide_mode:
        if does_appimage_exist("neovide.Appimage") is False:
            print('portable mode: neovide not installed on system. Attempting to download neovide!')
            install_dependency(f'https://github.com/neovide/neovide/releases/download/0.15.0/neovide.Appimage')
            os.system(f'chmod +x {inst.file_dir}/neovide.Appimage')


def install_dependency(url: str):
    result = os.system(f'wget {url}')
    if result != 0:
        raise Exception(f"Couldn't get dependency at {url}! Terminating program!")
    else: "Dependency sucessfully installed!"

def run_from_folder(filename: str):
    path = f"{inst.file_dir}/{filename}"
    print(path)
    if os.path.isfile():
        os.system(path)

def run(args):
    program = ""
    neovide_argpass = ""
    file = ''
    nvim_args = ''
    if args.file: file = args.file
    if args.args: nvim_args = args.args
    program = f'{inst.file_dir}/{appfile_name}'
    if neovide_mode: 
        if neovide_installed: program = "neovide"
        else:
            if nvim_installed is False:
                program = f'{program} --neovim-bin {inst.file_dir}/nvim-linux-x86_64.appimage'
    elif nvim_installed: program = "nvim"
    if neovide_mode: neovide_argpass = " --"

    command = f"{program} {file}{neovide_argpass} --clean -i {inst.shada_path} -u {inst.file_dir}/pvim.lua {nvim_args}"
    print(f'starting with command: {command}')
    if neovide_mode: os.system(f"{command} & disown")
    else: os.system(command)

def main():
    setup_parser()
    args = process_arguments()

    global portable
    global neovide_mode
    global appfile_name
    if neovide_mode is False: appfile_name = "nvim-linux-x86_64.appimage"
    else: appfile_name = "neovide.Appimage"

    verify_installs()
    if portable: satisfy_portable()
    run(args)

if __name__ == "__main__":
    main()
