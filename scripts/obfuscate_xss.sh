# To be included into an eval()
python -c 'print([ord(letter) for letter in "alert(1)"])' | tr '[' '(' | tr ']' ')' | sed 's/^/String.fromCharCode/g'
