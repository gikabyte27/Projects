#!/usr/bin/python3

import socket


for i in range(0,1001):

    s = socket.socket()
    s.settimeout(2)
    port = i
    try:
        conn = s.connect(("192.168.56.101", port))
        print(port)
        answer = s.recv(999999)
        print(answer)
        print("======================")
        s.close()
    except (ConnectionRefusedError, TimeoutError) as e:
        continue
