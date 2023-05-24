#!/bin/bash

# Preparing the JWT header. Notice the URL substitution of base64
jwt_header=$(echo -n '{"alg":"HS256","typ":"JWT"}' | base64 | sed s/\+/-/g | sed 's/\//_/g' | sed -E s/=+$//)

# Preparing the JWT payload
payload=$(echo -n '{"login":"admin"}' | base64 | sed s/\+/-/g |sed 's/\//_/g' |  sed -E s/=+$//)

# Reading the public key and converting it to hex bytes, newline included
hexsecret=$(xxd -p public.pem | tr -d '\n')

# Using openssl to sign the header+.+payload
hmac_signature=$(echo -n "${jwt_header}.${payload}" |  openssl dgst -sha256 -mac HMAC -macopt hexkey:$hexsecret -binary | base64  | sed s/\+/-/g | sed 's/\//_/g' | sed -E s/=+$//)

# Creating the final JWT token
jwt="${jwt_header}.${payload}.${hmac_signature}"

# Voila!
echo $jwt
