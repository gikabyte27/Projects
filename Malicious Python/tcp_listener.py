#!/usr/bin/python3

import socket

TCP_IP = "192.168.56.103"
TCP_PORT = 5555
BUFFER_SIZE = 100

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.bind((TCP_IP, TCP_PORT))
s.listen(1)

conn, addr = s.accept()

print('Connection address:', addr)
print('Connection conn:', conn)

while 1:

    data = conn.recv(BUFFER_SIZE)
    if not data:
        break
    print("Received data:", data)
    conn.send(data)

conn.close()
