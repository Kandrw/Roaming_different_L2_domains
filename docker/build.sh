




docker build -t virt_ap .

#docker run --privileged --device=/dev/wlan0 -it --rm virt_AP

#docker run --device=/dev/wlx90de807a7513 --rm -it  -v /home/andrey:/home/andrey -w /home/andrey/Документы/Diploma/Roaming_different_L2_domains virt_ap


docker run --network host --rm -it  -v /home/andrey:/home/andrey -w /home/andrey/Документы/Diploma/Roaming_different_L2_domains virt_ap


