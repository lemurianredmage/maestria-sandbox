import os
import pandas as pd
import itertools
import random

bivtatt_dataset_path = '../../datasets/BIVTatt-Dataset/'

def bivtatt_dataset():
    images = os.listdir(f'{bivtatt_dataset_path}images')

    # Group images by base image (e.g., 1_1, 2_1)
    bases = {}
    for img in images:
        base_id = '_'.join(img.split('_')[:2])  # Extract base ID (e.g., 1_1)
        if base_id not in bases:
            bases[base_id] = []
        bases[base_id].append(img)

    # Create pairs
    pairs = []
    for base_id, img_list in bases.items():
        # Positive pairs: base with transformations, and transformations with each other
        for img1, img2 in itertools.combinations(img_list, 2):
            pairs.append((img1, img2, 1))  # Label 1 for match

    # Negative pairs: images from different bases
    all_base_ids = list(bases.keys())
    for base1, base2 in itertools.combinations(all_base_ids, 2):
        img1 = random.choice(bases[base1])
        img2 = random.choice(bases[base2])
        pairs.append((img1, img2, 0))  # Label 0 for no match

    # Convert to DataFrame and save as CSV
    df = pd.DataFrame(pairs, columns=['image1', 'image2', 'label'])
    df.to_csv(f'{bivtatt_dataset_path}annotations.csv', index=False)

    print(f"Annotations file saved as 'annotations.csv' with {len(df)} pairs.")