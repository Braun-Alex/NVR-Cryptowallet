#include "user.h"
QX_REGISTER_CPP(User)
namespace qx
{
template <> void register_class(QxClass<User> &user)
{
  user.setName("users");
  user.id(&User::email, "email");
  user.data(&User::password, "password");
  user.data(&User::vip_status, "vip_status");
}
}
