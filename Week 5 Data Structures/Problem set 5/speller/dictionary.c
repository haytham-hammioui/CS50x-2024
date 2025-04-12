// Implements a dictionary's functionality

#include <ctype.h>
#include <stdbool.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
} node;

// TODO: Choose number of buckets in hash table
const unsigned int N = 26;

// TODO: Number of words in dictionary
int num = 0;

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // TODO
    int index = hash(word);
    node *tmp = table[index];
    while (tmp)
    {
        if (!(strcasecmp(tmp->word, word)))
            return true;
        tmp = tmp->next;
    }
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO: Improve this hash function
    return toupper(word[0]) - 'A';
}

void init(const char *dictionary)
{
    int i = 0;
    while (i < N)
    {
        table[i] = NULL;
        i++;
    }
}
// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    // TODO
    init(dictionary);
    FILE *file;
    if (!(file = fopen(dictionary, "r")))
        return false;
    char word[LENGTH + 1];
    while (fscanf(file, "%s", word) != EOF)
    {
        node *lklma = malloc(sizeof(node));
        if (!lklma)
            return false;
        int index = hash(word);
        strcpy(lklma->word, word);
        lklma->next = table[index];
        table[index] = lklma;
        num++;
    }
    fclose(file);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    // TODO
    return num;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    // TODO
    int i = 0;
    while (i < N)
    {
        node *tmp = table[i];
        node *cur = table[i];
        while (cur)
        {
            cur = cur->next;
            free(tmp);
            tmp = cur;
        }
        i++;
    }
    return true;
}
