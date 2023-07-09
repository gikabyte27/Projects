#!/usr/bin/env python
# -*- coding: utf-8 -*-
# author: @manojpandey

# Python 2 implementation for RC4 algorithm
# Brief: https://en.wikipedia.org/wiki/RC4

MOD = 256


def KSA(key):
    ''' Key Scheduling Algorithm (from wikipedia):
        for i from 0 to 255
            S[i] := i
        endfor
        j := 0
        for i from 0 to 255
            j := (j + S[i] + key[i mod keylength]) mod 256
            swap values of S[i] and S[j]
        endfor
    '''
    key_length = len(key)
    # create the array "S"
    S = range(MOD)  # [0,1,2, ... , 255]
    j = 0
    for i in range(MOD):
        j = (j + S[i] + key[i % key_length]) % MOD
        S[i], S[j] = S[j], S[i]  # swap values

    return S


def PRGA(S):
    ''' Psudo Random Generation Algorithm (from wikipedia):
        i := 0
        j := 0
        while GeneratingOutput:
            i := (i + 1) mod 256
            j := (j + S[i]) mod 256
            swap values of S[i] and S[j]
            K := S[(S[i] + S[j]) mod 256]
            output K
        endwhile
    '''
    i = 0
    j = 0
    while True:
        i = (i + 1) % MOD
        j = (j + S[i]) % MOD

        S[i], S[j] = S[j], S[i]  # swap values
        K = S[(S[i] + S[j]) % MOD]
        yield K


def get_keystream(key):
    ''' Takes the encryption key to get the keystream using PRGA
        return object is a generator
    '''
    S = KSA(key)
    return PRGA(S)


def encrypt(key, plaintext):
    ''' :key -> encryption key used for encrypting, as hex string
        :plaintext -> string to encrpyt/decrypt
    '''
    # For plaintext key, use this
    # key = [ord(c) for c in key]

    # If key is in hex:
    key = key.decode('hex')
    key = [ord(c) for c in key]

    # Get the keystream
    keystream = get_keystream(key)

    res = []
    for c in plaintext:
        val = ("%02X" % (ord(c) ^ next(keystream)))  # XOR and taking hex
        res.append(val)
    return ''.join(res)


def decrypt(key, ciphertext):
    ''' :key -> encryption key used for encrypting, as hex string
        :ciphertext -> hex encoded ciphered text using RC4
    '''
    ciphertext = ciphertext.decode('hex')
    # print 'ciphertext to func:', ciphertext  # optional, to see
    res = encrypt(key, ciphertext)
    return res.decode('hex')

def print_options():
    print
    print "What would you like to do?"
    print "1. Recover plaintext messages"
    print "2. Alter ciphertext messages"
    print "3. Inject new message"
    print "4. Exit"
    print

def recover_plaintext():
    pass
def change_message():
    pass
def inject_message():
    pass
def main():

    key = 'not-so-random-key'  # plaintext,
    # key in hex: '6e6f742d736f2d72616e646f6d2d6b6579'
    plaintext = 'Good work! Your implementation is correct'  # plaintext
    # encrypt the plaintext, using key and RC4 algorithm
    ciphertext = encrypt(key, plaintext)
    print 'plaintext:', plaintext
    print 'ciphertext:', ciphertext
    # ..
    # Let's check the implementation
    # ..
    # ciphertext = '2D7FEE79FFCE80B7DDB7BDA5A7F878CE298615'\
    #    '476F86F3B890FD4746BE2D8F741395F884B4A35CE979'
    # change ciphertext to string again
    decrypted = decrypt(key, ciphertext)
    print 'decrypted:', decrypted

    if plaintext == decrypted:
        print('\nCongrats ! You made it.')
    else:
        print('Shit! You pooped your pants ! .-.')
    print_options()
    while True:
        option = int(raw_input("> "))
        if option == 1:
            recover_plaintext()
        elif option == 2:
            change_message()
        elif option == 3:
            inject_message()
        elif option == 4:
            print "Bye!"
            break
        else:
            print "Not a valid number!"



def test():

    # Test case 1
    # key = 'Key' # '4B6579' in hex
    # plaintext = 'Plaintext'
    # ciphertext = 'BBF316E8D940AF0AD3'
    assert(encrypt('Key', 'Plaintext')) == 'BBF316E8D940AF0AD3'
    assert(decrypt('Key', 'BBF316E8D940AF0AD3')) == 'Plaintext'

    # Test case 2
    # key = 'Wiki' # '57696b69'in hex
    # plaintext = 'pedia'
    # ciphertext should be 1021BF0420
    assert(encrypt('Wiki', 'pedia')) == '1021BF0420'
    assert(decrypt('Wiki', '1021BF0420')) == 'pedia'

    # Test case 3
    # key = 'Secret' # '536563726574' in hex
    # plaintext = 'Attack at dawn'
    # ciphertext should be 45A01F645FC35B383552544B9BF5
    assert(encrypt('Secret',
                   'Attack at dawn')) == '45A01F645FC35B383552544B9BF5'
    assert(decrypt('Secret',
                   '45A01F645FC35B383552544B9BF5')) == 'Attack at dawn'

if __name__ == '__main__':
    main()

