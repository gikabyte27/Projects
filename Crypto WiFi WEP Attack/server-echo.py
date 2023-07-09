#!/usr/bin/env python

import socket
import time
import struct
import RC4
import sys
from Crypto.Hash import SHA256

if len(sys.argv) != 2:
    print "Usage: <{}> <port>".format(sys.argv[0])
    exit()
HOST = '127.0.0.1'  # Standard loopback interface address (localhost)
PORT = int(sys.argv[1], 10)        # Port to listen on (non-privileged ports are > 1023
IV = 0
key = 'not-so-random-key'
hexkey = key.encode('hex')

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()

def strxor(s1, s2):
    return "".join(chr(ord(c1) ^ ord(c2)) for (c1, c2) in zip(s1, s2))


def hash(message):
    h = SHA256.new()
    h.update(message)
    return h.hexdigest().decode('hex')


def inc(IV):
    return (IV + 1) % (2 ** 24)


def encrypt_message(data):
    plaintext = data
    plaintext = plaintext + hash(plaintext)
    ciphertext = ""
    # keystream = RC4(IV)
    # ciphertext = strxor(plaintext, keystream)
    ciphertext = RC4.encrypt(hexkey, plaintext)
    full_message = struct.pack("I", IV) + ciphertext
    return full_message

def decrypt_message(data):
    full_message = data
    recv_IV = 0
    recv_IV = struct.unpack("I", full_message[:4])
    ciphertext = full_message[4:]
    plaintext = RC4.decrypt(hexkey, ciphertext)
    message = plaintext[:-32]
    crc = plaintext[-32:]
    if crc == hash(message):
        print "CRC matches!"
    # print "PlaintextRAW: {}\nPlaintext:    {}\nPlaintextCRC: {}\nCiphertext: {}\nIV: {}\n".format(message, message.encode('hex'), 
    #                 plaintext.encode('hex'), ciphertext, recv_IV)
    print 'Decrypted: ', message
    return message


def send_message(message=b'Sample message'):
    print "Sending message..."
    conn.sendall(message)
    time.sleep(1)


def receive_message(size=1024):
    print "Receiving message..."
    data = conn.recv(size)
    print 'Received: ', repr(data)
    return data


print('Connected by', addr)
while True:
    data = receive_message()
    data = decrypt_message(data)
    if data == 'close' or data == 'exit':
        print "Closing connection. Bye!"
        full_message = encrypt_message('close')
        send_message(full_message)
        break
    message = raw_input("> ")
    full_message = encrypt_message(message)
    send_message(full_message)
    # IV = inc(IV)
conn.close()
s.close()
