
def calculate_execution_time(start_time, end_time):
    execution_time = end_time - start_time
    # Calculate minutes and seconds
    minutes = execution_time // 60  # Integer division for whole minutes
    seconds = execution_time % 60   # Remainder for leftover seconds
    print(f"Total execution time: {execution_time:.2f} seconds")
    print(f"Total execution time: {minutes} minutes and {seconds:.2f} seconds")