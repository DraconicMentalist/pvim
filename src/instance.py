import os
from pathlib import Path

# change this to change the name of your instance. each unique name gets its own folder to store its files in.
# this will also be used as the name of the command, if you install this.
NAME = "pvim"

def resolve_file_dir():
    initial_path = os.path.abspath(__file__)
    real_path = os.path.realpath(initial_path)
    file_dir = Path(os.path.dirname(real_path))
    return file_dir
def resolve_app_dir(file_dir: Path):
    parts = file_dir.parts
    parts_list = list(parts)
    parts_list.pop()
    parts_list.pop(0)
    path = "/" + "/".join(parts_list)
    return path
file_dir = resolve_file_dir()
app_dir = resolve_app_dir(file_dir)


shada_path = f"{file_dir}/clutter/{NAME}/shada/state"
pvim_lua = f"{file_dir}/pvim.lua"
nvim_args = f'--clean -i {shada_path} -u {pvim_lua}'


os.environ['PVIM'] = str(app_dir)
os.environ['PVIM_INSTANCE'] = NAME
