#!/usr/bin/python
import argparse
import os
from sh import ghostty
from sh import run
import instance as inst

server_path = "/tmp/godot.pipe"
terminal_name = "ghostty -e"

def setup_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('file', help="filepath to pipe in.")
    parser.add_argument('line', help="line number.")
    parser.add_argument('column', help="cursor column.")
    parser.add_argument('-n', '--neovide', action='store_true',  help="start in neovide mode.")
    return parser

def server_exists():
    return os.path.isfile(server_path)

def main():
    args = setup_parser().parse_args()
    neovide = ""
    if args.neovide: neovide = "-n"
    program = f"{inst.NAME}"
    if server_exists() == False: 
        cmd = f"{program} {neovide} {args.file} -a"
        cmd += f" '--listen {server_path}'"
        if not args.neovide: cmd = f'{terminal_name} "{cmd}"'
        cmd += ">/dev/null 2>&1 & disown"
        print(f"server doesn't exist. Making it: {cmd}")
        os.system(cmd)
    comms = f"{program} {neovide} -a"
    server = f"--server {server_path}" 
    send = f'--remote-send "<C-\\><C-N>:n {args.file}<CR>:call cursor({args.line},{args.column})<CR>\"'
    command = f"{comms} '{server} {send}'"
    os.system(command)

if __name__ == "__main__":
    main()
