#!/usr/bin/python
import os
import sys
import fileinput 
from pathlib import Path

def resolve_file_dir():
    initial_path = os.path.abspath(__file__)
    real_path = os.path.realpath(initial_path)
    file_dir = Path(os.path.dirname(real_path))
    return file_dir
file_dir = resolve_file_dir()

def main():
    args = sys.argv
    args.pop(0)
    args_str = " ".join(args)
    print(args_str)

    os.system(f"python {file_dir}/src/pvim_startup.py {args_str}")

if __name__ == "__main__":
    main()
