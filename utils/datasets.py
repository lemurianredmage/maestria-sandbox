import os
import tarfile
import urllib.request
import pandas as pd

def download(url: str, download_path: str, files: list, decompress_type: str = 'none'):
    os.makedirs(download_path, exist_ok=True)
    for filename in (files):
        filepath = os.path.join(download_path, filename)
        if not os.path.isfile(filepath):
            print("Downloading", filename)
            urllib.request.urlretrieve(url + filename, filepath)
            print(f"{filename} download was completed.")
            decompress(decompress_type, download_path, filepath)
        else:
            print(f"{filename} is already downloaded.")

def load_csv(data_path, filename):
    csv_path = os.path.join(data_path, filename)
    return pd.read_csv(csv_path)

def decompress(type: str, download_path: str, filePath: str):
    match type:
        case 'bz2':
            print("Decompressing files ...")
            compressed_file = tarfile.open(filePath)
            compressed_file.extractall(path=download_path)
            compressed_file.close()
        case _:
            return