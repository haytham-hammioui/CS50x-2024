#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool only_digits(string s)
{
    for (int i = 0; s[i] != '\0'; i++)
    {
        if (!isdigit(s[i]))
        {
            return false;
        }
    }
    return true;
}

int main(int argc, string argv[])
{
    if (argc != 2 || (!only_digits(argv[1])))
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }

    string plaintext = get_string("plaintext: ");

    int key = atoi(argv[1]);
    char co;
    int nm = strlen(plaintext);
    char cipher[nm + 1];
    for (int j = 0; j < nm; j++)
    {
        if (isalpha(plaintext[j]))
        {
            if (islower(plaintext[j]))
            {
                co = 'a' + (plaintext[j] - 'a' + key) % 26;
            }
            else if (isupper(plaintext[j]))
            {
                co = 'A' + (plaintext[j] - 'A' + key) % 26;
            }
        }
        else
        {
            co = plaintext[j];
        }
        cipher[j] = co;
    }
    cipher[nm] = '\0';
    printf("ciphertext: %s\n", cipher);
    return 0;
}
