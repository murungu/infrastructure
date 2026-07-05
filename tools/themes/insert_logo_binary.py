#!/usr/bin/env python3
import pyodbc
import os

conn_str = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=localhost,1433;"
    "DATABASE=nopcommerce;"
    "UID=sa;PWD=DevPassword123!;"
    "TrustServerCertificate=yes;Encrypt=no;"
)


def insert_binary(picture_id, filepath):
    try:
        with open(filepath, "rb") as f:
            data = f.read()
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        cursor.execute(
            "IF NOT EXISTS (SELECT 1 FROM PictureBinary WHERE PictureId=?) INSERT INTO PictureBinary (PictureId, BinaryData) VALUES (?, ?)",
            (picture_id, picture_id, data),
        )
        conn.commit()
        conn.close()
        print(
            f"  Inserted PictureBinary for {picture_id} ({len(data)} bytes from {filepath})"
        )
        return True
    except Exception as e:
        print(f"  FAILED for {picture_id}: {e}")
        return False


assets_dir = "assets"
insert_binary(137, os.path.join(assets_dir, "electra_logo.jpg"))
insert_binary(138, os.path.join(assets_dir, "victoria_logo.jpg"))
print("Done!")
