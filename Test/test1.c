#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#define PROTO_NUM 0x890D  // Номер вашего протокола
#define SIZEBUF 200
#define SIZE_HEADER 8  // Размер заголовка вашего протокола

// Структура заголовка вашего протокола
struct custom_header {
    uint16_t length;  // Длина данных
    uint16_t type;    // Тип сообщения
};

void replace_enter(char *str) {
    int i = 0;
    while ('\0' != str[i]) {
        if (str[i] == '\n') {
            str[i] = '\0';
            break;
        }
        ++i;
    }
}

int main() {
    int fd;
    struct sockaddr_in dest_addr;
    char buffer[SIZEBUF + SIZE_HEADER];

    // Создаем сокет
    fd = socket(AF_INET, SOCK_RAW, PROTO_NUM);  // Используем пользовательский протокол
    if (fd < 0) {
        perror("socket");
        return -1;
    }

    // Настраиваем структуру sockaddr_in для назначения
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port = htons(0);  // Порт не важен для RAW сокетов
    dest_addr.sin_addr.s_addr = inet_addr("192.168.1.10");  // Замените на нужный IP-адрес назначения

    while (1) {
        printf("Input: ");
        fgets(buffer + SIZE_HEADER, SIZEBUF, stdin);
        replace_enter(buffer + SIZE_HEADER);
        if (!strcmp(buffer + SIZE_HEADER, "exit")) {
            break;
        }

        // Заполняем заголовок вашего протокола
        struct custom_header *header = (struct custom_header *)buffer;
        header->length = htons(strlen(buffer + SIZE_HEADER));  // Длина данных
        header->type = htons(1);  // Например, тип 1

        // Отправляем данные
        if (sendto(fd, buffer, SIZE_HEADER + strlen(buffer + SIZE_HEADER), 0,
                   (struct sockaddr*)&dest_addr, sizeof(dest_addr)) < 0) {
            perror("sendto");
        }
    }

    close(fd);
    printf("End client\n");
    return 0;
}
