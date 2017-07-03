#!/usr/sbin/nft -f
# =============================================================================================================#
#                                       Default Firewall with NFTables					       
# Version.: 1.0			 									      
# Modified.: 26/08/2016									       	       
# Modified by.: PH
# Contact.: Phillipe Farias | phillipe@phconsultoria.com.br
#
#
#
#
# Check List NIST - NIST Special Pub Recomendations for Firewall Policy Setup
#
# 1 - Default Firewall Policy
# 2 - Loopback & Pseudo Interfaces Default Policy
# 3 - Anomaly IP
# 4 - Anomaly by Protocol
# 5 - Transformations
# 6 - Policy by Protocol
# 7 - Policy by Service
# 8 - Policy by Host
# 9 - Policy by Network
# 10 - IP Flow
#
#=============================================================================================================#

nft="sudo $(which nft)"

stop() {

        # Flush all rules
        	$nft flush ruleset
  
	#Remove Firewall PID
		sudo rm -rf  /var/run/firewall.pid
}

start() {

		#Ativacao dos Modulos 
			sudo $(which modprobe) nf_conntrack
			sudo $(which modprobe) nf_conntrack_ipv4
			sudo $(which modprobe) nf_tables
			sudo $(which modprobe) nf_tables_ipv4
			sudo $(which modprobe) nf_nat
			sudo $(which modprobe) nft_nat
			sudo $(which modprobe) nft_chain_nat_ipv4
			sudo $(which modprobe) nfnetlink
			sudo $(which modprobe) nf_defrag_ipv4
			
		 #Variables
			lan_if="enp0s8"
			wlan_if="enp0s3" 
			ip1="10.0.2.15"
			ip2="10.0.8.81"
			network="10.0.8.0/24"

		#Firewall PID
			sudo echo $RANDOM > /var/run/firewall.pid

#=======================================================================================================================#			
#============================================== 1. Default Firewall Policy ============================================#
#=======================================================================================================================#

	#Default Firewall Policy
	
	# Set your default policy of filter table ipv4 and ipv6 (chains input, output and forward)
	    
	    $nft add table filter
	    $nft add chain filter input \{ type filter hook input priority 0 \; policy drop \; \}
	    $nft add chain filter output \{ type filter hook output priority 0 \; policy drop \; \}
	    $nft add chain filter forward \{ type filter hook forward priority 0 \; policy drop \; \}
	
        # Set default policy of nat table ipv4
	    
	    $nft add table nat
	    $nft add chain nat post \{ type nat hook postrouting priority 0 \; policy accept \; \}
	    $nft add chain nat pre \{ type nat hook prerouting priority 0 \; policy accept \; \}

#=======================================================================================================================#			
#======================================= 2. Loopback & Pseudo Interfaces Default Policy ================================#
#=======================================================================================================================#

	 #Default Policy on Loopback Interfaces
		$nft add rule filter input ip saddr 127.0.0.1 ip daddr 127.0.0.1 ct state new,established,related iif lo counter accept
		$nft add rule filter output ip saddr 127.0.0.1 ip daddr 127.0.0.1 ct state new,established,related iif lo counter accept
		$nft add rule filter input ip daddr 127.0.0.1 ct state new,established,related iif != lo drop
			  
#=======================================================================================================================#			
#==================================================== 3. Anomaly IP ====================================================#
#=======================================================================================================================#

#Set your rules of anomaly by IP (input and outpu) here!

	 #Anomaly IP
		$nft add rule filter input ct state invalid log prefix \"[BLOCK]: invalid packet\" drop
					  
#=======================================================================================================================#			
#================================================ 4. Anomaly by Protocol ===============================================#
#=======================================================================================================================#

#Set your rules of anomaly by protocol (input and outpu) here!

#=======================#
#======== DoS ==========#
#=======================#

	#FLow of connections (SSH)
		$nft add rule filter input ip daddr $ip1 ct state new,established,related limit rate 10/minute tcp dport 22 counter accept

#=======================#
#======== Others =======#
#=======================#

	#Portscanners,ping
		$nft add rule filter input ct state new,established,related icmp type echo-request limit rate 10/second counter accept
		$nft add rule filter input ct state established,related icmp type echo-reply limit rate 10/second counter accept
				
#=======================================================================================================================#			
#=================================================== 5. Transformations ================================================#
#=======================================================================================================================#

#Set your rules of transformations here!

#=======================================================================================================================#			
#================================================ 6. Policy by Protocol ================================================#
#=======================================================================================================================#

#Set your rules of policy by protocol here!

#=======================#
#======== INPUT ========#
#=======================#

	#SSH
		$nft add rule filter input ip daddr $ip1 iif $wlan_if tcp dport 22 ct state new,established,related log log prefix \"[FIREWALL]: SSH Access by WAN \" counter accept
		$nft add rule filter input ip daddr $ip1 iif $wlan_if tcp sport 22 ct state established,related counter accept
		$nft add rule filter input ip daddr $ip2 iif $lan_if tcp dport 22 ct state new,established,related log log prefix \"[FIREWALL]: SSH Access by LAN\" counter accept
		$nft add rule filter input ip daddr $ip2 iif $lan_if tcp sport 22 ct state established,related counter accept

	#HTTP/HTTPS
		$nft add rule filter input ip daddr $ip1 iif $wlan_if tcp sport { 80,443 } ct state established,related counter accept
		$nft add rule filter input ip daddr $ip2 iif $lan_if tcp sport { 80,443 } ct state established,related counter accept

	#Squid
		$nft add rule filter input ip saddr $network ip daddr $ip2 iif $lan_if tcp dport { 3128 } ct state new,established,related counter accept

	#DNS
		$nft add rule filter input ip daddr $ip1 iif $wlan_if udp sport 53 counter accept

	#NTP
		$nft add rule filter input ip daddr $ip1 iif $wlan_if udp dport 123 counter accept

	#ICMP (Ping)
		$nft add filter input ip saddr $ip2 iif $lan_if icmp type echo-request ct state new,established,related counter accept
		$nft add filter input ip saddr $ip2 iif $lan_if icmp type echo-reply ct state established,related counter accept

#=======================#
#======== OUTPUT =======#
#=======================#

	#SSH
		$nft add rule filter output ip saddr $ip1 oif $wlan_if tcp dport 22 ct state new,established,related counter accept
		$nft add rule filter output ip saddr $ip1 oif $wlan_if tcp sport 22 ct state established,related counter accept
		$nft add rule filter output ip saddr $ip2 oif $lan_if tcp dport 22 ct state new,established,related log log prefix \"[FIREWALL]: SSH Access by LAN\" counter accept
		$nft add rule filter output ip saddr $ip2 oif $lan_if tcp sport 22 ct state established,related counter accept

	#HTTP/HTTPS
		$nft add rule filter output ip saddr $ip1 oif $wlan_if tcp dport { 80,443 } ct state new,established,related counter accept
		$nft add rule filter output ip saddr $ip2 oif $lan_if tcp dport { 80,443 } ct state new,established,related counter accept
	
	#Squid
		$nft add rule filter output ip saddr $ip2 ip daddr $network oif $lan_if tcp sport { 3128 } ct state established,related counter accept
		
	#DNS
		$nft add rule filter output ip saddr $ip1 oif $wlan_if udp dport 53 counter accept

	#NTP
		$nft add rule filter output ip saddr $ip1 oif $wlan_if udp dport 123 counter accept

	#ICMP (Ping)
		$nft add filter output ip saddr $ip1 oif $wlan_if icmp type echo-request ct state new,established,related counter accept
		$nft add filter output ip saddr $ip1 oif $wlan_if icmp type echo-reply ct state established,related counter accept
		$nft add filter output ip saddr $ip2 oif $lan_if icmp type echo-request ct state new,established,related counter accept
		$nft add filter output ip saddr $ip2 oif $lan_if icmp type echo-reply ct state established,related counter accept

#=======================#
#======== FORWARD ======#
#=======================#

	#DNS
		$nft add rule filter forward iif $lan_if oif $wlan_if udp dport 53 counter accept
		$nft add rule filter forward iif $wlan_if oif $lan_if udp sport 53 counter accept
		
	#NTP
		$nft add rule filter forward iif $wlan_if oif $lan_if udp dport 123 counter accept
		$nft add rule filter forward iif $lan_if oif $wlan_if udp sport 123 counter accept

	#SMTP/POP/IMAP
		$nft add rule filter forward iif $lan_if oif $wlan_if ct state new,related,established tcp dport { 25,465,587,110,993,143,995 } counter accept
		$nft add rule filter forward iif $wlan_if oif $lan_if ct state related,established tcp sport { 25,465,587,110,993,143,995 } counter accept
	
	#ICMP
		$nft add filter forward meta iifname $lan_if oifname $wlan_if icmp type echo-request ct state new,established,related counter accept
		$nft add filter forward meta iifname $wlan_if oifname $lan_if icmp type echo-request ct state new,established,related counter accept
		$nft add filter forward meta iifname $lan_if oifname $wlan_if icmp type echo-reply ct state established,related counter accept
		$nft add filter forward meta iifname $wlan_if oifname $lan_if icmp type echo-reply ct state established,related counter accept
			
#=======================================================================================================================#			
#================================================ 7. Policy by Service =================================================#
#=======================================================================================================================#

#Set your rules of policy by services here!

#=======================#
#===== PREROUTING ======#
#=======================#

	#Examples of rules from port redirect.:

		#$nft add rule nat pre ip daddr $ip1 iif $wlan_if tcp dport 2222 ip protocol tcp counter dnat 10.10.10.2:22

#=======================================================================================================================#			
#================================================= 8. Policy by host ===================================================#
#=======================================================================================================================#

#======================#
#=== Host Sem Proxy ===#
#======================#

OLD="$IFS"
IFS=$'\n'

for hosts in $(cat /etc/scripts/firewall/acls/sem_proxy/hosts.lst)
	do 

		IFS="|"
		arr=($hosts)

		sudo /usr/sbin/nft add rule filter forward ip saddr ${arr[0]}  iif $lan_if oif $wlan_if ct state new,related,established tcp dport { 80,443 } log log prefix \"[Sem Proxy]: Computador ${arr[1]} \" counter accept
		sudo /usr/sbin/nft add rule filter forward ip daddr ${arr[0]} iif $wlan_if oif $lan_if ct state related,established tcp sport { 80,443 } log log prefix \"[Sem Proxy]: Computador ${arr[1]} \" counter accept

	done

#=======================================================================================================================#			
#================================================ 9. Policy by Network =================================================#
#=======================================================================================================================#

#Set your rules of policy by network here!

#=======================#
#===== POSTROUTING =====#
#=======================#

	#Masquerade
		sudo /usr/sbin/nft  add rule nat post ip saddr $network oif $wlan_if counter masquerade

#=======================================================================================================================#			
#=================================================== 10. IP Flow ========================================================#
#=======================================================================================================================#

#Set your rules of IP flow here!

	#Enable IP Forward:
		echo 1 > /proc/sys/net/ipv4/ip_forward

	#Enable Drop IP Spoofing
		echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter
	
	#Dynaddr
		echo 1 > /proc/sys/net/ipv4/ip_dynaddr

	#Enable TCP SYN Cookie Protection
		echo 1 >/proc/sys/net/ipv4/tcp_syncookies

	#Enable broadcast echo protection
		echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

	#Enable ICMP Request
		echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all

	#Enable IP spoofing protection, turn on Source Address Verification
		for f in /proc/sys/net/ipv4/conf/*/rp_filter; do
		    echo 1 > $f
		done


}	 

#=======================================================================================================================#
#=================================================== Esquema de utilizacao =============================================#
#=======================================================================================================================#

if [ "$1" == "stop" ]; then
        echo "Stoping Firewall..."
        stop
        echo "Stoped!"
elif [ "$1" == "restart" ]; then
        echo "Restarting Firewall..."
        stop
        start
        echo "Firewall Restarted!"
elif [ "$1" == "start" ]; then
        echo "Starting Firewall..."
        start
        echo "Firewall Started!"
elif [ "$1" == "status" ]; then
        $nft list ruleset --handle --numeric
else
        echo "Usage: $0 {start|stop|restart|status}"
        exit
fi
