import os
import tarfile
import urllib.request
import pandas as pd

def download(data_path: str, tgz_path: str, data_url: str):
    os.makedirs(data_path, exist_ok=True)
    urllib.request.urlretrieve(data_url, tgz_path)
    downloaded_tgz = tarfile.open(tgz_path)
    downloaded_tgz.extractall(path=data_path)
    downloaded_tgz.close()

def download(url: str, download_path: str, files: list):
    os.makedirs(download_path, exist_ok=True)
    for filename in (files):
        filepath = os.path.join(download_path, filename)
        if not os.path.isfile(filepath):
            print("Downloading", filename)
            urllib.request.urlretrieve(url + filename, filepath)
            print(f"{filename} download was completed.")
        else:
            print(f"{filename} is already downloaded.")

def load_csv(data_path, filename):
    csv_path = os.path.join(data_path, filename)
    return pd.read_csv(csv_path)