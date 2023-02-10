#WEP protocol vulnerability abuse

The following scripts reflect the vulnerabilities in the WEP protocol, particularly the RC4 stream cipher.

Usage:

1) Start server on port 65432
2) Start man-in-the-middle on port 6666 (default)
3) Start client and provide port 6666 to connect to

MITM will then take place of a router which cannot decrypt the messages intercepted between Alice and Bob

Actually the MITM has a couple of options between forwarding the intercepted traffic, including decrypting or tampering an existing message on its route!

The communication is asynchronous between client and server in turns, with mitm intercepting the traffic

For more details on the WEP protocol, see attached conference article

Have fun!
