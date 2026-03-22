# RECON - System Information & Network Scanner

A bash script for collecting system information and performing interactive NMAP scans on Linux environments.

## Features

- System info: OS version, current user, users with shells
- Network info: IP addresses, public IP, open ports, ARP/routing tables, DNS config
- NMAP scans: TCP, UDP, SYN, OS fingerprinting, version detection, etc

## Requirements

- Linux with bash
- NMAP installed (sudo apt install nmap)
- Root privileges (for some scans)

## Quick Start

bash

chmod +x recon.sh
./recon.sh [target]
