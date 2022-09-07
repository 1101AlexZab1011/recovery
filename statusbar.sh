#!/usr/bin/env bash
     
     
#while true; do
#		date '+  %a %d %b   %R ' > /tmp/CurTime.tmp
#		sleep 60s
#done &

#while true; do
#		tempcpu=$(printf "%b" "import psutil\nprint('{}%'.format(psutil.cpu_percent(interval=2)))" | python3)
#		echo $tempcpu > /tmp/CurCPUMain.tmp
#done &

LOW_CH_IND=0
HIGH_CPU_IND=0
HIGH_RAM_IND=0

blink () {
	local indexer=$1
	if [ $indexer -eq 1 ]; then
		indexer=0
	else
		indexer=1
	fi
	return $indexer
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
		charge_amount=" $charge_amount"
	fi
	
	CHARGE_STRING="${sym} ${charge_amount}%"
	
}

generate_cpu_string(){
	local cpu_percentage=$1
	local cpu_percentage_number="${cpu_percentage: 0:-1}"
	
	if (( $(echo "$cpu_percentage_number < 70" |bc -l) )); then
		sym="CPU:"
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
	CPU_STRING="$sym $cpu_percentage"

	if [ $(expr length $cpu_percentage) -lt 5 ]; then
		cpu_percentage=" $cpu_percentage"
	fi
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
		ram_percentage=" $ram_percentage"
	fi
	
	RAM_STRING="$sym $ram_percentage%"
}

     
while true; do
		touch /tmp/CurCPUMain.tmp
		echo 0.0% > /tmp/CurCPUMain.tmp
		touch /tmp/CurTime.tmp
		LOCALTIME=$(echo $(< /tmp/CurTime.tmp))
 
		get_charge_stat
		get_cpu_stat
		get_ram_stat
		
		generate_charge_string "$CHARGE_STATUS" "$CHARGE_AMOUNT" "$CHARGE_REMAINING"
		generate_cpu_string "${CPU_USAGE}"
		generate_ram_string "$RAM_R"
		
		xsetroot -name " [ $CHARGE_STRING ] [ $RAM_STRING ] [ $CPU_STRING ]   $LOCALTIME "
		sleep 0.5
done

