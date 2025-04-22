from cs50 import get_float

while (True):
    owed = get_float("Change: ")
    if owed >= 0:
        break
owed_c = round(owed * 100)

# o_quartes = owed_c // 25
# owed_c = owed_c - (o_quartes * 25)
# o_dimes = owed_c // 10
# owed_c = owed_c - (o_dimes * 10)
# o_nickles = owed_c // 5
# owed_c = owed_c - (o_nickles * 5)
# o_pennies = owed_c // 1
# owed_c = owed_c - (o_pennies * 1)
#
# print(o_quartes + o_dimes + o_nickles + o_pennies)

coins = 0
for coin in [25, 10, 5, 1]:
    coins += owed_c // coin
    owed_c %= coin

print(coins)
