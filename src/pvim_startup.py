#!/usr/bin/python
import os
import sys
from pathlib import Path
import instance as inst
from enum import Enum

def parse():
    argv = sys.argv
    argv.pop(0)
    args = {
            "neovide": False,
            "portable": False,
            "help": False,
            "neovide_args": [],
            "nvim_args": [],
            "filepath": "",
            "unrecognized" : []
            }

    while len(argv) > 0:
        arg = argv.pop(0)
        args = eval_arg(arg, args)

    if len(args["neovide_args"]) > 0:
        args["neovide_args"].pop(0)
    if len(args["nvim_args"]) > 0:
        args["nvim_args"].pop(0)

    print(f"found arguments: {args}")
    return args

# modes
# 0: normal eval
# 1: neovide args
# 2: nvim args
parse_mode: int = 0
def eval_arg(arg:str, result:dict):
    global parse_mode
    match arg:
        case "-a" | "--neovide_args":
            if parse_mode != 2: parse_mode = 1
        case "--":
            parse_mode = 2
    match parse_mode:
        case 1:
            result["neovide_args"].append(arg)
        case 2:
            result["nvim_args"].append(arg)
    match arg:
        case "-n" | "--neovide": 
            result["neovide"] = True
        case "-p" | "--portable":
            result["portable"] = True
        case "--help":
            result["help"] = True
        case _:
            result["unrecognized"].append(arg)
    return result


def verify_installs():
    global neovide_installed
    global nvim_installed
    global portable
    err_str = ""
    nvim_installed = os.system('nvim --help >> /dev/null') == 0
    neovide_installed = False
    counter = 0
    while neovide_installed == False:
        neovide_installed = os.system('neovide --version >> /dev/null') == 0
        counter += 1
        if counter > 10: break

    #if nvim_installed == False and neovide_installed == False:
        #err_str = "Neovim and neovide are both not installed, or aren't available by their normal commands. Neovim at least is needed to run this. Terminating program."
    #elif nvim_installed == False:
        #err_str = "Neovim isnt' installed, or isn't available by running the nvim command. That's required to run this, so fix that before running this again. Terminating program."
    #elif nvim_installed == True and neovide_installed == False and neovide_mode:
        #err_str = "Neovide is not available, so this program will not be able to launch in neovide mode."



#def does_appimage_exist(filename):
    #exists = os.path.isfile(f'{inst.file_dir}/{filename}')
    #if exists: os.system(f'chmod +x {inst.file_dir}/{appfile_name}')
    #return exists

#def satisfy_portable():
    #if os.system('wget --help >> /dev/null 2>&1') != 0:
        #raise Exception("wget command doesn't work! This is likely because it isn't installed, so please go install that.")
#
#
    #if nvim_installed is False:
        #if does_appimage_exist("nvim-linux-x86_64.appimage") is False:
            #print('portable mode: neovim not installed on system. Attempting to download neovim!')
            #install_dependency(f'https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.appimage')
            #os.system(f'chmod +x {inst.file_dir}/nvim-linux-x86_64.appimage')
#
    #if neovide_installed is False and neovide_mode:
        #if does_appimage_exist("neovide.Appimage") is False:
            #print('portable mode: neovide not installed on system. Attempting to download neovide!')
            #install_dependency(f'https://github.com/neovide/neovide/releases/download/0.15.0/neovide.Appimage')
            #os.system(f'chmod +x {inst.file_dir}/neovide.Appimage')


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

def run(args: dict):
    neovide_args = " ".join(args["neovide_args"])
    nvim_args = " ".join(args["nvim_args"])
    pvim_args = f"--clean -i {inst.shada_path} -u {inst.file_dir}/pvim.lua"
    cmd = ""
    unrecognized = " ".join(args["unrecognized"])
    if args["neovide"]:
        cmd = f"neovide {neovide_args} -- {pvim_args} {nvim_args} {unrecognized}"
    else:
        cmd = f"nvim {pvim_args} {nvim_args} {unrecognized}"
    print(f"starting with command: {cmd}")
    os.system(cmd)

def main():
    args = parse()
    #post_parse()
    #verify_installs()
    #if portable: satisfy_portable()
    run(args)

if __name__ == "__main__":
    main()
