#!/bin/sh

HOST=encore.noise.gatech.edu
IP_DROP_PORT=8888
HTTP_DROP_PORT=8889
TCP_RESET_IP_PORT=8890
TCP_RESET_URL_PORT=8891

start() {
	sudo iptables -A INPUT -p tcp -d $HOST --dport $IP_DROP_PORT -j DROP
	sudo iptables -A INPUT -p tcp -d $HOST --dport $HTTP_DROP_PORT -m string --string 'GET /' --algo bm -j DROP
	sudo iptables -A INPUT -p tcp -d $HOST --dport $TCP_RESET_IP_PORT -j REJECT --reject-with tcp-reset
	sudo iptables -A INPUT -p tcp -d $HOST --dport $TCP_RESET_URL_PORT -m string --string 'GET /' --algo bm -j REJECT --reject-with tcp-reset
}

stop() {
	sudo iptables -D INPUT -p tcp -d $HOST --dport $IP_DROP_PORT -j DROP
	sudo iptables -D INPUT -p tcp -d $HOST --dport $HTTP_DROP_PORT -m string --string 'GET /' --algo bm -j DROP
	sudo iptables -D INPUT -p tcp -d $HOST --dport $TCP_RESET_IP_PORT -j REJECT --reject-with tcp-reset
	sudo iptables -D INPUT -p tcp -d $HOST --dport $TCP_RESET_URL_PORT -m string --string 'GET /' --algo bm -j REJECT --reject-with tcp-reset
}

case $1 in
start)
	start
	;;
stop)
	stop
	;;
esac
