import os
import sys

path = sys.argv[1]
dirs = os.listdir(path)

for name in dirs:
    name = os.path.join(path, name)
    if name[0] != '.':
        clean_name = name.replace('_', ' ')
        clean_name = " ".join(clean_name.split())
        os.rename(name, clean_name)
