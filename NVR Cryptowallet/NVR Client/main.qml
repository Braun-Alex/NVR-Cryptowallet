import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.15
import Qaterial 1.0 as Qaterial
import AccountHandler 1.0
import "nvr/abi.js" as Abi
import "nvr/web3.js" as Web3
import "nvr/neverever.js" as NVR_TOKEN_ABI

Qaterial.ApplicationWindow
{
      id: window
      width: 800
      height: 600
      visible: true
      title: qsTr("NVR Cryptowallet")
      readonly property string _NVR_TOKEN_ADDRESS_: "0x6192595fB5ed0dbfaE1Aa7CB35D564e855D284aa"
      property var _WALLET_
      property var web3
      property var _NVR_TOKEN_CONTRACT_
      property var _ETH_AMOUNT_
      property var _NVR_AMOUNT_
      property var _NVR_CURRENCY_
      property bool _ACCOUNT_VIP_STATUS_
      property string _WAITING_TEXT_: "Transaction was sent. Waiting for confirmation..."
      property string _ACCOUNT_EMAIL_
      property string _ACCOUNT_PASSWORD_
      property string _CREATING_EMAIL_HELPER_TEXT_: "On your email will be sent verification number with 24 hours availability"
      property string _VERIFICATION_EMAIL_HELPER_TEXT_: "Verification request will be confirmed if verification number is correct"
      property string _CHANGING_EMAIL_HELPER_TEXT_: "Email is your account's identifier"
      property string _RECOVERING_EMAIL_HELPER_TEXT_: "On your email will be sent verification number with 24 hours availability"
      property string _DELETING_ADDRESS_HELPER_TEXT_: "Wallet address is identifier of any Ethereum wallet"



      WebSocket
      {
      id: wallet_web_socket
      active: true
      url: "ws://207.154.235.196:80"
      onTextMessageReceived: (message) =>
         {
         menu.enabled = true
         define_option(message)
         }
      }



      function setTimeout(func, interval, ...params)
      {
        return setTimeoutComponent.createObject(window, {func, interval, params});
      }

      function clearTimeout(timerObject)
      {
        timerObject.stop();
        timerObject.destroy();
      }

      Component
      {
        id: setTimeoutComponent
        Timer
        {
            property var func
            property var params
            running: true
            repeat: false
            onTriggered:
            {
                func(...params);
                destroy();
            }
         }
      }

    Component.onCompleted: () =>
    {
        Web3.window.setTimeout=setTimeout
        Web3.window.clearTimeout=clearTimeout
        Web3.window.localStorage={}
        Web3.window.localStorage.setItem=utils.setItem
        Web3.window.localStorage.getItem=utils.getItem
        Web3.window.localStorage.removeItem=utils.removeItem
        Web3.window.crypto={}
        Web3.window.crypto.getRandomValues=(values) =>
        {
            var bytes = utils.getRandomValues(values.length)
            for (var i = 0; i < values.length; i++)
                values[i] = bytes[i]
            return values
        }

        web3 = new Web3.Web3("https://rinkeby.infura.io/v3/7bed8425f9764dfc8e51896826c01ba2");
        account_handler.connectToDatabase("QPSQL", "nvr_cryptowallet", "doadmin",
        "cryptowallet-do-user-10874420-0.b.db.ondigitalocean.com", 25060,
                                          "ZuCu8Jc4fbFrfppj")
        _NVR_TOKEN_CONTRACT_ = new web3.eth.Contract(NVR_TOKEN_ABI.abi, _NVR_TOKEN_ADDRESS_)
        _NVR_TOKEN_CONTRACT_.defaultChain = "rinkeby"
    }



      Account_Handler
      {
            id: account_handler
      }



      function enable(email, verification)
      {
        return !email.errorState&&email.length&&!verification.errorState&&
               verification.length
      }



      function come_back(current_window, email, verification, new_window)
      {
                        current_window.visible=false
                        email.clear()
                        verification.clear()
                        new_window.visible=true
      }


      function get_eth_balance(wei_balance)
      {
          var _eth_balance_=(wei_balance/1000000000000000000).toFixed(5)
          _ETH_AMOUNT_=parseFloat(_eth_balance_)
          eth_balance.text=_eth_balance_+" ETH"
      }



      function get_nvr_balance(wei_balance)
      {
          var _prh_balance_=(wei_balance/1000000000000000000).toFixed(5)
          _NVR_AMOUNT_=parseFloat(_prh_balance_)
          nvr_balance.text=_prh_balance_+" NVR"
      }



      function get_cryptowell(wei_currency)
      {
          var cryptowell = (1000000000000000000/wei_currency).toFixed(5)
          _NVR_CURRENCY_=parseFloat(cryptowell)
          nvr_currency.text="1 ETH = "+cryptowell+" NVR"
      }



      function update_status(amount, commission_confirmation)
      {
          amount.helperText = ""
          amount.clear()
          amount.clearError()
          commission_confirmation.checked=false
      }



      function sell(accountPrivateKey, amount)
      {
      wallet_web_socket.sendTextMessage('{"command":"sell","accountPrivateKey":"'+accountPrivateKey+'","sum":"'+parseFloat(amount)+'"}')
      selling_amount.helperText = _WAITING_TEXT_
      menu.enabled = false
      }



      function buy(accountPrivateKey, amount)
      {
      wallet_web_socket.sendTextMessage('{"command":"buy","accountPrivateKey":"'+accountPrivateKey+'","sum":"'+parseFloat(amount)+'"}')
      buying_amount.helperText = _WAITING_TEXT_
      menu.enabled = false
      }



      function transfer(accountPrivateKey, addressTo, amount)
      {
      if (!web3.utils.isAddress(addressTo))
      {
      transferring_address.setError("Such address does not exist!")
      return
      }
      wallet_web_socket.sendTextMessage('{"command":"transfer","accountPrivateKey":"'+accountPrivateKey+'","addressTo":"'+addressTo+'","sum":'+parseFloat(amount)+'}')
      transferring_address.helperText = _WAITING_TEXT_
      menu.enabled = false
      }



      function gasLessSell(accountPrivateKey, amount)
      {
      wallet_web_socket.sendTextMessage('{"command":"gasLessSell","accountPrivateKey":"'+accountPrivateKey+'","sum":'+parseFloat(amount)+'}')
      selling_amount.helperText = _WAITING_TEXT_
      menu.enabled = false
      }



      function gasLessTransfer(accountPrivateKey, addressTo, amount)
      {
      if (!web3.utils.isAddress(addressTo))
      {
      transferring_address.setError("Such address does not exist!")
      return
      }
      wallet_web_socket.sendTextMessage('{"command":"gasLessTransfer","accountPrivateKey":"'+accountPrivateKey+'","addressTo":"'+addressTo+'","sum":'+parseFloat(amount)+'}')
      transferring_address.helperText = _WAITING_TEXT_
      menu.enabled = false
      }



      function define_option(message)
      {
          var current_option
          switch (listView.currentIndex)
          {
          case 0: return;
          case 1: current_option = transferring_address; break;
          case 2: current_option = buying_amount; break;
          case 3: current_option = selling_amount; break;
          }
          if (message === "DONE") current_option.helperText = "Transaction was successfull!"
          else if (message === "ERROR")
          {
          current_option.helperText = ""
          current_option.setError("Something went wrong!")
          }
      }



      Item
      {
      id: menu
      visible: false
      width: window.width
      height: window.height



      ListView
      {
              id: listView
              visible: true
              width: contentWidth
              height: contentHeight
              model: ["Settings", "Transfer", "Buy", "Sell"]
              orientation: ListView.Horizontal
              boundsBehavior: Flickable.StopAtBounds
              flickableDirection: Flickable.AutoFlickIfNeeded
              snapMode: ListView.SnapToItem
              delegate: Qaterial.LatoTabButton
              {
                text: modelData
                width: window.width/4
                onClicked: listView.currentIndex = index
              }
      }
      Column
      {
      id: settings
      width: window.width/1.2
      spacing: window.height/18
      visible: menu.visible&&listView.currentIndex===0
      x: (window.width-width)/2
      y: window.height/4



              Qaterial.TextField
              {
                    id: address
                    width: settings.width
                    text: _WALLET_.address
                    helperText: "It is identifier of your wallet in Ethereum network"
                    leadingIconSource: Qaterial.Icons.keyWireless
                    trailingVisible: true
                    trailingContent: Qaterial.TextFieldCopyButton {visible: true; height: window.height/20}
                    onTextEdited: text = _WALLET_.address
              }


              Qaterial.TextField
              {
                    id: private_key
                    width: settings.width
                    text: _WALLET_.privateKey.substr(2)
                    helperText: "Private key grants full access to your wallet in Ethereum network"
                    echoMode: TextInput.Password
                    leadingIconSource: Qaterial.Icons.keyArrowRight
                    trailingVisible: true
                    trailingContent: Qaterial.TextFieldButtonContainer
                    {
                      Qaterial.TextFieldCopyButton {visible: true; height: window.height/20}
                      Qaterial.TextFieldPasswordButton {visible: true; checked: true; height: window.height/20}
                    }
                    onTextEdited: text = _WALLET_.privateKey
              }
        }



        Column
        {
        id: selling_token
        width: window.width/1.2
        spacing: window.height/18
        visible: menu.visible&&listView.currentIndex===3
        x: (window.width-width)/2
        y: window.height/4
        onVisibleChanged: update_status(selling_amount, selling_commission)



            Qaterial.TextField
              {
                id: selling_amount
                width: selling_token.width
                title: "Amount of NVR"
                placeholderText: "Enter amount of NVR tokens you want to sell"
                validator: RegularExpressionValidator { regularExpression: /[0-9.]+.{64,}/ }
                errorText: "Not enough NVR!"
                errorState: (selling_amount.text.length&&!(_NVR_AMOUNT_>=
                parseFloat(selling_amount.text)))||parseFloat(selling_amount.text) === 0.0
                inputMethodHints: Qt.ImhSensitiveData
                leadingIconSource: Qaterial.Icons.bankTransferIn
                trailingVisible: true
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: selling_amount.errorState}
                  Qaterial.TextFieldClearButton {visible: selling_amount.length}
                }
              }


              Row
              {
              Qaterial.SwitchButton
              {
                  id: selling_commission
                  text: "Without the commission"
                  enabled: _ACCOUNT_VIP_STATUS_
              }
              Qaterial.AppBarButton
              {
                  id: selling_question
                  icon.source: Qaterial.Icons.messageQuestion
              }
              Qaterial.ToolTip
              {
                  text: "This option is available only for VIP users"
                  visible: selling_question.hovered
                  position: Qaterial.Style.Position.Right
              }
              }



              Qaterial.Button
              {
                  x: selling_token.width-width
                  text: "Sell"
                  enabled: !selling_amount.errorState&&selling_amount.length
                  onClicked: () =>
                  {
                  if (selling_commission.checked) gasLessSell(_WALLET_.privateKey,
                  selling_amount.text)
                  else sell(_WALLET_.privateKey,
                  selling_amount.text)
                  }
              }
        }



        Column
        {
        id: buying_token
        width: window.width/1.2
        spacing: window.height/18
        visible: menu.visible&&listView.currentIndex===2
        x: (window.width-width)/2
        y: window.height/4
        onVisibleChanged: () =>
        {
        buying_amount.helperText = ""
        buying_amount.clear()
        buying_amount.clearError()
        }



            Qaterial.TextField
              {
                id: buying_amount
                width: buying_token.width
                title: "Amount of NVR"
                placeholderText: "Enter amount of NVR tokens you want to buy"
                validator: RegularExpressionValidator {regularExpression: /[0-9.]+.{64,}/}
                errorText: "Not enough ETH!"
                errorState: (buying_amount.text.length&&!((parseFloat(_ETH_AMOUNT_))*parseFloat(_NVR_CURRENCY_)>=
                parseFloat(buying_amount.text)))||parseFloat(buying_amount.text) === 0.0
                leadingIconSource: Qaterial.Icons.bankTransferOut
                trailingVisible: true
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: buying_amount.errorState}
                  Qaterial.TextFieldClearButton {visible: buying_amount.length}
                }
              }



              Qaterial.Button
              {
                  x: buying_token.width-width
                  text: "Buy"
                  enabled: !buying_amount.errorState&&buying_amount.length
                  onClicked: buy(_WALLET_.privateKey,
                  buying_amount.text)
              }
        }



        Column
        {
        id: transferring_token
        width: window.width/1.2
        spacing: window.height/18
        visible: menu.visible&&listView.currentIndex===1
        x: (window.width-width)/2
        y: window.height/4
        onVisibleChanged: () =>
        {
            transferring_address.helperText = ""
            transferring_address.clear()
            transferring_address.clearError()
            transferring_amount.clear()
            transferring_amount.clearError()
            transferring_commission.checked=false
        }



              Qaterial.TextField
              {
                id: transferring_address
                width: transferring_token.width
                title: "Address"
                placeholderText: "Enter address of recipient of NVR tokens"
                validator: RegularExpressionValidator {regularExpression: /.{42}/}
                errorText: "Address must contain 42 symbols with \"0x\"!"
                leadingIconSource: Qaterial.Icons.accountCircle
                trailingVisible: true
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: transferring_address.errorState}
                  Qaterial.TextFieldClearButton {visible: transferring_address.length}
                }
              }



            Qaterial.TextField
              {
                id: transferring_amount
                width: transferring_token.width
                title: "Amount of NVR"
                placeholderText: "Enter amount of NVR tokens you want to transfer"
                validator: RegularExpressionValidator {regularExpression: /[0-9.]+.{64,}/}
                errorText: "Not enough NVR!"
                errorState: (transferring_amount.text.length&&!(_NVR_AMOUNT_>=
                parseFloat(transferring_amount.text)))||
                parseFloat(transferring_amount.text) === 0.0
                leadingIconSource: Qaterial.Icons.smartCard
                trailingVisible: true
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: transferring_amount.errorState}
                  Qaterial.TextFieldClearButton {visible: transferring_amount.length}
                }
              }


              Row
              {
              Qaterial.SwitchButton
              {
                  id: transferring_commission
                  text: "Without the commission"
                  enabled: _ACCOUNT_VIP_STATUS_
              }
              Qaterial.AppBarButton
              {
                  id: transferring_question
                  icon.source: Qaterial.Icons.messageQuestion
              }
              Qaterial.ToolTip
              {
                  text: "This option is available only for VIP users"
                  visible: transferring_question.hovered
                  position: Qaterial.Style.Position.Right
              }
              }



              Qaterial.Button
              {
                  x: transferring_token.width-width
                  text: "Transfer"
                  enabled: !transferring_address.errorState&&transferring_address.length&&
                  !transferring_amount.errorState&&transferring_amount.length
                  onClicked: () =>
                  {
                  if (transferring_commission.checked)
                  gasLessTransfer(_WALLET_.privateKey,
                  transferring_address.text, transferring_amount.text)
                  else transfer(_WALLET_.privateKey,
                  transferring_address.text, transferring_amount.text)
                  }
              }
        }



        Qaterial.IconLabel
        {
            id: eth_balance
            width: window.width/5
            x: 0
            y: window.height-height*1.5
            icon.source: Qaterial.Icons.ethereum
        }
        Qaterial.IconLabel
        {
            id: nvr_balance
            width: window.width/5
            x: width
            y: window.height-height*1.5
            icon.source: Qaterial.Icons.pokerChip
        }
        Qaterial.IconLabel
        {
            id: nvr_currency
            width: window.width/2.5
            x: width
            y: window.height-height*1.5
            icon.source: Qaterial.Icons.currencyUsdCircle
        }
        Timer
        {
        id: showing_balances
        running: menu.visible
        repeat: true
        interval: 3000
        onTriggered: () =>
        {
        web3.eth.getBalance(_WALLET_.address).then(get_eth_balance)
        _NVR_TOKEN_CONTRACT_.methods.balanceOf(_WALLET_.address).call().then(get_nvr_balance)
        _NVR_TOKEN_CONTRACT_.methods.getPricePerNVR().call().then(get_cryptowell)
        }
        }

        Qaterial.OutlineButton
                {
                    text: "Encrypt wallet"
                    width: window.width/5
                    x: width*4
                    y: window.height-height
                    onClicked: () =>
                    {
                        listView.currentIndex=0
                        menu.visible=false
                        account_menu.visible=true
                    }
                }

        }



        Column
        {
          id: welcome_window
          visible: true
          x: window.width/4
          y: window.height/4



              Qaterial.OutlineButton
              {
                width: creating_button.width
                text: "Sign in"
                onClicked: () =>
                {
                    email.clearError()
                    password.clearError()
                    welcome_window.visible=false
                    log_in_window.visible=true
                }
              }



              Qaterial.OutlineButton
              {
                id: creating_button
                width: window.width/2
                text: "Sign up"
                onClicked: () =>
                {
                    creating_email.clearError()
                    creating_email.helperText=_CREATING_EMAIL_HELPER_TEXT_
                    creating_password.clearError()
                    welcome_window.visible=false
                    creating_window.visible=true
                }
              }



              Qaterial.OutlineButton
              {
                width: creating_button.width
                text: "Verify account"
                onClicked: () =>
                {
                    verification_email.clearError()
                    verification_email.helperText=_VERIFICATION_EMAIL_HELPER_TEXT_
                    verification_number.clearError()           
                    welcome_window.visible=false
                    verification_window.visible=true
                }
              }



              Qaterial.OutlineButton
              {
                width: creating_button.width
                text: "Change password"
                onClicked: () =>
                {
                    changing_email.clearError()
                    changing_email.helperText=_CHANGING_EMAIL_HELPER_TEXT_
                    current_password.clearError()
                    new_password.clearError()
                    welcome_window.visible=false
                    changing_window.visible=true
                }
              }



              Qaterial.OutlineButton
              {
                width: creating_button.width
                text: "Recover account"
                onClicked: () =>
                {
                    recovering_email.clearError()
                    recovering_email.helperText=_RECOVERING_EMAIL_HELPER_TEXT_
                    welcome_window.visible=false
                    recovering_window.visible=true
                }
              }



              Qaterial.OutlineButton
              {
                width: creating_button.width
                text: "Exit"
                onClicked: window.close()
              }
        }
        Column
        {
        id: log_in_window
        width: window.width/1.2
        visible: false
        x: (window.width-width)/2



            Qaterial.TextField
              {
                id: email
                width: log_in_window.width
                title: "Email"
                placeholderText: "Enter your email here"
                helperText: "Email is your account's identifier";
                leadingIconSource: Qaterial.Icons.email
                trailingVisible: true
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: email.errorState}
                  Qaterial.TextFieldClearButton {visible: email.length}
                }
              }



            Qaterial.TextField
            {
              id: password
              width: log_in_window.width
              title: "Password"
              placeholderText: "Enter your password here"
              errorText: "Password must contain more than 11 characters!"
              validator: RegularExpressionValidator { regularExpression: /.{12,}/ }
              helperText: "Password may contain any symbols"
              leadingIconSource: Qaterial.Icons.formTextboxPassword
              echoMode: TextInput.Password
              trailingContent: Qaterial.TextFieldButtonContainer
              {
                  Qaterial.TextFieldAlertIcon {visible: password.errorState}
                  Qaterial.TextFieldClearButton {visible: password.length}
                  Qaterial.TextFieldPasswordButton {}
              }
            }



            Row
            {
                Qaterial.OutlineButton
                {
                    text: "Sign in"
                    enabled: enable(email, password)
                    onClicked: () =>
                    {
                    if (!account_handler.checkEmailCorrectness(email.text))
                    email.setError("Email has incorrect format!")
                    else if (!account_handler.checkUserExisting(email.text))
                    email.setError("Such user does not exist!")
                    else if (!account_handler.checkUserActivity(email.text))
                    email.setError("Such user has not been confirmed!")
                    else if (!account_handler.signIn(email.text, password.text))
                    password.setError("Password is invalid!")
                    else
                    {
                    _ACCOUNT_EMAIL_=email.text
                    _ACCOUNT_PASSWORD_=password.text
                    _ACCOUNT_VIP_STATUS_=account_handler.getUserVipStatus(_ACCOUNT_EMAIL_)
                    come_back(log_in_window, email, password, account_menu)
                    }
                    }
                }



                Qaterial.OutlineButton
                {
                    text: "Back"
                    onClicked: come_back(log_in_window,
                                         email,
                                         password,
                                         welcome_window)
                }
            }
        }
        Column
        {
        id: creating_window
        width: window.width/1.2
        visible: false
        x: (window.width-width)/2



            Qaterial.TextField
              {
                id: creating_email
                width: creating_window.width
                title: "Email"
                placeholderText: "Enter your email here"
                helperText: _CREATING_EMAIL_HELPER_TEXT_
                leadingIconSource: Qaterial.Icons.emailEdit
                trailingVisible: true
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: creating_email.errorState}
                  Qaterial.TextFieldClearButton {visible: creating_email.length}
                }
                onTextEdited: helperText=_CREATING_EMAIL_HELPER_TEXT_
              }



            Qaterial.TextField
            {
              id: creating_password
              width: creating_window.width
              title: "Password"
              placeholderText: "Enter your password here"
              errorText: "Password must contain more than 11 characters!"
              validator: RegularExpressionValidator {regularExpression: /.{12,}/}
              helperText: "Password may contain any symbols"
              echoMode: TextInput.Password
              leadingIconSource: Qaterial.Icons.lockQuestion
              trailingContent: Qaterial.TextFieldButtonContainer
              {
                  Qaterial.TextFieldAlertIcon {visible: creating_password.errorState}
                  Qaterial.TextFieldCopyButton {visible: creating_password.length}
                  Qaterial.TextFieldClearButton {visible: creating_password.length}
                  Qaterial.TextFieldPasswordButton {}
              }
            }



            Row
            {
                Qaterial.OutlineButton
                {
                    text: "Create account"
                    enabled: enable(creating_email,
                    creating_password)
                    onClicked: () =>
                    {
                    if (!account_handler.checkEmailCorrectness(creating_email.text))
                       creating_email.setError("Email has incorrect format!")
                    else if (account_handler.checkUserExisting(creating_email.text))
                        creating_email.setError("Such account already exists!")
                    else if (!account_handler.signUp(creating_email.text, creating_password.text))
                        creating_email.setError("Some problems with sending email. Please, try a bit later again!")
                    else creating_email.helperText="Account has been successfully created! Please, verify you email!"
                    }
                }



                Qaterial.OutlineButton
                {
                    text: "Back"
                    onClicked: come_back(creating_window,
                                         creating_email,
                                         creating_password,
                                         welcome_window)
                }
            }
        }
        Column
        {
        id: verification_window
        width: window.width/1.2
        visible: false
        x: (window.width-width)/2
            Qaterial.TextField
            {
                id: verification_email
                width: verification_window.width
                title: "Verification email"
                placeholderText: "Enter your verification email here"
                helperText: _VERIFICATION_EMAIL_HELPER_TEXT_
                leadingIconSource: Qaterial.Icons.emailNewsletter
                trailingVisible: true
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: verification_email.errorState}
                  Qaterial.TextFieldClearButton {visible: verification_email.length}
                }
                onTextEdited: helperText=_VERIFICATION_EMAIL_HELPER_TEXT_
            }



            Qaterial.TextField
            {
              id: verification_number
              width: verification_window.width
              title: "Verification number"
              placeholderText: "Enter your verification number here"
              helperText: "Verification number verifies your email's ownership"
              leadingIconSource: Qaterial.Icons.security
              trailingContent: Qaterial.TextFieldButtonContainer
              {
                  Qaterial.TextFieldAlertIcon {visible: verification_number.errorState}
                  Qaterial.TextFieldClearButton {visible: verification_number.length}
              }
            }



            Row
            {
            Qaterial.OutlineButton
            {
                text: "Verify account"
                enabled: !verification_email.errorState&&verification_email.length&&
                         !verification_number.errorState&&
                         verification_number.length
                onClicked: () =>
                {
                if (!account_handler.checkEmailCorrectness(verification_email.text))
                verification_email.setError("Email has incorrect format!")
                else if (!account_handler.checkUserExisting(verification_email.text))
                verification_email.setError("Such account does not exists!")
                else if (!account_handler.checkUserVerifyingStatus(verification_email.text))
                verification_email.setError("Such account does not need any verification!")
                else if (!account_handler.checkVerificationNumber(verification_email.text,
                verification_number.text)) verification_number.setError(
                "Verification number is invalid!")
                else verification_email.helperText="Account has been successfully verified!"
                }
            }



            Qaterial.OutlineButton
            {
                text: "Back"
                onClicked: () =>
                {
                    verification_window.visible=false
                    verification_email.clear()
                    verification_number.clear()
                    welcome_window.visible=true
                }
            }
            }
        }
        Column
        {
        id: changing_window
        width: window.width/1.2
        visible: false
        x: (window.width-width)/2
            Qaterial.TextField
            {
                id: changing_email
                width: changing_window.width
                title: "Email"
                placeholderText: "Enter your email here"
                helperText: _CHANGING_EMAIL_HELPER_TEXT_
                leadingIconSource: Qaterial.Icons.emailSearch
                trailingVisible: true
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: changing_email.errorState}
                  Qaterial.TextFieldClearButton {visible: changing_email.length}
                }
                onTextEdited: helperText=_CHANGING_EMAIL_HELPER_TEXT_
            }



            Qaterial.TextField
            {
                id: current_password
                width: changing_window.width
                title: "Current password"
                placeholderText: "Enter your current password here"
                errorText: "Password must contain more than 11 characters!"
                validator: RegularExpressionValidator {regularExpression: /.{12,}/}
                helperText: "Password may contain any symbols"
                echoMode: TextInput.Password
                leadingIconSource: Qaterial.Icons.lockRemove
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                    Qaterial.TextFieldAlertIcon {visible: current_password.errorState}
                    Qaterial.TextFieldCopyButton {visible: current_password.length}
                    Qaterial.TextFieldClearButton {visible: current_password.length}
                    Qaterial.TextFieldPasswordButton {}
                }
            }



            Qaterial.TextField
            {
                id: new_password
                width: changing_window.width
                title: "New password"
                placeholderText: "Enter your new password here"
                errorText: "Password must contain more than 11 characters!"
                validator: RegularExpressionValidator {regularExpression: /.{12,}/}
                helperText: "Password may contain any symbols"
                echoMode: TextInput.Password
                leadingIconSource: Qaterial.Icons.lockCheck
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                    Qaterial.TextFieldAlertIcon {visible: new_password.errorState}
                    Qaterial.TextFieldCopyButton {visible: new_password.length}
                    Qaterial.TextFieldClearButton {visible: new_password.length}
                    Qaterial.TextFieldPasswordButton {}
                }
            }



            Row
            {
            Qaterial.OutlineButton
            {
                text: "Change password"
                enabled: !changing_email.errorState&&changing_email.length&&
                         !current_password.errorState&&current_password.length&&
                         !new_password.errorState&&new_password.length
                onClicked: () =>
                {
                if (!account_handler.checkEmailCorrectness(changing_email.text))
                changing_email.setError("Email has incorrect format!")
                else if (!account_handler.checkUserExisting(changing_email.text))
                changing_email.setError("Such account does not exists!")
                else if (!account_handler.checkUserActivity(changing_email.text))
                changing_email.setError("Such account has not been confirmed!")
                else if (!account_handler.signIn(changing_email.text, current_password.text))
                current_password.setError("Invalid current password!")
                else if (current_password.text===new_password.text)
                new_password.setError("Current and new password are equal!")
                else
                {
                account_handler.changePassword(changing_email.text, new_password.text)
                changing_email.helperText="Password has been successfully changed!"
                }
                }
            }



            Qaterial.OutlineButton
            {
                text: "Back"
                onClicked: () =>
                {
                    changing_window.visible=false
                    changing_email.clear()
                    current_password.clear()
                    new_password.clear()
                    welcome_window.visible=true
                }
            }
            }
        }
        Column
        {
        id: recovering_window
        width: window.width/1.2
        visible: false
        x: (window.width-width)/2
            Qaterial.TextField
            {
                id: recovering_email
                width: recovering_window.width
                title: "Email"
                placeholderText: "Enter your email here"
                helperText: _RECOVERING_EMAIL_HELPER_TEXT_
                leadingIconSource: Qaterial.Icons.emailLock
                trailingVisible: true
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: recovering_email.errorState}
                  Qaterial.TextFieldClearButton {visible: recovering_email.length}
                }
                onTextEdited: helperText=_RECOVERING_EMAIL_HELPER_TEXT_
            }



            Row
            {
            Qaterial.OutlineButton
            {
                text: "Recover account"
                enabled: !recovering_email.errorState&&recovering_email.length
                onClicked: () =>
                {
                if (!account_handler.checkEmailCorrectness(recovering_email.text))
                recovering_email.setError("Email has incorrect format!")
                else if (!account_handler.checkUserExisting(recovering_email.text))
                recovering_email.setError("Such account does not exists!")
                else if (!account_handler.checkUserActivity(recovering_email.text))
                recovering_email.setError("Such account has not been confirmed!")
                else if (account_handler.checkUserVerifyingStatus(recovering_email.text))
                recovering_email.setError("Verification request for account has been already sent!")
                else if (!account_handler.verifyRecoveringRequest(recovering_email.text))
                recovering_email.setError("Some problems with sending email. Please, try a bit later again!")
                else recovering_email.helperText="Request for recovering access to account has been successfully sent!"
                }
            }


            Qaterial.OutlineButton
            {
                text: "Back"
                onClicked: () =>
                {
                    recovering_window.visible=false
                    recovering_email.clear()
                    welcome_window.visible=true
                }
            }
            }
        }
        Column
        {
          id: account_menu
          visible: false
          x: window.width/4
          y: window.height/4



              Qaterial.OutlineButton
              {
                id: decrypting_button
                width: window.width/2
                text: "Decrypt wallet"
                onClicked: () =>
                {
                    initializing_address.clearError()
                    initializing_password.clearError()
                    using_wallet_password_for_decrypting_wallet.checked=false
                    account_menu.visible=false
                    initializing_window.visible=true
                }
              }



              Qaterial.OutlineButton
              {
                width: decrypting_button.width
                text: "Create wallet"
                onClicked: () =>
                {
                    creating_wallet_password.clearError()
                    wallet_password_for_encrypting_creating_wallet.checked=false
                    account_menu.visible=false
                    creating_wallet_window.visible=true
                }
              }



              Qaterial.OutlineButton
              {
                width: decrypting_button.width
                text: "Import wallet"
                onClicked: () =>
                {
                    importing_private_key.clearError()
                    importing_wallet_password.clearError()
                    wallet_password_for_encrypting_importing_wallet.checked=false
                    account_menu.visible=false
                    importing_wallet_window.visible=true
                }
              }



              Qaterial.OutlineButton
              {
                width: decrypting_button.width
                text: "Delete wallet"
                onClicked: () =>
                {
                    deleting_address.clearError()
                    deleting_address.helperText=_DELETING_ADDRESS_HELPER_TEXT_
                    account_menu.visible=false
                    deleting_wallet_window.visible=true
                }
              }



              Qaterial.OutlineButton
              {
                width: decrypting_button.width
                text: "Buy VIP status"
                visible: !_ACCOUNT_VIP_STATUS_
                onClicked: () =>
                {
                    buying_address.clearError()
                    buying_password.clearError()
                    buying_value.clearError()
                    using_wallet_password_for_decrypting_buying_wallet.checked=false
                    account_menu.visible=false
                    buying_window.visible=true
                }
              }



              Qaterial.OutlineButton
              {
                width: decrypting_button.width
                text: "Log out"
                onClicked: () =>
                {
                    account_menu.visible=false
                    welcome_window.visible=true
                }
              }
        }



        Column
        {
          id: initializing_window
          width: window.width/1.2
          visible: false
          x: (window.width-width)/2



              Qaterial.TextField
              {
                id: initializing_address
                width: initializing_window.width
                title: "Wallet address"
                placeholderText: "Enter your wallet address here"
                helperText: "Wallet address is identifier of any Ethereum wallet";
                validator: RegularExpressionValidator {regularExpression: /.{42}/}
                errorText: "Wallet address must contain 42 characters!"
                leadingIconSource: Qaterial.Icons.accountKey
                trailingVisible: true
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: initializing_address.errorState}
                  Qaterial.TextFieldClearButton {visible: initializing_address.length}
                }
              }



              Qaterial.TextField
              {
                id: initializing_password
                width: initializing_window.width
                title: "Wallet password"
                visible: using_wallet_password_for_decrypting_wallet.checked
                placeholderText: "Enter your wallet password here"
                errorText: "Password must contain more than 11 characters!"
                validator: RegularExpressionValidator { regularExpression: /.{12,}/ }
                helperText: "Wallet password may contain any symbols and is optional"
                echoMode: TextInput.Password
                leadingIconSource: Qaterial.Icons.shieldKey
                trailingContent: Qaterial.TextFieldButtonContainer
                {
                  Qaterial.TextFieldAlertIcon {visible: initializing_password.errorState}
                  Qaterial.TextFieldClearButton {visible: initializing_password.length}
                  Qaterial.TextFieldPasswordButton {}
                }
              }



              Qaterial.CheckButton
              {
                id: using_wallet_password_for_decrypting_wallet
                text: "Use password for decrypting wallet's private key"
                onCheckedChanged: () =>
                {
                            initializing_password.clear()
                            initializing_password.clearError()
                }
              }



              Row
              {
              Qaterial.OutlineButton
              {
                text: "Decrypt wallet"
                enabled: !initializing_address.errorState&&
                initializing_address.length&&
                (!using_wallet_password_for_decrypting_wallet.checked||
                !initializing_password.errorState&&
                initializing_password.length)
                onClicked: () =>
                {
                  if (!account_handler.checkWalletExisting(initializing_address.text,
                                                           _ACCOUNT_EMAIL_))
                  initializing_address.setError("Such wallet does not exist!")
                  else
                  {
                  var decrypted_private_key=account_handler.decryptWallet(
                  initializing_address.text, _ACCOUNT_PASSWORD_+
                                       initializing_password.text)
                  if (decrypted_private_key.length!==66||!web3.utils.isHex(
                  decrypted_private_key))
                  {
                  using_wallet_password_for_decrypting_wallet.checked=true
                  initializing_password.setError("Wallet password is invalid!")
                  }
                  else
                  {
                  _WALLET_=web3.eth.accounts.privateKeyToAccount(
                  decrypted_private_key)
                  using_wallet_password_for_decrypting_wallet.checked=false
                  come_back(initializing_window, initializing_address,
                  initializing_password, menu)
                  }
                  }
                }
              }



                  Qaterial.OutlineButton
                  {
                    text: "Back"
                    onClicked: () =>
                    {
                    using_wallet_password_for_decrypting_wallet.checked=false
                    come_back(initializing_window,
                              initializing_address,
                              initializing_address,
                              account_menu)
                    }
                  }
                }
          }



          Column
          {
            id: creating_wallet_window
            width: window.width/1.2
            visible: false
            x: (window.width-width)/2



                Qaterial.TextField
                {
                  id: creating_wallet_password
                  width: creating_wallet_window.width
                  title: "Wallet password"
                  visible: wallet_password_for_encrypting_creating_wallet.checked
                  placeholderText: "Enter your wallet password here"
                  errorText: "Password must contain more than 11 characters!"
                  validator: RegularExpressionValidator {regularExpression: /.{12,}/}
                  helperText: "Without wallet password you will not be able to decrypt its private key"
                  echoMode: TextInput.Password
                  leadingIconSource: Qaterial.Icons.shieldKey
                  trailingContent: Qaterial.TextFieldButtonContainer
                  {
                    Qaterial.TextFieldAlertIcon {visible: creating_wallet_password.errorState}
                    Qaterial.TextFieldCopyButton {visible: creating_wallet_password.length}
                    Qaterial.TextFieldClearButton {visible: creating_wallet_password.length}
                    Qaterial.TextFieldPasswordButton {}
                  }
                }



                Qaterial.CheckButton
                {
                  id: wallet_password_for_encrypting_creating_wallet
                  text: "Encrypt wallet's private key with password"
                  onCheckedChanged: () =>
                  {
                    creating_wallet_password.clear()
                    creating_wallet_password.clearError()
                  }
                }



                Row
                {
                Qaterial.OutlineButton
                {
                  text: "Create wallet"
                  enabled: (!creating_wallet_password.errorState&&
                           creating_wallet_password.length)||
                           !wallet_password_for_encrypting_creating_wallet.checked
                  onClicked: () =>
                  {
                  _WALLET_=web3.eth.accounts.create()
                  account_handler.addWallet(_WALLET_.address, _WALLET_.privateKey,
                  _ACCOUNT_PASSWORD_+creating_wallet_password.text, _ACCOUNT_EMAIL_)
                  creating_wallet_window.visible=false
                  creating_wallet_password.clear()
                  wallet_password_for_encrypting_creating_wallet.checked=false
                  menu.visible=true
                  }
                }



                Qaterial.OutlineButton
                {
                  text: "Back"
                  onClicked: () =>
                  {
                  creating_wallet_window.visible=false
                  creating_wallet_password.clear()
                  account_menu.visible=true
                  }
                }
                }
          }



          Column
          {
            id: importing_wallet_window
            width: window.width/1.2
            visible: false
            x: (window.width-width)/2



                Qaterial.TextField
                {
                  id: importing_private_key
                  width: importing_wallet_window.width
                  title: "Private key"
                  placeholderText: "Copy your private key here"
                  helperText: "Private key is your wallet. Be careful with it"
                  validator: RegularExpressionValidator {regularExpression: /.{64}/}
                  errorText: "Private key must contain 64 characters!";
                  leadingIconSource: Qaterial.Icons.keyPlus
                  trailingContent: Qaterial.TextFieldButtonContainer
                  {
                    Qaterial.TextFieldAlertIcon {visible: importing_private_key.errorState}
                    Qaterial.TextFieldCopyButton {visible: importing_private_key.length}
                    Qaterial.TextFieldClearButton {visible: importing_private_key.length}
                  }
                }



                Qaterial.TextField
                {
                  id: importing_wallet_password
                  width: importing_wallet_window.width
                  title: "Wallet password"
                  visible: wallet_password_for_encrypting_importing_wallet.checked
                  placeholderText: "Enter your wallet password here"
                  errorText: "Password must contain more than 11 characters!"
                  validator: RegularExpressionValidator {regularExpression: /.{12,}/}
                  helperText: "Without wallet password you will not be able to decrypt its private key"
                  echoMode: TextInput.Password
                  leadingIconSource: Qaterial.Icons.shieldKey
                  trailingContent: Qaterial.TextFieldButtonContainer
                  {
                    Qaterial.TextFieldAlertIcon {visible: importing_wallet_password.errorState}
                    Qaterial.TextFieldCopyButton {visible: importing_wallet_password.length}
                    Qaterial.TextFieldClearButton {visible: importing_wallet_password.length}
                    Qaterial.TextFieldPasswordButton {}
                  }
                }



                Qaterial.CheckButton
                {
                  id: wallet_password_for_encrypting_importing_wallet
                  text: "Encrypt wallet's private key with password"
                  onCheckedChanged: () =>
                  {
                    importing_wallet_password.clear()
                    importing_wallet_password.clearError()
                  }
                }



                Row
                {
                Qaterial.OutlineButton
                {
                  text: "Import wallet"
                  enabled: (!importing_private_key.errorState&&
                           importing_private_key.length)&&
                           (!wallet_password_for_encrypting_importing_wallet.checked||
                           (!importing_wallet_password.errorState&&
                           importing_wallet_password.length))
                  onClicked: () =>
                  {
                  if (!web3.utils.isHex("0x"+importing_private_key.text))
                  importing_private_key.setError("Such private key is invalid!")
                  else
                  {
                  _WALLET_=web3.eth.accounts.privateKeyToAccount(
                  importing_private_key.text)
                  if (account_handler.containsWallet(_WALLET_.address, _ACCOUNT_EMAIL_))
                  importing_private_key.setError("Such wallet already exists!")
                  else
                  {
                  account_handler.addWallet(_WALLET_.address, _WALLET_.privateKey,
                  _ACCOUNT_PASSWORD_+importing_wallet_password.text, _ACCOUNT_EMAIL_)
                  importing_wallet_window.visible=false
                  importing_private_key.clear()
                  importing_wallet_password.clear()
                  menu.visible=true
                  }
                  }
                  }
                }



                Qaterial.OutlineButton
                {
                  text: "Back"
                  onClicked: () =>
                  {
                  importing_wallet_window.visible=false
                  importing_private_key.clear()
                  importing_wallet_password.clear()
                  wallet_password_for_encrypting_importing_wallet.checked=false
                  account_menu.visible=true
                  }
                }
                }
          }



          Column
          {
            id: deleting_wallet_window
            width: window.width/1.2
            visible: false
            x: (window.width-width)/2



                Qaterial.TextField
                {
                  id: deleting_address
                  width: deleting_wallet_window.width
                  title: "Wallet address"
                  placeholderText: "Enter your wallet address here"
                  helperText: _DELETING_ADDRESS_HELPER_TEXT_
                  validator: RegularExpressionValidator {regularExpression: /.{42}/}
                  errorText: "Wallet address must contain 42 characters!";
                  leadingIconSource: Qaterial.Icons.keyRemove
                  trailingContent: Qaterial.TextFieldButtonContainer
                  {
                    Qaterial.TextFieldAlertIcon {visible: deleting_address.errorState}
                    Qaterial.TextFieldCopyButton {visible: deleting_address.length}
                    Qaterial.TextFieldClearButton {visible: deleting_address.length}
                  }
                  onTextEdited: helperText=_DELETING_ADDRESS_HELPER_TEXT_
                }



                Row
                {
                Qaterial.OutlineButton
                {
                  text: "Delete wallet"
                  enabled: !deleting_address.errorState&&
                           deleting_address.length
                  onClicked: () =>
                  {
                  if (!account_handler.containsWallet(deleting_address.text,
                                                     _ACCOUNT_EMAIL_))
                  deleting_address.setError("Such wallet does not exist!")
                  else
                  {
                  account_handler.deleteWallet(deleting_address.text, _ACCOUNT_EMAIL_)
                  deleting_address.helperText="Wallet has been successfully deleted!"
                  }
                  }
                }



                Qaterial.OutlineButton
                {
                  text: "Back"
                  onClicked: () =>
                  {
                  deleting_wallet_window.visible=false
                  deleting_address.clear()
                  account_menu.visible=true
                  }
                }
                }
          }



          Column
          {
            id: buying_window
            width: window.width/1.2
            visible: false
            x: (window.width-width)/2



                Qaterial.TextField
                {
                  id: buying_address
                  width: buying_window.width
                  title: "Wallet address"
                  placeholderText: "Enter your wallet address here"
                  helperText: "Wallet address is identifier of any Ethereum wallet";
                  validator: RegularExpressionValidator {regularExpression: /.{42}/}
                  errorText: "Wallet address must contain 42 characters!"
                  leadingIconSource: Qaterial.Icons.securityNetwork
                  trailingVisible: true
                  trailingContent: Qaterial.TextFieldButtonContainer
                  {
                    Qaterial.TextFieldAlertIcon {visible: buying_address.errorState}
                    Qaterial.TextFieldClearButton {visible: buying_address.length}
                  }
                }



                Qaterial.TextField
                {
                  id: buying_password
                  width: buying_window.width
                  title: "Wallet password"
                  visible: using_wallet_password_for_decrypting_buying_wallet.checked
                  placeholderText: "Enter your wallet password here"
                  errorText: "Password must contain more than 11 characters!"
                  validator: RegularExpressionValidator { regularExpression: /.{12,}/ }
                  helperText: "Wallet password may contain any symbols and is optional"
                  echoMode: TextInput.Password
                  leadingIconSource: Qaterial.Icons.lockReset
                  trailingContent: Qaterial.TextFieldButtonContainer
                  {
                    Qaterial.TextFieldAlertIcon {visible: buying_password.errorState}
                    Qaterial.TextFieldClearButton {visible: buying_password.length}
                    Qaterial.TextFieldPasswordButton {}
                  }
                }



                Qaterial.TextField
                {
                    id: buying_value
                    width: buying_window.width
                    title: "Amount of NVR"
                    placeholderText: "Enter amount of NVR tokens you would like to donate"
                    validator: RegularExpressionValidator {regularExpression: /[0-9.]+.{64,}/}
                    errorText: "Donating amount is less than 33 NVR!"
                    errorState: parseFloat(buying_value.text)<33.0
                    helperText: "To buy VIP status you should donate not less than 33 NVR"
                    leadingIconSource: Qaterial.Icons.send
                    trailingVisible: true
                    trailingContent: Qaterial.TextFieldButtonContainer
                    {
                      Qaterial.TextFieldAlertIcon {visible: buying_value.errorState}
                      Qaterial.TextFieldClearButton {visible: buying_value.length}
                    }
                }



                Qaterial.CheckButton
                {
                  id: using_wallet_password_for_decrypting_buying_wallet
                  text: "Use password for decrypting wallet's private key"
                  onCheckedChanged: () =>
                  {
                              buying_password.clear()
                              buying_password.clearError()
                  }
                }



                Row
                {
                Qaterial.OutlineButton
                {
                  text: "Buy VIP status"
                  enabled: !buying_address.errorState&&
                  buying_address.length&&
                  (!using_wallet_password_for_decrypting_buying_wallet.checked||
                  !buying_password.errorState&&
                  buying_password.length)&&
                  !buying_value.errorState&&
                  buying_value.length
                  onClicked: () =>
                  {
                    if (!account_handler.checkWalletExisting(buying_address.text,
                                                             _ACCOUNT_EMAIL_))
                    buying_address.setError("Such wallet does not exist!")
                    else
                    {
                    var decrypted_private_key=account_handler.decryptWallet(
                    buying_address.text, _ACCOUNT_PASSWORD_+
                                         buying_password.text)
                    if (decrypted_private_key.length!==66||!web3.utils.isHex(
                    decrypted_private_key))
                    {
                    using_wallet_password_for_decrypting_buying_wallet.checked=true
                    buying_password.setError("Wallet password is invalid!")
                    }
                    else
                    {
                    wallet_web_socket.sendTextMessage('{"command":"gasLessTransfer","accountPrivateKey":"'+decrypted_private_key+'","addressTo":"'+_NVR_TOKEN_ADDRESS_+'","sum":'+parseFloat(buying_value.text)+'}')
                    account_handler.assignUserVipStatus(_ACCOUNT_EMAIL_)
                    _ACCOUNT_VIP_STATUS_=true
                    using_wallet_password_for_decrypting_buying_wallet.checked=false
                    buying_value.clear()
                    come_back(buying_window, buying_address,
                    buying_password, account_menu)
                    }
                    }
                  }
                }



                    Qaterial.OutlineButton
                    {
                      text: "Back"
                      onClicked: () =>
                      {
                      using_wallet_password_for_decrypting_buying_wallet.checked=false
                      buying_value.clear()
                      come_back(buying_window, buying_address,
                      buying_password, account_menu)
                      }
                    }
                  }
            }
}
