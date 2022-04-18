# NVR Cryptowallet

Decentralized Ethereum based application. 
Permits to interact with ERC-20 tokens
called "NeverEver".

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://choosealicense.com/licenses/mit/)



## 🛠 Tech Stack

**Database:** PostgreSQL.

**Server:** Node JS, Web3 JS, Ethers JS.

**Smart contract:** Solidity, OpenZeppelib.

**Blockchain:** Ethereum Rinkeby.

**Token standard:** ERC-20.

**Application:** Qt, QML, C++, JavaScript, Qaterial, 
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
additional - account and cryptowallet interfaces.
Here is detailed information about all
the interfaces.

#### Account interface

| Button            | Requirements                                                                        |
| :---------------- | :---------------------------------------------------------------------------------- |
| `Sign in`         | **Verificated account**.                                                            |
| `Sign up`         | **Email** and **password**. Verification **required**.                              |
| `Verify`          | **Email** and **verification number**. The number is available within **24 hours**. |
| `Change password` | **Verificated account**.                                                            |
| `Recover account` | **Access to verificated email**.                                                    |
| `Exit`            | No requirements.

#### Cryptowallet interface

| Button            | Requirements                                                                        |
| :---------------- | :---------------------------------------------------------------------------------- |
| `Encrypt wallet`  | **Created** or **imported** wallet.                                                 |
| `Create wallet`   | No requirements. Password for **wallet** is *optional*.                             |
| `Import wallet`   | **Wallet private key**. Password for **wallet** is *optional*.                      |
| `Delete wallet`   | **Wallet address**.                                                                 |
| `Log out`         | No requirements.                                                                    |

> Notice: creating wallet takes place on blockchain.
> Importing wallet must already exist on blockchain.
> Deleting wallet takes place only on NVR Cryptowallet database.
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
