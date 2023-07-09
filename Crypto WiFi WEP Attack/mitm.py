#! /usr/bin/env python

import struct
import socket
import time
import RC4
from Crypto.Hash import SHA256

TIME_WAIT = 1
BIND_ADDR = '127.0.0.1'
BIND_PORT = 6666
SERV_ADDR = '127.0.0.1'
SERV_PORT = 65432
IV = 0
key = 'not-so-random-key'
hexkey = key.encode('hex')
plaintexts = []
ciphertexts = []


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


def send_message(sock,message=b'Sample message'):
    print "Sending message..."
    sock.sendall(message)
    time.sleep(1)


def receive_message(sock,size=1024):
    print "Receiving message..."
    data = sock.recv(size)
    print 'Received: ', repr(data)
    return data


def strxor(s1, s2):
    return "".join(chr(ord(c1) ^ ord(c2)) for (c1, c2) in zip(s1, s2))

def print_options():
    print
    print "Received a new message. What would you like to do before sending it?"
    print "1. Send it normally"
    print "2. Recover plaintext messages"
    print "3. Inject new message"
    print "4. Display ciphertexts"
    print "5. Display plaintexts"
    print "6. Exit"
    print

def recover_plaintext(keystream,opt=1):
    p1p2 = ""
    p1 = plaintexts[0]
    if opt == 1:
        print "Which ciphertext would you like to decipher?"
        for index, message in enumerate(ciphertexts,0):
            print "{}. {}".format(index, message)
        option = int(raw_input("> "), 10)
        print option

    # while option != 0:
    #    option = int(raw_input("> "), 10)
    
    
    if opt == 1:
        c2hex = ciphertexts[option]
    else:
        c2hex = ciphertexts[-1]
    print "Decrypting {} ...".format(c2hex)
    c2 = c2hex.decode('hex')
    if keystream != '????':
        print "Recovered message using keystream: \n{}".format(strxor(keystream, c2))
        plaintexts.append(strxor(keystream, c2))
        p2 = strxor(keystream, c2)
        return p2
       
def inject_message(message, keystream):
        return strxor(message + hash(message), keystream).encode('hex')

def Route():

    known_pt = "So I went into the office and my boss was thinking about what could the best decision be"
    known_ct = '397FA154FFCE8AABC2B6F492BCE22A9A288E45446C8DFFB581BC5241B563C26440D7F498B5F14EEB7E9C6BBF791C9684E181E090B872E9F6A595910A84032BCD08E0585364A3353E0FFF9085A15E407EE6938BB36DD47C3FC473B15B39C2B46D900DD8361765C0777089B002C0590C6F27722B23E2FCAA2F'
    keystream = strxor(known_pt, known_ct.decode('hex'))
    plaintexts.append(known_pt)
    ciphertexts.append(known_ct)
    listener = socket.socket()
    listener.bind((BIND_ADDR, BIND_PORT))
    listener.listen(1)
    print "Started listening on {}".format(BIND_PORT)

    client, caddr = listener.accept()
    print('Connected by', caddr)

    listener.close()
    server = socket.socket()
    server.connect((SERV_ADDR, SERV_PORT))
    # Routing the message to the server
    running = True
    turn = 0
    receiver = client
    sender = server
    while running:
        message = receive_message(receiver)
        print_options()
        option = int(raw_input("> "))
        ciphertexts.append(message[4:])
        if option == 1:
            pass
        elif option == 2:
            print "Chose option 2"
            if len(ciphertexts) >= 2:
                print "Recovering..."
                current_plain = recover_plaintext(keystream)
            else:
                print "Whoops! Come back when you have at least 2 ciphertexts AND either the keystream or" \
                        "the corresponding plaintext of one of the 2 ciphertexts"
        elif option == 3:
            print "Original message: {}".format(recover_plaintext(keystream,opt=3))
            print "What is the message you would like to change it to?"
            fake = raw_input("> ")
            message = message[:4] + inject_message(fake, keystream)
        elif option == 4:
            for cipher in ciphertexts:
                print cipher
        elif option == 5:
            for plain in ciphertexts:
                print strxor(keystream, plain.decode('hex'))
        elif option == 6:
            print "Bye!"
            break
        else:
            print "Not a valid number!"
        send_message(sender, message)
        sender, receiver = receiver, sender

    try:
        client.close()
    except:
        pass

    try:
        server.close()
    except:
        pass

if __name__ == '__main__':
    Route()
