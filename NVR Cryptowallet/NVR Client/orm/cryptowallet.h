#pragma once
#include "resources.h"
class Cryptowallet
{
public:
Cryptowallet() {};
virtual ~Cryptowallet() {};
QString wallet_address=QString(42, Qt::Initialization::Uninitialized);
QByteArray private_key;
QString email;
};
QX_REGISTER_PRIMARY_KEY(Cryptowallet, QString)
QX_REGISTER_HPP(Cryptowallet, qx::trait::no_base_class_defined, 1)
