import requests, json
URL = "http://mywalletv1.instant.htb/api/v1/register"
username = "gikabyte"
password = "Password123"
email = "gika@gika.com"
pin = "1234"
response = requests.post(URL,
                headers={"Content-Type": "application/json"},
                data=json.dumps({"username": username, "email": email, "password": password, "pin": pin}))
print(response.text)
print("Registration successful" if response.ok else f"Registration failed: {response.text}")
