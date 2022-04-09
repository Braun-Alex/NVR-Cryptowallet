let WebSocketServer = require('ws')
let {ethers, BigNumber} = require("ethers");
const NVRArtifacts = require('./NeverEver.json');
const Web3 = require("./node_modules/web3")
const web3 = new Web3();
var  ethJsUtil = require( "./node_modules/ethereumjs-util");
const TRANSFER_WITH_AUTHORIZATION_TYPEHASH = web3.utils.keccak256(
    "TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)"
);
const abi = NVRArtifacts.abi;
const provider = new ethers.providers.InfuraProvider(
    "rinkeby",
    "Here is my Infura API key"
);
const addressContract = "0x6192595fB5ed0dbfaE1Aa7CB35D564e855D284aa";
const addressOwner = "0x56016C78469aF1547B9aA5747F000ff9201B690f";
const ownerPrivateKey = "Here is private key of my wallet";
function strip0x(v){
    return String(v).replace(/^0x/, "");
}

function hexStringFromBuffer(buf){
    return "0x" + buf.toString("hex");
}

function bufferFromHexString(hex){
    return Buffer.from(strip0x(hex), "hex");
}

function ecSign(digest, privateKey) {
    const { v, r, s } = ethJsUtil.ecsign(
        bufferFromHexString(digest),
        bufferFromHexString(privateKey)
    );

    return { v, r: hexStringFromBuffer(r), s: hexStringFromBuffer(s) };
}
function signEIP712(
    domainSeparator,
    typeHash,
    types,
    parameters,
    privateKey
) {
    const digest = web3.utils.keccak256(
        "0x1901" +
        strip0x(domainSeparator) +
        strip0x(
            web3.utils.keccak256(
                web3.eth.abi.encodeParameters(
                    ["bytes32", ...types],
                    [typeHash, ...parameters]
                )
            )
        )
    );

    return ecSign(digest, privateKey);
}

function signTransferAuthorization(
    from,
    to,
    value,
    validAfter,
    validBefore,
    nonce,
    domainSeparator,
    privateKey
) {
    return signEIP712(
        domainSeparator,
        TRANSFER_WITH_AUTHORIZATION_TYPEHASH,
        ["address", "address", "uint256", "uint256", "uint256", "bytes32"],
        [from, to, value, validAfter, validBefore, nonce],
        privateKey
    );
}
const gasLessSell = async(userSignerPrivateKey, amountToSell) => {
    try {
        amountToSell = ethers.utils.parseUnits(amountToSell.toString(), "ether");
    const MAX_UINT256 =
        "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
    var nonce = web3.utils.randomHex(32);
    const user_signer = new ethers.Wallet(userSignerPrivateKey, provider);
    const owner_signer = new ethers.Wallet(ownerPrivateKey, provider);
    let baseNonce = provider.getTransactionCount(owner_signer.getAddress());
    let nonceOffset = 0;
    function getNonce() {
        return baseNonce.then((nonce) => (nonce + (nonceOffset++)));
    }
    var NVR = new ethers.Contract(addressContract, abi, owner_signer);
    var domainSeparator = await NVR.DOMAIN_SEPARATOR({nonce: getNonce()});
    const transferParams = {
        from: await user_signer.getAddress(),
        to: await owner_signer.getAddress(),
        value: amountToSell,
        validAfter: 0,
        validBefore: MAX_UINT256,
    };
    const { from, to, value, validAfter, validBefore } = transferParams;
    const { v, r, s } = signTransferAuthorization(
        from,
        to,
        value,
        validAfter,
        validBefore,
        nonce,
        domainSeparator,
        userSignerPrivateKey
    );

    var transaction = NVR.gassLessSell(from, to, value, validAfter, validBefore, nonce, v, r, s,{nonce: getNonce()});
    var sendTransactionPromise = await owner_signer.sendTransaction(transaction);
    const receipt = await sendTransactionPromise.wait();
    return "DONE";
    }
    catch(error)
    {
    return "ERROR";
    }
}
const gasLessTransfer = async(userSignerPrivateKey, addressTo, amountToTransfer) => {
    try {
        amountToTransfer = ethers.utils.parseUnits(amountToTransfer.toString(), "ether");
        const MAX_UINT256 =
            "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
        var nonce = web3.utils.randomHex(32);
        const user_signer = new ethers.Wallet(userSignerPrivateKey, provider);
        const owner_signer = new ethers.Wallet(ownerPrivateKey, provider);
        let baseNonce = provider.getTransactionCount(owner_signer.getAddress());
        let nonceOffset = 0;
        function getNonce() {
            return baseNonce.then((nonce) => (nonce + (nonceOffset++)));
        }
        var NVR = new ethers.Contract(addressContract, abi, owner_signer);
        var domainSeparator = await NVR.DOMAIN_SEPARATOR({nonce: getNonce()});
        const transferParams = {
            from: await user_signer.getAddress(),
            to: addressTo,
            value: amountToTransfer,
            validAfter: 0,
            validBefore: MAX_UINT256,
        };
        const { from, to, value, validAfter, validBefore } = transferParams;
        const { v, r, s } = signTransferAuthorization(
            from,
            to,
            value,
            validAfter,
            validBefore,
            nonce,
            domainSeparator,
            userSignerPrivateKey
        );

        var transaction = NVR.gassLessTransfer(from, to, value, validAfter, validBefore, nonce, v, r, s,{nonce: getNonce()});
        var sendTransactionPromise = await owner_signer.sendTransaction(transaction);
        const receipt = await sendTransactionPromise.wait();
        return "DONE";
    }
    catch(error)
    {
    return "ERROR";
    }
}
const transfer = async(signerPrivateKey, addressTo, amountToTransfer) => {
    try
    {
        const signer = new ethers.Wallet(signerPrivateKey, provider);
        var NVR = new ethers.Contract(addressContract, abi, signer);
        var transaction = await NVR.transfer(addressTo, ethers.utils.parseUnits(amountToTransfer.toString(), "ether"));
        const receipt = await transaction.wait();
        return "DONE";
    }
    catch(error)
    {
    return "ERROR";
    }
}
const buy = async(signerPrivateKey, amountToBuy) => {
    try {
        const signer = new ethers.Wallet(signerPrivateKey, provider);
        let baseNonce = provider.getTransactionCount(signer.getAddress());
        let nonceOffset = 0;

        function getNonce() {
            return baseNonce.then((nonce) => (nonce + (nonceOffset++)));
        }
        amountToBuy = ethers.utils.parseUnits(amountToBuy.toString(), "ether");
        var NVR = new ethers.Contract(addressContract, abi, signer);
        var amount = BigNumber.from(amountToBuy);
        var price = await NVR.getPricePerNVR({nonce: getNonce()});
        var _value = (amount.mul(BigNumber.from(price))).div("1000000000000000000");
        var transaction = NVR.buy(amountToBuy, {value: _value.toString(), nonce: getNonce()});
        var sendTransactionPromise = await signer.sendTransaction(transaction);
        const receipt = await sendTransactionPromise.wait();
        return "DONE";
    }
    catch(error)
    {
    return "ERROR";
    }
}
const sell = async(signerPrivateKey, amountToSell) => {
    try {
        amountToSell = ethers.utils.parseUnits(amountToSell.toString(), "ether");
        const signer = new ethers.Wallet(signerPrivateKey, provider);
        let baseNonce = provider.getTransactionCount(signer.getAddress());
        let nonceOffset = 0;

        function getNonce() {
            return baseNonce.then((nonce) => (nonce + (nonceOffset++)));
        }

        var NVR = new ethers.Contract(addressContract, abi, signer);
        var allowance = await NVR.allowance(signer.address, addressContract, {nonce: getNonce()});
        console.log(allowance.toString());
        console.log(BigNumber.from(allowance).lt(BigNumber.from(amountToSell)));
        if (BigNumber.from(allowance).lt(BigNumber.from(amountToSell))) {
                var tr = NVR.increaseAllowance(addressContract, amountToSell, {nonce: getNonce()});
                var tx = await signer.sendTransaction(tr, {nonce: getNonce()});
                const receipt = await tx.wait();
        }
        var transaction = NVR.sell(amountToSell, {nonce: getNonce(), gasLimit: "9000000"});
        var sendTransactionPromise = await signer.sendTransaction(transaction);
        const receipt = await sendTransactionPromise.wait();
        return "DONE";
    }
    catch(error)
    {
    return "ERROR";
    }
}
const wss = new WebSocketServer.WebSocketServer({port: 80});
wss.on("connection", (ws) => {
    ws.on("message", async(data) => {
        let request = JSON.parse(data)
        var response;
        switch (request.command)
        {
            case 'transfer': response = await transfer(request.accountPrivateKey,
                request.addressTo, request.sum); break;
            case 'buy': response = await buy(request.accountPrivateKey, request.sum); break;
            case 'sell': response = await sell(request.accountPrivateKey, request.sum); break;
            case 'gasLessSell': response = await gasLessSell(request.accountPrivateKey,
                request.sum); break;
            case 'gasLessTransfer': response = await gasLessTransfer(request.accountPrivateKey,
                request.addressTo, request.sum); break;
        }
            ws.send(response);
    });
});