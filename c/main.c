#include <stdio.h>
#include <stdlib.h>
#include "util/map.h"

static char *rand_string(char *str, size_t size)
{
    const char charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJK...";
    if (size) {
        --size;
        for (size_t n = 0; n < size; n++) {
            int key = rand() % (int) (sizeof charset - 1);
            str[n] = charset[key];
        }
        str[size] = '\0';
    }
    return str;
}

int main()
{
    
    map *m = map_init(U32);
    u32 a = 'a';
    for (int i = 0; i < 22; i++) {
        char *test = malloc(sizeof(char) * 10);
        map_insert(m, node_init(rand_string(test, 10), (void *)&a));
    }

    printf("capacity: %d\nsize: %d\n", m->capacity, m->size);

    // traverse the map
    /*for (u32 i = 0; i < m->size; i++) {
        // the bucket is empty
        if (bucket_at(m, i) == NULL) {
            continue;
        }
        printf("Bucket %d:\n", i);
        // traverse the bucket, free every node
        for (u32 j = 0; j < bucket_at(m, i)->end; j++) {
            printf("\t");
            node_print(node_at(m, i, j));
        }
    }*/

    node *n;
    map_for_each(m, n) {
        node_print(n);
    }
    
    return 0;
}