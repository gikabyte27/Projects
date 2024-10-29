import bcrypt

# Password to hash
password = "password"

# Generate a salt with a cost factor of 4 (the lower the cost, the faster the hash generation)
salt = bcrypt.gensalt(rounds=4, prefix=b"2y")

# Hash the password
hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)

# Output the hash
print(hashed_password.decode())
