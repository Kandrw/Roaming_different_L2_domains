#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

#include <net/if.h>
#include <sys/socket.h>
#include <linux/if_packet.h>
#include <arpa/inet.h>
#include <sys/ioctl.h>





#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>           // close()
#include <arpa/inet.h>        // sockaddr_in, inet_addr
#include <sys/socket.h>
#include <netinet/in.h>

#if 0
int main() {
    int sockfd;
    struct sockaddr_in servaddr, cliaddr;
    char buffer[1024];
    socklen_t len;
    ssize_t n;

    // Создаем UDP сокет
    sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sockfd < 0) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Заполняем структуру адреса сервера
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;

    // Указываем IP-адрес для прослушивания (например, 192.168.1.100)
    // Можно использовать INADDR_ANY для прослушивания на всех интерфейсах
    servaddr.sin_addr.s_addr = inet_addr("192.168.1.20");

    // Порт для прослушивания
    servaddr.sin_port = htons(12345);

    // Привязываем сокет к адресу и порту
    if (bind(sockfd, (const struct sockaddr *)&servaddr, sizeof(servaddr)) < 0) {
        perror("bind failed");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Listening on %s:%d\n", "192.168.1.20", 12345);

    while (1) {
        len = sizeof(cliaddr);
        n = recvfrom(sockfd, buffer, sizeof(buffer) - 1, 0,
                     (struct sockaddr *)&cliaddr, &len);
        if (n < 0) {
            perror("recvfrom error");
            break;
        }
        buffer[n] = '\0'; // null-terminate received data

        printf("Received from %s:%d: %s\n",
               inet_ntoa(cliaddr.sin_addr),
               ntohs(cliaddr.sin_port),
               buffer);
    }

    close(sockfd);
    return 0;
}
#endif

#define SIZEBUF 200
#define SIZE_HEADER 8


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


    fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (fd < 0) {
        perror("socket");
        return -1;
    }


    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port = htons(4578);
    dest_addr.sin_addr.s_addr = inet_addr("192.168.1.10");

    while (1) {
        printf("Input: ");
        fgets(buffer + SIZE_HEADER, SIZEBUF, stdin);
        replace_enter(buffer + SIZE_HEADER);
        if (!strcmp(buffer + SIZE_HEADER, "exit")) {
            break;
        }


        if (sendto(fd, buffer, SIZE_HEADER + strlen(buffer + SIZE_HEADER), 0,
                   (struct sockaddr*)&dest_addr, sizeof(dest_addr)) < 0) {
            perror("sendto");
        }
        printf("send\n");
    }

    close(fd);
    printf("End client\n");
    return 0;
}
