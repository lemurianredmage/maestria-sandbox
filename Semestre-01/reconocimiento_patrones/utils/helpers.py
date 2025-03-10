import os
import shutil

def calculate_execution_time(start_time, end_time):
    execution_time = end_time - start_time
    # Calculate minutes and seconds
    minutes = execution_time // 60  # Integer division for whole minutes
    seconds = execution_time % 60   # Remainder for leftover seconds
    print(f"Total execution time: {minutes} minutes and {seconds:.2f} seconds")


def setup_workdir(working_path):
    if not os.path.exists(working_path):
        os.makedirs(working_path)
    else:
        shutil.rmtree(working_path)
        os.makedirs(working_path)