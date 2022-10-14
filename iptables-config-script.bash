#!/bin/sh

# Empty all rules
sudo iptables -t filter -F
sudo iptables -t filter -X

# Bloc everything by default
sudo iptables -t filter -P INPUT DROP
sudo iptables -t filter -P FORWARD DROP
sudo iptables -t filter -P OUTPUT DROP

# Authorize already established connexions
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -t filter -A INPUT -i lo -j ACCEPT
sudo iptables -t filter -A OUTPUT -o lo -j ACCEPT

# SSH
sudo iptables -t filter -A INPUT -p tcp --dport 22138 -j ACCEPT
sudo iptables -t filter -A OUTPUT -p tcp --dport 22138 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT

# DNS
sudo iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
sudo iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
sudo iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT

# HTTP
sudo iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT

#HTTPS
sudo iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT

# FTP
sudo iptables -t filter -A OUTPUT -p tcp --dport 20:21 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 20:21 -j ACCEPT

# Mail SMTP
sudo iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
sudo iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT

# Mail IMAP
sudo iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
sudo iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT

sudo iptables -A FORWARD -i ens18 -o ens19 -p tcp --syn --dport 80 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A FORWARD -i ens18 -o ens19 -p tcp --syn --dport 25 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A FORWARD -i ens18 -o ens19 -p tcp --syn --dport 143 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -t nat -A PREROUTING -i ens18 -p tcp - -dport 80 -j DNAT - -to-destination 192.168.5.10
sudo iptables -t nat -A PREROUTING -i ens18 -p tcp - -dport 25 -j DNAT - -to-destination 192.168.5.30
sudo iptables -t nat -A PREROUTING -i ens18 -p tcp - -dport 143 -j DNAT - -to-destination 192.168.5.30


