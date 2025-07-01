#!/usr/bin/python
import os
import sys
import instance as inst

server_path = "/tmp/godot.pipe"
terminal_name = "ghostty -e"

def start():
    args = sys.argv
    pvim_args = args[1:]
    neovide = check_neovide(pvim_args)
    nvide_mod = 0
    passthrough_args = []
    if neovide: nvide_mod = 1
    print(len(pvim_args))
    if len(pvim_args) >= 3+nvide_mod:
        passthrough_args = pvim_args[3+nvide_mod:]
        print(pvim_args[3+nvide_mod:])
    run_server(pvim_args[0], pvim_args[1], pvim_args[2], neovide, passthrough_args)

def check_neovide(pvim_args):
    if len(pvim_args) < 4: return False
    if pvim_args[3] == "-n" or pvim_args[3] == "--neovide":
        return True
    else: return False


def server_exists():
    print(f"path:{server_path}")
    return os.path.exists(server_path)

def run_server(file: str, line: int, column: int, neovide: bool = False, passthrough: list = []):
    print(file, line, column, neovide, passthrough)
    file = os.path.abspath(file)
    passthrough_str = " ".join(passthrough)
    prog_name = "nvim"
    if neovide: prog_name = "neovide --"
    if os.system(f"{inst.NAME} --help") == 0:
        prog_name = inst.NAME
        if neovide: prog_name += " -n"
    print(server_exists())
    if server_exists() is False:
        cmd = f"""{prog_name} "{file}" --listen "{server_path}" """
        print(cmd)
        os.system(cmd)
    cmd = f"""{prog_name} --server "{server_path}" --remote-send "<C-\\><C-N>:n {file}<CR>:call cursor({line},{column})<CR>" {passthrough_str}"""
    print(cmd)
    os.system(cmd)


def main():
    start()
 
if __name__ == "__main__":
    main()
