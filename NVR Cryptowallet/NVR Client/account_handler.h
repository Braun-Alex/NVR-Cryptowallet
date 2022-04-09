#pragma once
#include "cryptography/qaesencryption.h"
#include "orm/inactivated_user.h"
#include "orm/user.h"
#include "orm/cryptowallet.h"
class Account_Handler: public QObject
{
Q_OBJECT
public:
explicit Account_Handler(QObject* parent=nullptr);
Q_INVOKABLE bool checkEmailCorrectness(const QString &email);   
Q_INVOKABLE bool checkUserExisting(const QString &email);
Q_INVOKABLE bool checkWalletExisting(const QString &wallet_address,
                                     const QString &email);
Q_INVOKABLE bool signIn(const QString &email,
                        const QString &password);
Q_INVOKABLE void changePassword(const QString &email,
                                const QString &new_password);
Q_INVOKABLE bool recoverAccount(const QString &email);
Q_INVOKABLE bool verifyRecoveringRequest(const QString &email);
Q_INVOKABLE bool signUp(const QString &email,
                        const QString &password);
Q_INVOKABLE bool sendVerificationMessage(const QString &email,
                                         const QString &verification_number);
Q_INVOKABLE bool sendRecoveringMessage(const QString &email,
                                       const QString &verification_number);
Q_INVOKABLE bool sendNewPasswordMessage(const QString &email,
                                        const QString &new_password);
Q_INVOKABLE bool checkUserActivity(const QString &email);
Q_INVOKABLE bool checkUserVerifyingStatus(const QString &email);
Q_INVOKABLE bool checkVerificationNumber(const QString &email,
                                         const QString &number);
Q_INVOKABLE QString decryptWallet(const QString &wallet_address,
                                  const QString &wallet_password);
Q_INVOKABLE void addWallet(const QString &wallet_address,
                            const QString &private_key,
                            const QString &wallet_password,
                            const QString &email);
Q_INVOKABLE bool containsWallet(const QString &wallet_address,
                                const QString &email);
Q_INVOKABLE void deleteWallet(const QString &wallet_address,
                              const QString &email);
Q_INVOKABLE bool getUserVipStatus(const QString &email);
Q_INVOKABLE void assignUserVipStatus(const QString &email);
Q_INVOKABLE void connectToDatabase(const QString &driver,
                                   const QString &database,
                                   const QString &user,
                                   const QString &host,
                                   int port,
                                   const QString &password);
inline static QByteArray encrypt(const QString &text, const QString &passphrase,
                                 const QString &vector_phrase);
inline static QByteArray decrypt(const QByteArray &text, const QString &passphrase,
                                 const QString &vector_phrase);
private:
const size_t new_password_size=33, verification_number_size=99, seconds_in_day=86400;
const QString cryptowallet_email="nvr.cryptowallet@gmail.com",
cryptowallet_name="NVR Cryptowallet",
cryptowallet_password="AlThanks123",
vector_phrase="Cryptowallet";
QRegularExpression email_validator;
};
