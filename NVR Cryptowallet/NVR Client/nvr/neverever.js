var abi = [
          {
              "inputs": [
                  {
                      "internalType": "string",
                      "name": "tokenName",
                      "type": "string"
                  },
                  {
                      "internalType": "string",
                      "name": "tokenVersion",
                      "type": "string"
                  },
                  {
                      "internalType": "string",
                      "name": "tokenSymbol",
                      "type": "string"
                  },
                  {
                      "internalType": "uint8",
                      "name": "tokenDecimals",
                      "type": "uint8"
                  },
                  {
                      "internalType": "uint256",
                      "name": "tokenTotalSupply",
                      "type": "uint256"
                  }
              ],
              "stateMutability": "nonpayable",
              "type": "constructor"
          },
          {
              "anonymous": false,
              "inputs": [
                  {
                      "indexed": true,
                      "internalType": "address",
                      "name": "owner",
                      "type": "address"
                  },
                  {
                      "indexed": true,
                      "internalType": "address",
                      "name": "spender",
                      "type": "address"
                  },
                  {
                      "indexed": false,
                      "internalType": "uint256",
                      "name": "value",
                      "type": "uint256"
                  }
              ],
              "name": "Approval",
              "type": "event"
          },
          {
              "anonymous": false,
              "inputs": [
                  {
                      "indexed": true,
                      "internalType": "address",
                      "name": "authorizer",
                      "type": "address"
                  },
                  {
                      "indexed": true,
                      "internalType": "bytes32",
                      "name": "nonce",
                      "type": "bytes32"
                  }
              ],
              "name": "AuthorizationCanceled",
              "type": "event"
          },
          {
              "anonymous": false,
              "inputs": [
                  {
                      "indexed": true,
                      "internalType": "address",
                      "name": "authorizer",
                      "type": "address"
                  },
                  {
                      "indexed": true,
                      "internalType": "bytes32",
                      "name": "nonce",
                      "type": "bytes32"
                  }
              ],
              "name": "AuthorizationUsed",
              "type": "event"
          },
          {
              "anonymous": false,
              "inputs": [
                  {
                      "indexed": true,
                      "internalType": "address",
                      "name": "from",
                      "type": "address"
                  },
                  {
                      "indexed": false,
                      "internalType": "uint256",
                      "name": "amount",
                      "type": "uint256"
                  },
                  {
                      "indexed": false,
                      "internalType": "uint256",
                      "name": "pricePerNVR",
                      "type": "uint256"
                  }
              ],
              "name": "BuyToken",
              "type": "event"
          },
          {
              "anonymous": false,
              "inputs": [
                  {
                      "indexed": true,
                      "internalType": "address",
                      "name": "from",
                      "type": "address"
                  },
                  {
                      "indexed": false,
                      "internalType": "uint256",
                      "name": "amount",
                      "type": "uint256"
                  },
                  {
                      "indexed": false,
                      "internalType": "uint256",
                      "name": "pricePerNVR",
                      "type": "uint256"
                  }
              ],
              "name": "SellToken",
              "type": "event"
          },
          {
              "anonymous": false,
              "inputs": [
                  {
                      "indexed": true,
                      "internalType": "address",
                      "name": "from",
                      "type": "address"
                  },
                  {
                      "indexed": true,
                      "internalType": "address",
                      "name": "to",
                      "type": "address"
                  },
                  {
                      "indexed": false,
                      "internalType": "uint256",
                      "name": "value",
                      "type": "uint256"
                  }
              ],
              "name": "Transfer",
              "type": "event"
          },
          {
              "inputs": [],
              "name": "CANCEL_AUTHORIZATION_TYPEHASH",
              "outputs": [
                  {
                      "internalType": "bytes32",
                      "name": "",
                      "type": "bytes32"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [],
              "name": "DOMAIN_SEPARATOR",
              "outputs": [
                  {
                      "internalType": "bytes32",
                      "name": "",
                      "type": "bytes32"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [],
              "name": "PERMIT_TYPEHASH",
              "outputs": [
                  {
                      "internalType": "bytes32",
                      "name": "",
                      "type": "bytes32"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [],
              "name": "RECEIVE_WITH_AUTHORIZATION_TYPEHASH",
              "outputs": [
                  {
                      "internalType": "bytes32",
                      "name": "",
                      "type": "bytes32"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [],
              "name": "TRANSFER_WITH_AUTHORIZATION_TYPEHASH",
              "outputs": [
                  {
                      "internalType": "bytes32",
                      "name": "",
                      "type": "bytes32"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "owner",
                      "type": "address"
                  },
                  {
                      "internalType": "address",
                      "name": "spender",
                      "type": "address"
                  }
              ],
              "name": "allowance",
              "outputs": [
                  {
                      "internalType": "uint256",
                      "name": "",
                      "type": "uint256"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "spender",
                      "type": "address"
                  },
                  {
                      "internalType": "uint256",
                      "name": "amount",
                      "type": "uint256"
                  }
              ],
              "name": "approve",
              "outputs": [
                  {
                      "internalType": "bool",
                      "name": "",
                      "type": "bool"
                  }
              ],
              "stateMutability": "nonpayable",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "authorizer",
                      "type": "address"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "nonce",
                      "type": "bytes32"
                  }
              ],
              "name": "authorizationState",
              "outputs": [
                  {
                      "internalType": "bool",
                      "name": "",
                      "type": "bool"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "account",
                      "type": "address"
                  }
              ],
              "name": "balanceOf",
              "outputs": [
                  {
                      "internalType": "uint256",
                      "name": "",
                      "type": "uint256"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "uint256",
                      "name": "amountToBuy",
                      "type": "uint256"
                  }
              ],
              "name": "buy",
              "outputs": [],
              "stateMutability": "payable",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "authorizer",
                      "type": "address"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "nonce",
                      "type": "bytes32"
                  },
                  {
                      "internalType": "uint8",
                      "name": "v",
                      "type": "uint8"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "r",
                      "type": "bytes32"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "s",
                      "type": "bytes32"
                  }
              ],
              "name": "cancelAuthorization",
              "outputs": [],
              "stateMutability": "nonpayable",
              "type": "function"
          },
          {
              "inputs": [],
              "name": "decimals",
              "outputs": [
                  {
                      "internalType": "uint8",
                      "name": "",
                      "type": "uint8"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "spender",
                      "type": "address"
                  },
                  {
                      "internalType": "uint256",
                      "name": "subtractedValue",
                      "type": "uint256"
                  }
              ],
              "name": "decreaseAllowance",
              "outputs": [
                  {
                      "internalType": "bool",
                      "name": "",
                      "type": "bool"
                  }
              ],
              "stateMutability": "nonpayable",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "from",
                      "type": "address"
                  },
                  {
                      "internalType": "address",
                      "name": "to",
                      "type": "address"
                  },
                  {
                      "internalType": "uint256",
                      "name": "value",
                      "type": "uint256"
                  },
                  {
                      "internalType": "uint256",
                      "name": "validAfter",
                      "type": "uint256"
                  },
                  {
                      "internalType": "uint256",
                      "name": "validBefore",
                      "type": "uint256"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "nonce",
                      "type": "bytes32"
                  },
                  {
                      "internalType": "uint8",
                      "name": "v",
                      "type": "uint8"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "r",
                      "type": "bytes32"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "s",
                      "type": "bytes32"
                  }
              ],
              "name": "gassLessSell",
              "outputs": [],
              "stateMutability": "nonpayable",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "from",
                      "type": "address"
                  },
                  {
                      "internalType": "address",
                      "name": "to",
                      "type": "address"
                  },
                  {
                      "internalType": "uint256",
                      "name": "value",
                      "type": "uint256"
                  },
                  {
                      "internalType": "uint256",
                      "name": "validAfter",
                      "type": "uint256"
                  },
                  {
                      "internalType": "uint256",
                      "name": "validBefore",
                      "type": "uint256"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "nonce",
                      "type": "bytes32"
                  },
                  {
                      "internalType": "uint8",
                      "name": "v",
                      "type": "uint8"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "r",
                      "type": "bytes32"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "s",
                      "type": "bytes32"
                  }
              ],
              "name": "gassLessTransfer",
              "outputs": [],
              "stateMutability": "nonpayable",
              "type": "function"
          },
          {
              "inputs": [],
              "name": "getPricePerNVR",
              "outputs": [
                  {
                      "internalType": "uint256",
                      "name": "",
                      "type": "uint256"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "spender",
                      "type": "address"
                  },
                  {
                      "internalType": "uint256",
                      "name": "addedValue",
                      "type": "uint256"
                  }
              ],
              "name": "increaseAllowance",
              "outputs": [
                  {
                      "internalType": "bool",
                      "name": "",
                      "type": "bool"
                  }
              ],
              "stateMutability": "nonpayable",
              "type": "function"
          },
          {
              "inputs": [],
              "name": "name",
              "outputs": [
                  {
                      "internalType": "string",
                      "name": "",
                      "type": "string"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "owner",
                      "type": "address"
                  }
              ],
              "name": "nonces",
              "outputs": [
                  {
                      "internalType": "uint256",
                      "name": "",
                      "type": "uint256"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "owner",
                      "type": "address"
                  },
                  {
                      "internalType": "address",
                      "name": "spender",
                      "type": "address"
                  },
                  {
                      "internalType": "uint256",
                      "name": "value",
                      "type": "uint256"
                  },
                  {
                      "internalType": "uint256",
                      "name": "deadline",
                      "type": "uint256"
                  },
                  {
                      "internalType": "uint8",
                      "name": "v",
                      "type": "uint8"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "r",
                      "type": "bytes32"
                  },
                  {
                      "internalType": "bytes32",
                      "name": "s",
                      "type": "bytes32"
                  }
              ],
              "name": "permit",
              "outputs": [],
              "stateMutability": "nonpayable",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "uint256",
                      "name": "amountToSell",
                      "type": "uint256"
                  }
              ],
              "name": "sell",
              "outputs": [],
              "stateMutability": "payable",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "uint256",
                      "name": "newPricePerNVR",
                      "type": "uint256"
                  }
              ],
              "name": "setPricePerPRH",
              "outputs": [],
              "stateMutability": "payable",
              "type": "function"
          },
          {
              "inputs": [],
              "name": "symbol",
              "outputs": [
                  {
                      "internalType": "string",
                      "name": "",
                      "type": "string"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [],
              "name": "totalSupply",
              "outputs": [
                  {
                      "internalType": "uint256",
                      "name": "",
                      "type": "uint256"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "recipient",
                      "type": "address"
                  },
                  {
                      "internalType": "uint256",
                      "name": "amount",
                      "type": "uint256"
                  }
              ],
              "name": "transfer",
              "outputs": [
                  {
                      "internalType": "bool",
                      "name": "",
                      "type": "bool"
                  }
              ],
              "stateMutability": "nonpayable",
              "type": "function"
          },
          {
              "inputs": [
                  {
                      "internalType": "address",
                      "name": "sender",
                      "type": "address"
                  },
                  {
                      "internalType": "address",
                      "name": "recipient",
                      "type": "address"
                  },
                  {
                      "internalType": "uint256",
                      "name": "amount",
                      "type": "uint256"
                  }
              ],
              "name": "transferFrom",
              "outputs": [
                  {
                      "internalType": "bool",
                      "name": "",
                      "type": "bool"
                  }
              ],
              "stateMutability": "nonpayable",
              "type": "function"
          },
          {
              "inputs": [],
              "name": "version",
              "outputs": [
                  {
                      "internalType": "string",
                      "name": "",
                      "type": "string"
                  }
              ],
              "stateMutability": "view",
              "type": "function"
          },
          {
              "stateMutability": "payable",
              "type": "receive"
          }
      ];