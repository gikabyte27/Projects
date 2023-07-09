#!/usr/bin/env python

import socket
import time
import sys
import struct
import RC4
from Crypto.Hash import SHA256

if len(sys.argv) != 2:
    print "Usage: <{}> <port>".format(sys.argv[0])
    exit()

HOST = '127.0.0.1'  # The server's hostname or IP address
PORT = int(sys.argv[1], 10)        # Port to listen on (non-privileged ports are > 1023

IV = 0
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))
key = 'not-so-random-key'
hexkey = key.encode('hex')

def hash(message):
    h = SHA256.new()
    h.update(message)
    return h.hexdigest().decode('hex')


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
    s.sendall(message)
    time.sleep(1)


def receive_message(size=1024):
    print "Receiving message..."
    data = s.recv(size)
    print 'Received: ', repr(data)
    return data


def main():
    message = b'Hello world'

    while True:
        message = raw_input("> ")
        full_message = encrypt_message(message)
        send_message(full_message)
        data = receive_message()
        message = decrypt_message(data)
        if message == "close" or message == "exit":
            print "Closing connection. Bye!"
            full_message = encrypt_message("close")
            send_message(full_message)
            break

    s.close()


if __name__ == "__main__":
    main()
