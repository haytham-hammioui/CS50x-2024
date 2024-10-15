#include <cs50.h>
#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    string text = get_string("Text: ");
    float l = 0;
    float w = 1;
    float s = 0;
    int n = strlen(text);
    for (int i = 0; i < n; i++)
    {
        if ((text[i] >= 65 && text[i] <= 90) || (text[i] >= 97 && text[i] <= 122))
        {
            l++;
        }

        if (text[i] == 32)
        {
            w++;
        }

        if (text[i] == 46 || text[i] == 63 || text[i] == 33)
        {
            s++;
        }
    }

    float L = (l / w) * 100;
    float S = (s / w) * 100;

    int grade = round(0.0588 * L - 0.296 * S - 15.8);

    if (grade >= 16)
    {
        printf("Grade 16+\n");
    }
    else if (grade < 1)
    {
        printf("Before Grade 1\n");
    }
    else
    {
        printf("Grade %i\n", grade);
    }
}
