#include "account_handler.h"
#include "resources.h"
Account_Handler::Account_Handler(QObject* parent): QObject(parent),
email_validator("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") {}
bool Account_Handler::checkEmailCorrectness(const QString &email)
{
return email_validator.match(email).hasMatch();
}
bool Account_Handler::checkUserExisting(const QString &email)
{
User user;
user.email=email;
bool check=qx::dao::exist(user);
if (check)
{
Inactivated_User inactivated_user;
inactivated_user.email=email;
if (qx::dao::exist(inactivated_user))
{
qx::dao::fetch_by_id(inactivated_user);
if (QDateTime::currentDateTimeUtc().toSecsSinceEpoch()-
    inactivated_user.registering_moment.toSecsSinceEpoch()>seconds_in_day)
{
check=inactivated_user.active_status;
if (!check) qx::dao::destroy_by_id(user);
qx::dao::destroy_by_id(inactivated_user);
}
}
}
return check;
}
bool Account_Handler::checkWalletExisting(const QString &wallet_address,
                                          const QString &email)
{
Cryptowallet cryptowallet;
cryptowallet.wallet_address=wallet_address;
bool check=qx::dao::exist(cryptowallet);
if (check)
{
qx::dao::fetch_by_id(cryptowallet);
check=(cryptowallet.email==email);
}
return check;
}
bool Account_Handler::signIn(const QString &email,
                             const QString &password)
{
User user;
user.email=email;
qx::dao::fetch_by_id(user);
return email==QString(decrypt(user.password, password, vector_phrase));
}
void Account_Handler::changePassword(const QString &email,
                                     const QString &new_password)
{
User user;
user.email=email;
qx::dao::fetch_by_id(user);
user.password=encrypt(email, new_password, vector_phrase);
qx::dao::update(user);
}
bool Account_Handler::recoverAccount(const QString &email)
{
QRandomGenerator password_generator=QRandomGenerator::securelySeeded();
QString new_password;
new_password.reserve(new_password_size);
for (unsigned int i=0; i<new_password_size; i++) new_password.push_back(
password_generator.bounded(65, 122));
bool hasBeenSent=sendNewPasswordMessage(email, new_password);
if (hasBeenSent) changePassword(email, new_password);
return hasBeenSent;
}
bool Account_Handler::verifyRecoveringRequest(const QString &email)
{
QRandomGenerator verification_generator=QRandomGenerator::securelySeeded();
QString verification_number;
verification_number.reserve(verification_number_size);
for (unsigned int i=0; i<verification_number_size; ++i) verification_number.push_back(
QString::number(verification_generator.bounded(0, 9)));
bool hasBeenSent=sendRecoveringMessage(email, verification_number);
if (hasBeenSent)
{
Inactivated_User inactivated_user;
inactivated_user.email=email;
inactivated_user.verification_number=encrypt(email, verification_number, vector_phrase);
inactivated_user.active_status=true;
qx::dao::insert(inactivated_user);
}
return hasBeenSent;
}
bool Account_Handler::signUp(const QString &email,
                             const QString &password)
{
QRandomGenerator verification_generator=QRandomGenerator::securelySeeded();
QString verification_number;
verification_number.reserve(verification_number_size);
for (unsigned int i=0; i<verification_number_size; ++i) verification_number.push_back(
QString::number(verification_generator.bounded(0, 9)));
bool hasBeenSent=sendVerificationMessage(email, verification_number);
if (hasBeenSent)
{
Inactivated_User inactivated_user;
User user;
inactivated_user.email=email;
user.email=email;
user.password=encrypt(email, password, vector_phrase);
inactivated_user.verification_number=encrypt(email, verification_number, vector_phrase);
inactivated_user.active_status=false;
qx::dao::insert(inactivated_user);
qx::dao::insert(user);
}
return hasBeenSent;
}
bool Account_Handler::sendVerificationMessage(const QString &email,
                                              const QString &verification_number)
{
SmtpClient smtp("smtp.gmail.com", 465, SmtpClient::SslConnection);
smtp.setUser(cryptowallet_email);
smtp.setPassword(cryptowallet_password);
MimeMessage message;
message.setSender(new EmailAddress(cryptowallet_email, cryptowallet_name));
message.addRecipient(new EmailAddress(email));
message.setSubject("Thanks for your registration in NVR Cryptowallet");
MimeHtml welcome_page;
welcome_page.setHtml("<!DOCTYPE HTML>"
"<html>"
"<head>"
"<title>Thanks for registering!</title>"
"</head>"
"<body>"
"<p>Hi! Thanks for your registration in NVR Cryptowallet.</p>"
"<p>Please, confirm your email in NVR Cryptowallet. You should enter this verification "
" number in NVR Cryptowallet: "+verification_number+ ". You will be able "
"to continue using NVR Cryptowallet <strong>only after verification</strong>.</p>"
"<p>Verification number will be available <strong>within 24 hours</strong>.</p>"
"<p>If you did not register in this one, you should ignore this letter.</p>"
"<p><em>Regards</em>,</p>"
"<p><em>Alex Braun</em>.</p>"
"</body>"
"</html>");
message.addPart(&welcome_page);
bool hasBeenSent=smtp.connectToHost()&&smtp.login()&&smtp.sendMail(message);
smtp.quit();
return hasBeenSent;
}
bool Account_Handler::sendRecoveringMessage(const QString &email,
                                            const QString &verification_number)
{
SmtpClient smtp("smtp.gmail.com", 465, SmtpClient::SslConnection);
smtp.setUser(cryptowallet_email);
smtp.setPassword(cryptowallet_password);
MimeMessage message;
message.setSender(new EmailAddress(cryptowallet_email, cryptowallet_name));
message.addRecipient(new EmailAddress(email));
message.setSubject("Recovering access to account in NVR Cryptowallet");
MimeHtml recovering_page;
recovering_page.setHtml("<!DOCTYPE HTML>"
"<html>"
"<head>"
"<title>Recovering access</title>"
"<p>Hi! Someone sent request for recovering access to your account "
"from NVR Cryptowallet.</p>"
"<p>Your <strong>verification number</strong>: "+verification_number+". "
"You should enter this number in NVR Cryptowallet.</p>"
"<p>Afterwards, you get the new password for signing in.</p>"
"<p>Verification number will be available <strong>within 24 hours</strong>.</p>"
"<p>If you <strong>did not send</strong> such request, you should pay attention "
"to this letter. Probably, somebody wants to get access to your account.</p>"
"<p><em>Regards</em>,</p>"
"<p><em>Alex Braun</em>.</p>"
"</body>"
"</html>");
message.addPart(&recovering_page);
bool hasBeenSent=smtp.connectToHost()&&smtp.login()&&smtp.sendMail(message);
smtp.quit();
return hasBeenSent;
}
bool Account_Handler::sendNewPasswordMessage(const QString &email,
                                             const QString &new_password)
{
SmtpClient smtp("smtp.gmail.com", 465, SmtpClient::SslConnection);
smtp.setUser(cryptowallet_email);
smtp.setPassword(cryptowallet_password);
MimeMessage message;
message.setSender(new EmailAddress(cryptowallet_email, cryptowallet_name));
message.addRecipient(new EmailAddress(email));
message.setSubject("New password for your account in NVR Cryptowallet");
MimeHtml new_password_page;
new_password_page.setHtml("<!DOCTYPE HTML>"
"<html>"
"<head>"
"<title>New password</title>"
"<p>Your recovering request has been successfully verified.</p>"
"<p><strong>Your new password</strong>: "+new_password+". </p>"
"<p>Notice that you may always change your password in NVR Cryptowallet.</p>"
"<p><em>Regards</em>,</p>"
"<p><em>Alex Braun</em>.</p>"
"</body>"
"</html>");
message.addPart(&new_password_page);
bool hasBeenSent=smtp.connectToHost()&&smtp.login()&&smtp.sendMail(message);
smtp.quit();
return hasBeenSent;
}
bool Account_Handler::checkUserActivity(const QString &email)
{
Inactivated_User inactivated_user;
inactivated_user.email=email;
if (!qx::dao::exist(inactivated_user)) return true;
qx::dao::fetch_by_id(inactivated_user);
return inactivated_user.active_status;
}
bool Account_Handler::checkUserVerifyingStatus(const QString &email)
{
Inactivated_User inactivated_user;
inactivated_user.email=email;
return qx::dao::exist(inactivated_user);
}
bool Account_Handler::checkVerificationNumber(const QString &email,
                                              const QString &number)
{
Inactivated_User inactivated_user;
inactivated_user.email=email;
qx::dao::fetch_by_id(inactivated_user);
bool hasBeenVerificated=(email==QString(decrypt(inactivated_user.verification_number,
number, vector_phrase)));
if (hasBeenVerificated)
{
if (inactivated_user.active_status) recoverAccount(email);
qx::dao::destroy_by_id(inactivated_user);
}
return hasBeenVerificated;
}
QString Account_Handler::decryptWallet(const QString &wallet_address,
                                       const QString &wallet_password)
{
Cryptowallet cryptowallet;
cryptowallet.wallet_address=wallet_address;
qx::dao::fetch_by_id(cryptowallet);
return QString(decrypt(cryptowallet.private_key, wallet_password, vector_phrase));
}
bool Account_Handler::getUserVipStatus(const QString &email)
{
User user;
user.email=email;
qx::dao::fetch_by_id(user);
return user.vip_status;
}
void Account_Handler::assignUserVipStatus(const QString &email)
{
User user;
user.email=email;
qx::dao::fetch_by_id(user);
user.vip_status=true;
qx::dao::update(user);
}
void Account_Handler::addWallet(const QString &wallet_address,
                                 const QString &private_key,
                                 const QString &wallet_password,
                                 const QString &email)
{
Cryptowallet cryptowallet;
cryptowallet.wallet_address=wallet_address;
cryptowallet.private_key=encrypt(private_key, wallet_password, vector_phrase);
cryptowallet.email=email;
qx::dao::insert(cryptowallet);
}
bool Account_Handler::containsWallet(const QString &wallet_address,
                                     const QString &email)
{
Cryptowallet cryptowallet;
cryptowallet.wallet_address=wallet_address;
bool doesContain=qx::dao::exist(cryptowallet);
if (doesContain)
{
qx::dao::fetch_by_id(cryptowallet);
doesContain=(email==cryptowallet.email);
}
return doesContain;
}
void Account_Handler::deleteWallet(const QString &wallet_address,
                                   const QString &email)
{
Cryptowallet cryptowallet;
cryptowallet.wallet_address=wallet_address;
qx::dao::delete_by_id(cryptowallet);
}
void Account_Handler::connectToDatabase(const QString &driver,
                                        const QString &database,
                                        const QString &user,
                                        const QString &host,
                                        int port,
                                        const QString &password)
{
qx::QxSqlDatabase::getSingleton()->setDriverName(driver);
qx::QxSqlDatabase::getSingleton()->setDatabaseName(database);
qx::QxSqlDatabase::getSingleton()->setUserName(user);
qx::QxSqlDatabase::getSingleton()->setHostName(host);
qx::QxSqlDatabase::getSingleton()->setPort(port);
qx::QxSqlDatabase::getSingleton()->setPassword(password);
}
QByteArray Account_Handler::encrypt(const QString &text, const QString &passphrase,
                                    const QString &vector_phrase)
{
    return QAESEncryption::Crypt(QAESEncryption::AES_256, QAESEncryption::CBC,
    text.toLocal8Bit(), QCryptographicHash::hash(passphrase.toLocal8Bit(),
    QCryptographicHash::Sha256), QCryptographicHash::hash(
    vector_phrase.toLocal8Bit(), QCryptographicHash::Md5));
}
QByteArray Account_Handler::decrypt(const QByteArray &text, const QString &passphrase,
                                    const QString &vector_phrase)
{
    return QAESEncryption::RemovePadding(QAESEncryption::Decrypt(
    QAESEncryption::AES_256, QAESEncryption::CBC,
    text, QCryptographicHash::hash(passphrase.toLocal8Bit(),
    QCryptographicHash::Sha256), QCryptographicHash::hash(
    vector_phrase.toLocal8Bit(), QCryptographicHash::Md5)));
}
