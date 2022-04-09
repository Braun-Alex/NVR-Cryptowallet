#include "cryptowallet.h"
QX_REGISTER_CPP(Cryptowallet)
namespace qx
{
template <> void register_class(QxClass<Cryptowallet> &cryptowallet)
{
  cryptowallet.setName("cryptowallets");
  cryptowallet.id(&Cryptowallet::wallet_address, "wallet_address");
  cryptowallet.data(&Cryptowallet::private_key, "private_key");
  cryptowallet.data(&Cryptowallet::email, "email");
}
}
