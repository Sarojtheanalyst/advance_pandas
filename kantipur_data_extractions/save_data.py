import pandas as pd
from datetime import datetime
import os

def save_json(data):
    os.makedirs("data", exist_ok=True)
    current_time = datetime.now()
    filename = (str(current_time).replace(" ", "_").split(".")[0]
     .replace(":", "-"))
    filepath = f"data/{filename}.json"
    df = pd.DataFrame(data)
    df.to_json(filepath,orient="records",indent=4,force_ascii=False)
    print(f"Saved : {filepath}")