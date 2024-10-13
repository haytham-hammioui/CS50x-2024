#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int owed;
    do
    {
        owed = get_int("Change owed:");
    }
    while (owed < 0);

    int o_quartes = owed / 25;
    owed = owed - (o_quartes * 25);
    int o_dimes = owed / 10;
    owed = owed - (o_dimes * 10);
    int o_nickles = owed / 5;
    owed = owed - (o_nickles * 5);
    int o_pennies = owed / 1;
    owed = owed - (o_pennies * 1);

    printf("%d\n", o_quartes + o_dimes + o_nickles + o_pennies);
}
