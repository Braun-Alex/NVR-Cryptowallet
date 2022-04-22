# NVR Cryptowallet

Decentralized Ethereum based application. 
Permits to interact with ERC-20 tokens
called "NeverEver".

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg)](https://choosealicense.com/licenses/mit/)



## 🛠 Tech Stack

**Database:** PostgreSQL.

**Server:** Node JS, Web3 JS, Ethers JS.

**Smart contract:** Solidity, OpenZeppelib.

**Blockchain:** Ethereum Rinkeby.

**Token standard:** ERC-20.

**Application:** Qt, QML, C++, JavaScript, CMake, Qaterial, 
QxOrm, QAESEncryption, SMTP Client for Qt.

**Installer:** Qt Installer Framework.

**Service-providers:** Digital Ocean, Infura, PM2.

## 🔗 Smart contract address

Smart contract address is always available on Ethereum
Rinkeby blockchain: [0x6192595fB5ed0dbfaE1Aa7CB35D564e855D284aa](https://rinkeby.etherscan.io/address/0x6192595fb5ed0dbfae1aa7cb35d564e855d284aa).

## 🚀 Overview

NVR Cryptowallet permits to manage
unique ERC-20 based token "NeverEver". It
achieves by the main interface with interacting
with the token and two
additional - account and wallet interfaces.
Here is detailed information about all
the interfaces.

#### Account interface

| Button            | Requirements                                                                        |
| :---------------- | :---------------------------------------------------------------------------------- |
| `Sign in`         | **Verificated account**.                                                            |
| `Sign up`         | **Email** and **password**. Verification **required**.                              |
| `Verify account`  | **Email** and **verification number**. The number is available within **24 hours**. |
| `Change password` | **Verificated account**.                                                            |
| `Recover account` | **Access to verificated email**.                                                    |
| `Exit`            | No requirements.

#### Wallet interface

| Button            | Requirements                                                                        |
| :---------------- | :---------------------------------------------------------------------------------- |
| `Encrypt wallet`  | **Created** or **imported** wallet.                                                 |
| `Create wallet`   | No requirements. Password for **wallet** is *optional*.                             |
| `Import wallet`   | **Wallet private key**. Password for **wallet** is *optional*.                      |
| `Buy VIP status`  | **Wallet address** and **not less than 33 NVR tokens** on any existing wallet.      |
| `Delete wallet`   | **Wallet address**.                                                                 |
| `Log out`         | No requirements.                                                                    |

> Notice: creating wallet takes place on blockchain.
> Importing wallet should already exist on blockchain.
> Deleting wallet takes place only on NVR Cryptowallet database.
> VIP status permits to have opportunity to transfer and sell NVR tokens **without commission**.
#### Token interface

| Page              | Description                                                                         |
| :---------------- | :---------------------------------------------------------------------------------- |
| `Settings`        | Displays wallet ***private key*** and ***address***.                                |
| `Transfer`        | Transferring *NVR tokens* to wallet by its ***address***.                           |
| `Buy`             | Buying *NVR tokens*.                                                                |
| `Sell`            | Selling *NVR tokens*.                                                               |

## ⚡️ Features

- [x] Open-source decentralized solution.
- [x] Private key of any cryptowallet is always known to the user.
- [x] Stunning graphical user experience.
- [x] High security standards for private data.
- [x] Encrypting and decrypting all the important data on the client side.

## 📌 Screenshots

### Account interface

![account_menu](./docs/account_menu.png)

### Sign in

![sign_in](./docs/signing_in.png)

### Sign up

![signing_up](./docs/signing_up.png)

### Verify account

![account verification](./docs/account_verification.png)

### Change password

![password_changing](./docs/password_changing.png)

### Recover account

![account_recovering](./docs/account_recovering.png)

### Wallet interface

![wallet_menu](./docs/wallet_menu.png)

### Decrypt wallet without its password

![decrypting_wallet_without_its_password](./docs/decrypting_wallet_without_its_password.png)

### Decrypt wallet with its password

![decrypting_wallet_with_its_password](./docs/decrypting_wallet_with_its_password.png)

### Create wallet without password encryption

![creating_wallet_without_password_encryption](./docs/creating_wallet_without_password_encryption.png)

### Create wallet with password encryption

![creating_wallet_with_password_encryption](./docs/creating_wallet_with_password_encryption.png)

### Import wallet without password encryption

![importing_wallet_without_password_encryption](./docs/importing_wallet_without_password_encryption.png)

### Import wallet with password encryption

![importing_wallet_with_password_encryption](./docs/importing_wallet_with_password_encryption.png)

### Delete wallet

![deleting_wallet](./docs/deleting_wallet.png)

### Buy VIP status without wallet password decryption

![buying_vip_status_without_wallet_password_decryption](./docs/buying_vip_status_without_wallet_password_decryption.png)

### Buy VIP status with wallet password decryption

![buying_vip_status_with_wallet_password_decryption](./docs/buying_vip_status_with_wallet_password_decryption.png)

### View wallet settings

![wallet_settings](./docs/wallet_settings.png)

### Transfer NVR tokens

![transferring_nvr_tokens](./docs/transferring_nvr_tokens.png)

### Buy NVR tokens

![buying_nvr_tokens](./docs/buying_nvr_tokens.png)

### Sell NVR tokens

![selling_nvr_tokens](./docs/selling_nvr_tokens.png)

## Authors

- [Alex Braun](https://github.com/Braun-Alex)
