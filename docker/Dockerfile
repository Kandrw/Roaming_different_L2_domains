# Используем базовый образ Ubuntu
FROM ubuntu:22.04

# Установка необходимых пакетов
RUN apt-get update && \
    apt-get install -y dnsmasq iproute2 iputils-ping && \
    apt-get clean









# Копируем конфигурации hostapd и dnsmasq
#COPY hostapd.conf /etc/hostapd/hostapd.conf
#COPY dnsmasq.conf /etc/dnsmasq.conf

# Указываем, что hostapd будет использоваться как основной процесс
#CMD ["sh", "-c", "hostapd /etc/hostapd/hostapd.conf & dnsmasq -C /etc/dnsmasq.conf"]
