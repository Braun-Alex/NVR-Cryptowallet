#include "inactivated_user.h"
QX_REGISTER_CPP(Inactivated_User)
namespace qx
{
template <> void register_class(QxClass<Inactivated_User> &inactivated_user)
{
  inactivated_user.setName("inactivated_users");
  inactivated_user.id(&Inactivated_User::email, "email");
  inactivated_user.data(&Inactivated_User::verification_number, "verification_number");
  inactivated_user.data(&Inactivated_User::active_status, "active_status");
  inactivated_user.data(&Inactivated_User::registering_moment, "registering_moment");
}
}
