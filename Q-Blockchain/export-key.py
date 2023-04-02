import os
import json
from eth_account import Account

def decrypt_account(filename, password):
    with open(filename, 'r') as f:
        keystore = json.load(f)
        private_key = Account.decrypt(keystore, password).hex()
        return Account.from_key(private_key)

def main():
    keystore_path = '/root/testnet-public-tools/testnet-validator/keystore'
    filenames = [f'{keystore_path}/{file}' for file in os.listdir(keystore_path) if file.startswith('UTC')]
    
    with open(f'{keystore_path}/pwd.txt', 'r') as f:
        password = f.read().split('\n')[0]
    
    for filename in filenames:
        account = decrypt_account(filename, password)
        print(f'Address: {account.address}\nPrivate Key: {account.key.hex()}\n\n')

if __name__ == '__main__':
    main()
