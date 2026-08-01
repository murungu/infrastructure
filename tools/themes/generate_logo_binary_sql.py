#!/usr/bin/env python3
import os

out = ["SET NOCOUNT ON;"]

for picture_id, filename in [(137, "electra_logo.jpg"), (138, "victoria_logo.jpg")]:
    try:
        path = os.path.join("assets", filename)
        with open(path, "rb") as f:
            data = f.read()
        hex_data = data.hex()
        out.append(
            f"IF NOT EXISTS (SELECT 1 FROM PictureBinary WHERE PictureId={picture_id})"
        )
        out.append(
            f"INSERT INTO PictureBinary (PictureId, BinaryData) VALUES ({picture_id}, 0x{hex_data});"
        )
        out.append(f"PRINT 'Inserted logo binary {picture_id} ({len(data)} bytes)';")
    except Exception as e:
        print(f"  FAILED for {filename}: {e}")

try:
    with open("insert-logo-binary.sql", "w") as f:
        f.write("\n".join(out))
    print(f"Generated insert-logo-binary.sql ({len(out)} statements)")
except Exception as e:
    print(f"  FAILED to write SQL: {e}")
