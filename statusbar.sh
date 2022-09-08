#!/usr/bin/env bash

init_temp_files () {
	touch /tmp/CurTime.tmp
	touch /tmp/CurCPUMain.tmp
	touch /tmp/ip.tmp
	echo 0.0% > /tmp/CurCPUMain.tmp
	touch /tmp/ITraffic.tmp
	echo "0 0" > /tmp/ITraffic.tmp
}

date_service () {
	while true; do
		date '+  %a %d %b   %R ' > /tmp/CurTime.tmp
    	sleep 60s
	done &
}

cpu_service () {
	while true; do
		local tempcpu=$(printf "%b" "import psutil\nprint('{}%'.format(psutil.cpu_percent(interval=2)))" | python3)
		echo $tempcpu > /tmp/CurCPUMain.tmp
	done &
}

connection_service () {
	while true; do
		local tempip=$(echo $(curl -m 1 ifconfig.me))
		echo $tempip > /tmp/ip.tmp
		
		re='^[0-9]+$'
		if ! [[ "${tempip: 0:1}" =~ $re ]] ; then
			sleep 60
		else
			sleep 12h
		fi
	done &
	
}

blink () {
	local indexer=$1
	if [ $indexer -eq 1 ]; then
		indexer=0
	else
		indexer=1
	fi
	return $indexer
}

get_connection_stat () {
	IP=$(echo $(< /tmp/ip.tmp))
	local net_stat=($(cat /proc/net/dev | tail -n 1))
	local traffic=($(echo $(< /tmp/ITraffic.tmp)))
	TOTAL_RECEIVED=${net_stat[1]}
	TOTAL_TRANSMITTED=${net_stat[9]}
	RECEIVED=$(($TOTAL_RECEIVED-${traffic[0]}))
	TRANSMITTED=$(($TOTAL_TRANSMITTED-${traffic[1]}))
	echo "$TOTAL_RECEIVED $TOTAL_TRANSMITTED" > /tmp/ITraffic.tmp
}

get_date_stat () {
	LOCALTIME=$(echo $(< /tmp/CurTime.tmp))
}

get_charge_stat () {
	local CHARGE_STATUS_ALL=($(acpi -i -b | head -n 1))
	CHARGE_STATUS=${CHARGE_STATUS_ALL[2]}
	CHARGE_STATUS="${CHARGE_STATUS: 0:1}"
	CHARGE_AMOUNT=${CHARGE_STATUS_ALL[3]}
	CHARGE_AMOUNT="${CHARGE_AMOUNT: 0:-2}"
	CHARGE_REMAINING=${CHARGE_STATUS_ALL[4]}
}

get_cpu_stat () {
	CPU_USAGE=$(echo $(< /tmp/CurCPUMain.tmp))
}

get_ram_stat() {
	local RAM_STATUS_ALL=($(free -m | head -n 2 | tail -n 1))
	RAM_TOTAL=${RAM_STATUS_ALL[1]}
	RAM_USED=${RAM_STATUS_ALL[2]}
	RAM_R=$(echo "$RAM_USED/$RAM_TOTAL*100" |bc -l)
}

get_hard_stat() {
	local HARD_STATUS_ALL=($(df -h /dev/nvme0n1p2 | tail -n 1))
	HARD_TOTAL=${HARD_STATUS_ALL[1]}
	HARD_USED=${HARD_STATUS_ALL[2]}
	HARD_AVAIL=${HARD_STATUS_ALL[3]}
	HARD_R=${HARD_STATUS_ALL[4]}
}


generate_charge_string () {
	local charge_status=$1
	local charge_amount=$2
	local charge_remaining=$3

	if [ "$charge_status" == "D" ]; then
		if [ "$charge_amount" -gt 90 ]; then
			sym="^c#eceff4^"
		elif [ "$charge_amount" -gt 65 -a "$charge_amount" -le 90 ]; then
			sym="^c#eceff4^"
		elif [ "$charge_amount" -gt 35 -a "$charge_amount" -le 65 ]; then
			sym="^c#eceff4^"
		elif [ "$charge_amount" -gt 25 -a "$charge_amount" -le 35 ]; then
			sym="^c#eceff4^"
		elif [ "$charge_amount" -gt 20 -a "$charge_amount" -le 25 ]; then
			sym="^c#ebcb8b^^c#eceff4^"
		elif [ "$charge_amount" -gt 15 -a "$charge_amount" -le 20 ]; then
			sym="^c#bf616a^^c#eceff4^"
		else
			blink $LOW_CH_IND
			LOW_CH_IND=$?
			
			if [ $LOW_CH_IND -eq 1 ]; then
				sym="^c#bf616a^^c#eceff4^"
			else
				sym=" ^c#eceff4^"
			fi
		fi
	elif [ "$charge_status" == "N" ]; then
		sym="^c#eceff4^"
		charge_amount=100
	else
		sym="^c#eceff4^"
	fi
	
	if [ $(expr length $charge_amount) -lt 2 ]; then
		charge_amount="$charge_amount "
	fi
	
	CHARGE_STRING="${sym} ${charge_amount}%"
	
}

generate_cpu_string(){
	local cpu_percentage=$1
	local cpu_percentage_number="${cpu_percentage: 0:-1}"
	
	if (( $(echo "$cpu_percentage_number < 70" |bc -l) )); then
		sym="^c#eceff4^CPU:"
	elif (( $(echo "$cpu_percentage_number >= 70" |bc -l)  &&  $(echo "$cpu_percentage_number < 80" |bc -l) )); then
		sym="^c#ebcb8b^CPU:^c#eceff4^"
	elif (( $(echo "$cpu_percentage_number >= 80" |bc -l)  &&  $(echo "$cpu_percentage_number < 90" |bc -l) )); then
		sym="^c#bf616a^CPU:^c#eceff4^"
	else
		blink $HIGH_CPU_IND
		HIGH_CPU_IND=$?
		
		if [ $HIGH_CPU_IND -eq 1 ]; then
			sym="^c#bf616a^CPU:^c#eceff4^"
		else
			sym="    ^c#eceff4^"
		fi
	fi

	if [ $(expr length $cpu_percentage) -lt 5 ]; then
		cpu_percentage="$cpu_percentage "
	fi
	
	CPU_STRING="$sym $cpu_percentage"
}

generate_ram_string(){
	local ram_percentage=$(printf "%.1f" "${1}")
	if (( $(echo "$ram_percentage < 70" |bc -l) )); then
		sym="RAM:"
	elif (( $(echo "$ram_percentage >= 70" |bc -l)  &&  $(echo "$ram_percentage < 80" |bc -l) )); then
		#sym="\033[0;33mRAM:\033[0m"
		sym="^c#ebcb8b^RAM:"
	elif (( $(echo "$ram_percentage >= 80" |bc -l)  &&  $(echo "$ram_percentage < 90" |bc -l) )); then
		#sym="\033[0;31mRAM:\033[0m"
		sym="^c#bf616a^RAM:^c#eceff4^"
	else
		blink $HIGH_RAM_IND
		HIGH_RAM_IND=$?

		if [ $HIGH_RAM_IND -eq 1 ]; then
			#sym="\033[0;31mRAM:\033[0m"
			sym="^c#bf616a^RAM:^c#eceff4^"
		else
			sym="    ^c#eceff4^"
		fi
	fi
	
	if [ $(expr length $ram_percentage) -lt 4 ]; then
		ram_percentage="$ram_percentage "
	fi
	
	RAM_STRING="$sym $ram_percentage%"
}

generate_hard_string(){
	local hard_percentage=$1
	local hard_amount=$2
	local hard_percentage_number="${HARD_R: 0:-1}"
	
	if (( $(echo "$hard_percentage_number < 70" |bc -l) )); then
		sym="^c#eceff4^HARD:"
	elif (( $(echo "$hard_percentage_number >= 70" |bc -l)  &&  $(echo "$hard_percentage_number < 80" |bc -l) )); then
		sym="^c#ebcb8b^HARD:^c#eceff4^"
	elif (( $(echo "$hard_percentage_number >= 80" |bc -l)  &&  $(echo "$hard_percentage_number < 90" |bc -l) )); then
		sym="^c#bf616a^HARD:^c#eceff4^"
	else
		blink $HIGH_HARD_IND
		HIGH_HARD_IND=$?
		
		if [ $HIGH_HARD_IND -eq 1 ]; then
			sym="^c#bf616a^HARD:^c#eceff4^"
		else
			sym="     ^c#eceff4^"
		fi
	fi

	if [ $(expr length $hard_percentage) -lt 3 ]; then
		hard_percentage="$hard_percentage "
	fi
	
	if [ $(expr length $hard_amount) -le 2 ]; then
		hard_amount="$hard_amount  "
	elif [ $(expr length $hard_amount) -le 3 ]; then
		hard_amount="$hard_amount "
	fi
	
	HARD_STRING="$sym $hard_percentage | $hard_amount"
}

generate_connection_string () {
	local ip=$1
	local received=$2
	local transmitted=$3
	
	local received_kb=$((received/125))
	local transmitted_kb=$((transmitted/125))
	
	if (( $(echo "$received_kb < 500" |bc -l) )); then
		down_measure_sym="^c#eceff4^Kb"
		down_sym="^c#eceff4^"
	elif (( $(echo "$received_kb >= 500" |bc -l)  &&  $(echo "$received_kb < 1000" |bc -l) )); then
		down_measure_sym="^c#eceff4^Kb"
		down_sym="^c#ebcb8b^^c#eceff4^"
	else
		down_measure_sym="^c#eceff4^Mb"
		down_sym="^c#bf616a^^c#eceff4^"
		received_kb=$((received_kb/1000))
	fi
	
	if [ $(expr length $received_kb) -eq 1 ]; then
		received_kb="$received_kb  "
	elif [ $(expr length $received_kb) -eq 2 ]; then
		received_kb="$received_kb "
	fi
	
	if (( $(echo "$transmitted_kb < 500" |bc -l) )); then
		up_measure_sym="^c#eceff4^Kb"
		up_sym="^c#eceff4^"
	elif (( $(echo "$transmitted_kb >= 500" |bc -l)  &&  $(echo "$transmitted_kb < 1000" |bc -l) )); then
		up_measure_sym="^c#eceff4^Kb"
		up_sym="^c#ebcb8b^^c#eceff4^"
	else
		up_measure_sym="^c#eceff4^Mb"
		up_sym="^c#bf616a^^c#eceff4^"
		transmitted_kb=$((transmitted_kb/1000))
	fi
	
	if [ $(expr length $transmitted_kb) -eq 1 ]; then
		transmitted_kb="$transmitted_kb  "
	elif [ $(expr length $transmitted_kb) -eq 2 ]; then
		transmitted_kb="$transmitted_kb "
	fi
	
	local re='^[0-9]+$'
	if ! [[ "${ip: 0:1}" =~ $re ]] ; then
		ip="^c#bf616a^DISCONNECTED      ^c#eceff4^"
	else
		ip="^c#eceff4^IP: $ip"
	fi

	CONNECTION_STRING="$ip | $up_sym $transmitted_kb $up_measure_sym | $down_sym $received_kb $down_measure_sym"
}

LOW_CH_IND=0
HIGH_CPU_IND=0
HIGH_RAM_IND=0
HIGH_HARD_IND=0
init_temp_files

date_service
cpu_service
connection_service

while true; do
	
	get_date_stat
	get_charge_stat
	get_cpu_stat
	get_ram_stat
	get_hard_stat
	get_connection_stat
	
	generate_charge_string "$CHARGE_STATUS" "$CHARGE_AMOUNT" "$CHARGE_REMAINING"
	generate_cpu_string "${CPU_USAGE}"
	generate_ram_string "$RAM_R"
	generate_hard_string "$HARD_R" "$HARD_AVAIL"
	generate_connection_string "$IP" "$RECEIVED" "$TRANSMITTED"
	
	xsetroot -name "^c#eceff4^ [ $CONNECTION_STRING ] [ $CHARGE_STRING ] [ $HARD_STRING ] [ $RAM_STRING ] [ $CPU_STRING ]   $LOCALTIME "
	sleep 0.5
done

