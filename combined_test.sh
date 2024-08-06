#!/bin/sh
# Filename: combined_test.sh
# Purpose:  For multiple projects test
# Author: Jack Chang

#===Run time pool===
Stressapp_time=28800
FIO_time=7200
Iperf_time=3600
AC_count=220
Idle_time=86400
num=$1

#===IP pool===
if [ $1 -lt 10 ]
	then
		BMCIP=( "b000${1}.slot1" )
		slotIP=( "r000${1}.slot2" "r000${1}.slot4" )
	else
		BMCIP=( "b00${1}.slot1" )
		slotIP=( "r00${1}.slot2" "r00${1}.slot4" )
fi

#===Clear log===
function clear_log()
{
	for ip in ${BMCIP[@]}
	do
		sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip 'dmesg -c' > /dev/null 2>&1
		sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip 'echo " " > /var/log/messages' 2>&1
		sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip "/usr/local/bin/log-util all --clear" 2>&1
		for ((i=1;i<=4;i++));
		do
			sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip "/usr/local/bin/log-util slot$i --clear" 2>&1
			sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip 'echo " " > /var/log/mTerm_slot'"${i}.log" 2>&1
			sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip 'echo " " > /var/log/mTerm_slot'"${i}_backup.log" 2>&1
		done
	done
	for ip in ${slotIP[@]}
	do
		ssh $ip 'dmesg -c' > /dev/null 2>&1
		ssh $ip 'echo " " > /var/log/messages' 2>&1
	done
}

#===Capture log===
function capture_log()
{
	for ip in ${BMCIP[@]}
	do
		echo -e "====================================Date_${counter}:============================================\n" >> Sled${num}/${ip}_date_obmc.log 2>&1
		sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip 'date' >> Sled${num}/${ip}_date_obmc.log 2>&1
		echo -e "====================================Varlog_${counter}:============================================\n" >> Sled${num}/${ip}_varlog_obmc.log 2>&1
		sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip 'cat /var/log/messages' >> Sled${num}/${ip}_varlog_obmc.log 2>&1
		echo -e "====================================Sel_${counter}:============================================\n" >> Sled${num}/${ip}_sel-all_obmc.log 2>&1
		sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip '/usr/local/bin/log-util all --print' >> Sled${num}/${ip}_sel-all_obmc.log 2>&1
		echo -e "====================================Sensor_${counter}:============================================\n" >> Sled${num}/${ip}_sensor-all_obmc.log 2>&1
		sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip '/usr/local/bin/sensor-util all' >> Sled${num}/${ip}_sensor-all_obmc.log 2>&1
		for ((i=1;i<=4;i++));
		do
			echo -e "====================================Sel_${counter}:============================================\n" >> Sled${num}/${ip}_sel_slot${i}.log 2>&1
			sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip /usr/local/bin/log-util slot${i} --print >> Sled${num}/${ip}_sel_slot${i}.log 2>&1
			echo -e "====================================Sol_${counter}:============================================\n" >> Sled${num}/${ip}_sol_slot${i}.log 2>&1
			sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip /usr/local/bin/sol-util slot${i} --history >> Sled${num}/${ip}_sol_slot${i}.log 2>&1
			echo -e "====================================mTerm_${counter}:============================================\n" >> Sled${num}/${ip}_mTerm_slot${i}.log 2>&1
			sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip cat /var/log/mTerm_slot${i}.log >> Sled${num}/${ip}_mTerm_slot${i}.log 2>&1
			echo -e "====================================mTerm_backup_${counter}:============================================\n" >> Sled${num}/${ip}_mTerm_backup_slot${i}.log 2>&1
			sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip cat /var/log/mTerm_slot${i}_backup.log >> Sled${num}/${ip}_mTerm_backup_slot${i}.log 2>&1
			echo -e "====================================Sensor_${counter}:============================================\n" >> Sled${num}/${ip}_sensor_slot${i}.log 2>&1
			sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip /usr/local/bin/sensor-util slot${i} >> Sled${num}/${ip}_sensor_slot${i}.log 2>&1
	    done
	done
	for ip in ${slotIP[@]}
	do
		echo -e "====================================OS info_${counter}:============================================\n" >> Sled${num}/${ip}_OS_slot.log 2>&1
		ssh $ip 'cat /etc/redhat-release' >> Sled${num}/${ip}_OS_slot.log 2>&1
		ssh $ip 'uname -r' >> Sled${num}/${ip}_OS_slot.log 2>&1
		echo -e "====================================lspci list_${counter}:============================================\n" >> Sled${num}/${ip}_lspci_slot.log 2>&1
		ssh $ip 'lspci' >> Sled${num}/${ip}_lspci_slot.log 2>&1
		echo -e "=========================================nvme list_${counter}:========================================\n" >> Sled${num}/${ip}_nvme_slot.log 2>&1
		ssh $ip 'nvme list' >> Sled${num}/${ip}_nvme_slot.log 2>&1
		echo -e "======================================dmesg error & fail list_${counter}:==========================================\n" >> Sled${num}/${ip}_dmesg_error_slot.log 2>&1
		ssh $ip 'dmesg | grep -i "error\|fail\|call trace\|kernel panic"' >> Sled${num}/${ip}_dmesg_error_slot.log 2>&1
		echo -e "===================================var message error & fail list_${counter}:=======================================\n" >> Sled${num}/${ip}_varlog_error_slot.log 2>&1
		ssh $ip 'cat /var/log/messages | grep -i "error\|fail\|call trace\|kernel panic"' >> Sled${num}/${ip}_varlog_error_slot.log 2>&1
		echo -e "======================================lsblk list_${counter}:==========================================\n" >> Sled${num}/${ip}_lsblk_slot.log 2>&1
		ssh $ip 'lsblk' >> Sled${num}/${ip}_lsblk_slot.log 2>&1
		echo -e "======================================CPU list_${counter}:==========================================\n" >> Sled${num}/${ip}_CPU_slot.log 2>&1
		ssh $ip 'dmidecode -t 4' >> Sled${num}/${ip}_CPU_slot.log 2>&1
		echo -e "======================================DIMM list_${counter}:==========================================\n" >> Sled${num}/${ip}_DIMM_slot.log 2>&1
		ssh $ip 'dmidecode -t 17' >> Sled${num}/${ip}_DIMM_slot.log 2>&1
		echo -e "======================================NIC info_${counter}:==========================================\n" >> Sled${num}/${ip}_NIC_slot.log 2>&1
	    ssh $ip 'ethtool -i eth0' >> Sled${num}/${ip}_NIC_slot.log 2>&1
		echo -e "======================================lspci -vvv list_${counter}:==========================================\n" >> Sled${num}/${ip}_lspcivvv_slot.log 2>&1
		ssh $ip 'lspci -vvv' >> Sled${num}/${ip}_lspcivvv_slot.log 2>&1
		echo -e "======================================dmesg information_${counter}:==========================================\n" >> Sled${num}/${ip}_dmesg_slot.log 2>&1
		ssh $ip 'dmesg' >> Sled${num}/${ip}_dmesg_slot.log 2>&1
		echo -e "======================================Date_${counter}:==========================================\n" >> Sled${num}/${ip}_date_slot.log 2>&1
		ssh $ip 'date' >> Sled${num}/${ip}_date_slot.log 2>&1
		echo -e "======================================Mce_${counter}:==========================================\n" >> Sled${num}/${ip}_mce_slot.log 2>&1
		ssh $ip 'mcelog' >> Sled${num}/${ip}_mce_slot.log 2>&1
		echo -e "======================================lspci -vt_${counter}:==========================================\n" >> Sled${num}/${ip}_lspcivt_slot.log 2>&1
		ssh $ip 'lspci -vt' >> Sled${num}/${ip}_lspcivt_slot.log 2>&1
	done
}

#===Capture nnpi===
function capture_nnpi()
{
	for ip in ${slotIP[@]}
	do
		echo -e "======================================nnpi_${counter}:==========================================\n" >> Sled${num}/${ip}_nnpi_slot.log 2>&1
		ssh $ip "nnpi_ctl list -a" >> Sled${num}/${ip}_nnpi_slot.log 2>&1
	done
}

#===Stressapp===
function Stressapp()
{
	counter=1
	capture_log
	clear_log
	for ip in ${slotIP[@]}
	do
		MemorySize=`ssh $ip "cat /proc/meminfo" | grep -i MemFree | awk '{print $2}'`
		MemorySize=$(($MemorySize/1000*9/10))
		ssh $ip "stressapptest --cc_test -M $MemorySize -s $Stressapp_time --local_numa --pause_delay $Stressapp_time" >> Sled${num}/${ip}_stressapp.log 2>&1 &
	done
	sh Project_log_all.sh Log ${Stressapp_time} ${num} &
	sleep_time=$(($Stressapp_time/60+1))
	while [ ${counter} -le ${sleep_time} ]
	do
		echo -e "Stressapp still running and period of capture log\nRemain time: $(($sleep_time-$counter))(mins)" > Sled${num}/check_status.log
		sleep 60
		counter=$(($counter+1))
	done
	for Killid in `ps ax|grep "sh Project_log_all.sh Log ${Stressapp_time} ${num}" | grep -v grep |awk '{print $1}'`
	do
		kill ${Killid}
	done
	for ip in ${BMCIP[@]}
	do
		mkdir -p Sled${num}/Stressapp
	done
	for ip in ${BMCIP[@]}
	do
		mv Sled${num}/${ip}_* Sled${num}/Stressapp
	done
	mv Sled${num}/${slotIP[0]}_* Sled${num}/${slotIP[1]}_* Sled${num}/Stressapp
}

#===FIO===
function FIO()
{
	counter=1
	capture_log
	clear_log
	echo -e "[global]\ndo_verify=1\nlockmem=1258291\nblockalign=128k\nioengine=libaio\niodepth=64\nnumjobs=1\ndirect=1\ninvalidate=1\ntime_based\nruntime=$FIO_time\nnorandommap\nrandrepeat=0\ngroup_reporting=1\nrw=randrw\nrwmixread=50\nrwmixwrite=50\n[NVME_SERT_mix_r/w:50%:50%]\nfilename=/dev/nvme1n1\nfilename=/dev/nvme2n1\nbs=128k\n" > Sled${num}/mix_jobfile 
	for ip in ${slotIP[@]}
	do
		sshpass -p 000000 scp -r -o StrictHostKeyChecking=no Sled${num}/mix_jobfile root@[$ip]:/root
		sleep 10
		ssh $ip "fio mix_jobfile" >> Sled${num}/${ip}_fio.log &
	done
	sh Project_log_all.sh Log ${FIO_time} ${num} &
	sleep_time=$(($FIO_time/60+1))
	while [ ${counter} -le ${sleep_time} ]
	do
		echo -e "FIO still running and period of capture log\nRemain time: $(($sleep_time-$counter))(mins)" > Sled${num}/check_status.log
		sleep 60
		counter=$(($counter+1))
	done
	for Killid in `ps ax|grep "sh Project_log_all.sh Log ${FIO_time} ${num}" | grep -v grep |awk '{print $1}'`
	do
		kill ${Killid}
	done
	for ip in ${BMCIP[@]}
	do
		mkdir -p Sled${num}/FIO
	done
	for ip in ${BMCIP[@]}
	do
		mv Sled${num}/${ip}_* Sled${num}/FIO
	done
	mv Sled${num}/${slotIP[0]}_* Sled${num}/${slotIP[1]}_* Sled${num}/FIO
}

#===Iperf===
function Iperf()
{
	counter=1
	capture_log
	clear_log
	for ip in ${slotIP[@]}
	do
		ssh $ip 'ifconfig' >> Sled${num}/${ip}_IP.log 2>&1
	done
	for ip in ${slotIP[@]}
	do
		ssh $ip "iperf -s -i 5 -V" >> Sled${num}/${ip}_iperf-s.log 2>&1 &
	done
	sleep 10
	slot2_ip=`cat Sled${num}/${slotIP[0]}_IP.log |grep 192.168 |awk '{print $2}'`
	slot4_ip=`cat Sled${num}/${slotIP[1]}_IP.log |grep 192.168 |awk '{print $2}'`
	ssh ${slotIP[0]} "iperf -c ${slot4_ip} -t $Iperf_time -P 8 -i 5" >> Sled${num}/${slotIP[0]}_iperf.log 2>&1 &
	ssh ${slotIP[1]} "iperf -c ${slot2_ip} -t $Iperf_time -P 8 -i 5" >> Sled${num}/${slotIP[1]}_iperf.log 2>&1 &
	sh Project_log_all.sh Log ${Iperf_time} ${num} &
	sleep_time=$(($Iperf_time/60+1))
	while [ ${counter} -le ${sleep_time} ]
	do
		echo -e "Iperf still running and period of capture log\nRemain time: $(($sleep_time-$counter))(mins)" > Sled${num}/check_status.log
		sleep 60
		counter=$(($counter+1))
	done
	for Killid in `ps ax|grep "sh Project_log_all.sh Log ${Iperf_time} ${num}" | grep -v grep |awk '{print $1}'`
	do
		kill ${Killid}
	done
	for ip in ${BMCIP[@]}
	do
		mkdir -p Sled${num}/Iperf
	done
	for ip in ${BMCIP[@]}
	do
		mv Sled${num}/${ip}_* Sled${num}/Iperf
	done
	mv Sled${num}/${slotIP[0]}_* Sled${num}/${slotIP[1]}_* Sled${num}/Iperf
}

#===SledAC===
function SledAC()
{
	counter=1
	capture_log
	clear_log
	capture_nnpi
	while [ ${counter} -le ${AC_count} ]
	do
		for ip in ${BMCIP[@]}
		do
			sshpass -p 0penBmc ssh -o StrictHostKeyChecking=no root@$ip '/usr/local/bin/power-util sled-cycle' & < /dev/null
		done
		for ip in ${BMCIP[@]}
		do
			boot_check_bmc=1
			timeoutcount=0
			while [ 1 ]
			do
				echo "Wait for boot into OBMC"
				if [ $timeoutcount -eq 10000 ]
					then
					exit
				fi
				sleep 10
				sshpass -p 0penBmc ssh $ip ifconfig
				boot_check_bmc=$?
				if [ $boot_check_bmc -eq 0 ]
					then
					break
				fi
				sleep 10
				timeoutcount=$(($timeoutcount+1))
			done
		done
		for ip in ${slotIP[@]}
		do
			boot_check_bmc=1
			timeoutcount=0
			while [ 1 ]
			do
				echo "Wait for boot into OS"
				if [ $timeoutcount -eq 10000 ]
					then
					exit
				fi
				sleep 10
				sshpass -p 000000 ssh $ip ifconfig
				boot_check_bmc=$?
				if [ $boot_check_bmc -eq 0 ]
					then
					break
				fi
				sleep 10
				timeoutcount=$(($timeoutcount+1))
			done
		done
		echo -e "SledAC still running and period of capture log\nRemain count: $(($AC_count-$counter))(times)" > Sled${num}/check_status.log
		capture_log
		capture_nnpi
		counter=$(($counter+1))
	done
	for ip in ${BMCIP[@]}
	do
		mkdir -p Sled${num}/sledAC
	done
	for ip in ${BMCIP[@]}
	do
		mv Sled${num}/${ip}_* Sled${num}/sledAC
	done
	mv Sled${num}/${slotIP[0]}_* Sled${num}/${slotIP[1]}_* Sled${num}/sledAC
}

#===Idle===
function Idle()
{
	counter=1
	capture_log
	clear_log
	sh Project_log_all.sh Log ${Idle_time} ${num} &
	sleep_time=$(($Idle_time/60+1))
	while [ ${counter} -le ${sleep_time} ]
	do
		echo -e "Idle still running and period of capture log\nRemain time: $(($sleep_time-$counter))(mins)" > Sled${num}/check_status.log
		sleep 60
		counter=$(($counter+1))
	done
	for Killid in `ps ax|grep "sh Project_log_all.sh Log ${Idle_time} ${num}" | grep -v grep |awk '{print $1}'`
	do
		kill ${Killid}
	done
	for ip in ${BMCIP[@]}
	do
		mkdir -p Sled${num}/Idle
	done
	for ip in ${BMCIP[@]}
	do
		mv Sled${num}/${ip}_* Sled${num}/Idle
	done
	mv Sled${num}/${slotIP[0]}_* Sled${num}/${slotIP[1]}_* Sled${num}/Idle
}

counter0=6
while [ $counter0 -le 6 ]
do
	counter2=4
	while [ $counter2 -le 6 ]
	do
		SledAC
		mkdir Sled${num}/PartB_${counter2}
		mv Sled${num}/sledAC Sled${num}/PartB_${counter2}
		counter2=$(($counter2+1))
	done

	counter3=1
	while [ $counter3 -le 1 ]
	do
		Stressapp
		mkdir Sled${num}/PartC_${counter3}
		mv Sled${num}/Stressapp Sled${num}/PartC_${counter3}
		Idle
		FIO
		mv Sled${num}/FIO Sled${num}/Idle Sled${num}/PartC_${counter3}
		Iperf
		mv Sled${num}/Iperf Sled${num}/PartC_${counter3}
		counter3=$(($counter3+1))
	done
	mkdir Sled${num}/Total_part${counter0}
	mv Sled${num}/Part* Sled${num}/Total_part${counter0}
	counter0=$(($counter0+1))
done
