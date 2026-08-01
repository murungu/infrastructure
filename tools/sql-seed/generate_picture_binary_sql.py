#!/usr/bin/env python3
"""Generate SQL to insert image binary data as hex literals."""

import os
import glob

out = []
out.append("SET NOCOUNT ON;")

for path in sorted(glob.glob("../output-images/0000*_0.jpg")):
    filename = os.path.basename(path)
    picture_id = int(filename.split("_")[0])
    with open(path, "rb") as f:
        data = f.read()
    hex_data = data.hex()
    out.append(
        f"IF NOT EXISTS (SELECT 1 FROM PictureBinary WHERE PictureId={picture_id})"
    )
    out.append(
        f"INSERT INTO PictureBinary (PictureId, BinaryData) VALUES ({picture_id}, 0x{hex_data});"
    )
    out.append(f"PRINT 'Inserted {picture_id} ({len(data)} bytes)';")

out_path = "insert-picture-binary.sql"
with open(out_path, "w") as f:
    f.write("\n".join(out))

print(f"Generated {len(out) - 1} INSERT statements -> {os.path.abspath(out_path)}")
print(
    f"Run with: docker exec -i db-infra-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'DevPassword123!' -d nopcommerce -C < {out_path}"
)
