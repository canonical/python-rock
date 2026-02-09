#!/usr/bin/python3

import os
from pathlib import Path

UID=584792
GID=584792 

def log_error(f):
    def wrapper(*args,**kwargs):
        out = f(*args, **kwargs)
        if not out:
            print(f"***Error with {f.__name__} - Args: {str(args)} Kwargs: {(str(kwargs))}")
        return out
    return wrapper

@log_error
def check_permissions(path_name: Path):
    stat = os.stat(path_name)
    return stat.st_uid == UID and stat.st_gid == GID

@log_error
def create_file(filename: Path):
    try:
        with open(filename, "w") as fid:
            fid.write("test")
        return True
    except:
        return False
    

@log_error
def check_writable_location(path: Path):
    testfile = path / "test.txt"
    return check_permissions(path) and create_file(testfile) and check_permissions(testfile)

if __name__ == "__main__":

    folders = [Path("/tmp"), Path("/run")]

    if all([check_writable_location(folder) for folder in folders]):
        print("PASSED")
    else:
        print("FAILED")
