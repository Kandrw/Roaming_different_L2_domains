 
#include "stdio.h"
#include "stdlib.h"

#include "different_l2_domains.h"

#define DEBUG_FILE_CON "/home/andrey/debug_hostapd.txt"

struct debug_con {
    int con1, con2, con3, con4, con5, con6;
};

struct debug_con my_con = {0, 0, 0, 0, 0, 0};

int read_debug_con() {
    FILE *file = fopen(DEBUG_FILE_CON, "r");
    if(file) {
        fscanf(file, "%d %d %d %d %d %d",
            &my_con.con1, &my_con.con2, &my_con.con3,
            &my_con.con4, &my_con.con5, &my_con.con6);

        fclose(file);
    }
    return 0;
}

 







