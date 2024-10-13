#include <cs50.h>
#include <stdio.h>

int main(void)
{

    int height;
    do
    {
        height = get_int("height: ");
    }
    while (height < 1 || height > 8);

    for (int row = 0; row < height; row++)
    {
        for (int dots = 0; dots < (height - row - 1); dots++)
        {
            printf(" ");
        }
        for (int left_hash = 0; left_hash < (row + 1); left_hash++)
        {
            printf("#");
        }
        printf("  ");
        for (int right_hash = 0; right_hash < (row + 1); right_hash++)
        {
            printf("#");
        }
        printf("\n");
    }
}
