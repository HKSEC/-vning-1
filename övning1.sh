#!/bin/bash
#
# Detta script samlar in systeminformation - RECON
#
# Kan användas för följande attacker:
# [Skriv möjliga attacker]
#
# Author: Frans Schartau
# Last Update: 2025-01-01

echo "Välkommen till mitt RECON script för att kontrollera en Linux-miljö"

echo
echo "=== SYSTEMINFO ==="
uname -a

echo
echo "=== AKTUELL ANVÄNDARE ==="
echo $USER

echo
echo "=== ANVÄNDARE MED SHELL ==="
grep "sh$" /etc/passwd

echo
echo "=== NÄTVERK ==="
ip a | grep inet

echo
echo "=== LÄGG TILL FLERA TESTER  ==="
#
# skriv in dina kommandon för tester
#

echo
echo "===ÖPPNA PORTAR ==="
ss -tuln

echo 
echo "=== PUBLIK IP ==="

curl -s https://ipapi.co/json

echo
echo " ARP TABELL"
ip neigh

echo
echo "ROUTING TABEL" #Hur trafiken rör sig
ip route

echo "DNS CONFIG"
cat /etc/resolv.conf
grep "nameserver" /etc/resolv.conf

nmap 127.0.0.1
nmap localhost

#Skanna alla portar på min egna dator
nmap -p- 127.0.0.1

# DEEP SCAN >>>>>>>

echo "DEEP SCAN>>>>>>>"
nmap -sS -sV -sC -O 127.0.0.1

TARGET="$1"

if [[ -z "$TARGET" ]]; then
    echo "Ange måltavla att scanna:"
    read TARGET
fi

echo "MÅL: $TARGET"
echo ""

scans=(
    "TCP connect scan (-sT)"
    "Service version detection (-sV)"
    "OS fingerprinting (-O)"
    "Stealth SYN scan (-sS)"
    "Aggressive comprehensive scan (-A)"
    "UDP port scan (-sU)"
    "NULL scan (-sN)"
    "FIN scan (-sF)"
    "Xmas scan (-sX)"
)

commands=(
    "nmap -sT $TARGET"
    "nmap -sV $TARGET"
    "nmap -O $TARGET"
    "nmap -sS $TARGET"
    "nmap -A $TARGET"
    "nmap -sU $TARGET"
    "nmap -sN $TARGET"
    "nmap -sF $TARGET"
    "nmap -sX $TARGET"
)

selected_commands=()

for i in "${!scans[@]}"; do
    read -p "Vill du köra '${scans[$i]}'? (j/n/s - spara): " choice
    case $choice in
        [jJ]*)
            echo "Kör: ${commands[$i]}"
            eval "${commands[$i]}"
            echo ""
            ;;
        [sS]*)
            selected_commands+=("${commands[$i]}")
            echo "Sparad för senare körning."
            ;;
        *)
            echo "Hoppar över."
            ;;
    esac
done

if [[ ${#selected_commands[@]} -gt 0 ]]; then
    echo ""
    echo "KOMMANDON SPARADE FÖR SENARE >>>>>"
    for cmd in "${selected_commands[@]}"; do
        echo "$cmd"
    done

    read -p "Vill du skapa ett script med dessa kommandon? (j/n): " create_script
    if [[ "$create_script" =~ ^[JjYy] ]]; then
        SCRIPT_NAME="saved_scans_$(date +%Y%m%d).sh"
        echo "#!/bin/bash" > "$SCRIPT_NAME"
        echo "# Auto-generated NMAP scan script" >> "$SCRIPT_NAME"
        echo "# Created: $(date)" >> "$SCRIPT_NAME"
        echo "" >> "$SCRIPT_NAME"
        for cmd in "${selected_commands[@]}"; do
            echo "$cmd" >> "$SCRIPT_NAME"
        done
        chmod +x "$SCRIPT_NAME"
        echo "Script skapat: $SCRIPT_NAME"
    fi
fi

