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
#define PROTO_NUM 0x890D   // ваш Ethertype в «EtherType» поле
#define SIZEBUF   200
#define SIZE_HEADER 8
#define ETH_ALEN 6
struct custom_header {
    uint16_t length;  // длина данных
    uint16_t type;    // тип
};

int main(int argc, char **argv)
{
    int fd;
    struct ifreq ifr = {0};
    struct sockaddr_ll sll = {0};
    unsigned char buffer[SIZEBUF + SIZE_HEADER];

    // 1) Создаём PF_PACKET сокет на уровне L2
    //fd = socket(PF_PACKET, SOCK_RAW, htons(PROTO_NUM));
    fd = socket(PF_PACKET, SOCK_DGRAM, htons(PROTO_NUM));
    if (fd < 0) {
        perror("socket(PF_PACKET)");
        return 1;
    }

    // 2) Определяем индекс интерфейса, по которому шлём
    //    Замените "wlp0s20f3" на ваш реальный интерфейс
    strncpy(ifr.ifr_name, "br0", IFNAMSIZ-1);
    if (ioctl(fd, SIOCGIFINDEX, &ifr) < 0) {
        perror("SIOCGIFINDEX");
        close(fd);
        return 1;
    }
    sll.sll_family   = AF_PACKET;
    sll.sll_protocol = htons(PROTO_NUM);
    sll.sll_ifindex  = ifr.ifr_ifindex;
    sll.sll_halen    = ETH_ALEN;
    // MAC‐адрес назначения: замените на нужный
    unsigned char dst_mac[6] = {0x50,0x4f,0x3b,0xcc,0x9f,0xaa};
    memcpy(sll.sll_addr, dst_mac, 6);

    // 3) Основной цикл: читаем строку, формируем заголовок, шлём
    while (1) {
        char *data = (char *)buffer + SIZE_HEADER;
        printf("Input: ");
        if (!fgets(data, SIZEBUF, stdin))
            break;
        // Убираем '\n'
        data[strcspn(data, "\n")] = 0;
        if (strcmp(data, "exit") == 0)
            break;

        // Заполняем свой заголовок
        struct custom_header *hdr = (void*)buffer;
        hdr->length = htons(strlen(data));
        hdr->type   = htons(1);

        ssize_t len = SIZE_HEADER + strlen(data);
//         if (sendto(fd, buffer, len, 0,
//                    (struct sockaddr*)&sll, sizeof(sll)) < 0) {
//             perror("sendto");
//         }

        sendto(fd, buffer, SIZE_HEADER + strlen(data), 0,
       (struct sockaddr*)&sll, sizeof(sll));

    }

    close(fd);
    return 0;
}
