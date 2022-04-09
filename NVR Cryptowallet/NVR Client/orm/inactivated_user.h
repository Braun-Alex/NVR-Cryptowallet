#pragma once
#include "resources.h"
class Inactivated_User
{
public:
Inactivated_User() {};
virtual ~Inactivated_User() {};
QString email;
QByteArray verification_number;
bool active_status;
QDateTime registering_moment=QDateTime::currentDateTimeUtc();
};
QX_REGISTER_PRIMARY_KEY(Inactivated_User, QString)
QX_REGISTER_HPP(Inactivated_User, qx::trait::no_base_class_defined, 1)
