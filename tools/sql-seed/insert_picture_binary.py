#!/usr/bin/env python3
"""Insert image binary data into nopCommerce PictureBinary table."""

import pyodbc
import os
import glob

conn = pyodbc.connect(
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=localhost,1433;"
    "DATABASE=nopcommerce;"
    "UID=sa;"
    "PWD=DevPassword123!;"
    "TrustServerCertificate=yes;"
    "Encrypt=no;"
)
cursor = conn.cursor()

images_dir = "../output-images"
files = sorted(glob.glob(os.path.join(images_dir, "0000*_0.jpg")))
print(f"Found {len(files)} images to insert")

for path in files:
    try:
        filename = os.path.basename(path)
        picture_id = int(filename.split("_")[0])
        with open(path, "rb") as f:
            data = f.read()
        cursor.execute(
            "IF NOT EXISTS (SELECT 1 FROM PictureBinary WHERE PictureId=?) INSERT INTO PictureBinary (PictureId, BinaryData) VALUES (?, ?)",
            (picture_id, picture_id, data),
        )
        print(f"  Inserted PictureBinary for Picture {picture_id} ({len(data)} bytes)")
    except Exception as e:
        print(f"  FAILED for {path}: {e}")

conn.commit()
conn.close()
print("Done!")
