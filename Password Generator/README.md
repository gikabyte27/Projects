# Password Generator

> George Tudor | September 2nd, 2023

----------------------------

## Introduction

This tools intends to help anybody who wants to easily generate common passwords
based on generic rules using hashcat

## Usage

1. Clone the repository

```bash
git clone https://github.com/gikabyte27/Projects /opt/Projects
```

2. Install hashcat

Hashcat usually comes preinstalled in Kali Linux distributions. If you do not have it
installed, you can install it by

```bash
sudo apt update && sudo apt upgrade && sudo apt install hashcat
```

3. Run the password generator

```basch
cd '/opt/Projects/Password Generator/'
echo 'password' > seed.txt # Generating the seed
chmod +x ./generate_full_wordlist.sh
bash ./generate_full_wordlist.sh seed.txt
```
4. Enjoy!
