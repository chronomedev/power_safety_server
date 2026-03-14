#!/bin/bash

# pengecekan pertama agar awal-awal memang misalnya konek- itu konek

rm -f -- log_power.txt

(echo "====== UPS power safety script by Chronomedev for CDC (Chronome Data Center) ======" >> log_power.txt) &
ping -c 1 192.168.100.1 &> /dev/null

# bawah tethring hp chronome
ping -c 1 172.20.10.1 &> /dev/null
if [ $? -eq 2 ]; then
    echo "Default Gateaway tidak terdeteksi....untuk safety UPS..auto shutdown 60 detik"
    (echo "Default Gateaway tidak terdeteksi....untuk safety UPS..auto shutdown 60 detik" >> log_power.txt) &
    date "+%Y-%m-%d %H:%M:%S"
    (date "+%Y-%m-%d %H:%M:%S" >> log_power.txt) &
    sleep 6
    shutdown -h now
else
    echo "System OK.... proses dilakukan setiap 60 detik delay cek..."
    (echo "System OK.... proses dilakukan setiap 60 detik delay cek..." >> log_power.txt) &
    sleep 60
fi


checkPhase=0

while [ 1 ];
do
    ping -c 1 192.168.100.1 &> /dev/null
    if [ $? -eq 2 ]; then
        echo "Default Gateaway tidak terdeteksi....3 kali pengulangan untuk cek dalam 60 detik"
        (echo "Default Gateaway tidak terdeteksi....3 kali pengulangan untuk cek dalam 60 detik" >> log_power.txt) &
        date "+%Y-%m-%d %H:%M:%S"
        (date "+%Y-%m-%d %H:%M:%S" >> log_power.txt) &
        sleep 60
        ((checkPhase++))
        if [ $checkPhase -eq 4 ]; then
            echo "Melakukan shutdown...cek terminal log ketika startup"
            (echo "Melakukan shutdown...cek terminal log ketika startup..initialize" >> log_power.txt) &
            shutdown -h now
        else
            echo "Telah di cek $checkPhase kali....melakukan pengecekan kembali..."
            (echo "Telah di cek $checkPhase kali....melakukan pengecekan kembali..." >> log_power.txt) &
        fi
    else
        #reset checker untuk tetap hidup
        if [ $checkPhase -gt 0 ]; then
            echo "Koneksi atau Kelistrikan sudah normal....System OK....."
            (echo "Koneksi atau Kelistrikan sudah normal....System OK....." >> log_power.txt) &
        fi
        checkPhase=0 
        sleep 60
    fi
done