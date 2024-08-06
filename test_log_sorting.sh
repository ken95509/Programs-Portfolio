#!/bin/sh
# Filename: test_log_sorting.sh
# Purpose:  Sort out test logs into excel
# Author: Jack Chang

case ${1} in
	"Compute_all")
		path=`pwd`
		#===================================Input Title===================================
		echo -n "Date" |tee -a ${path}/Compute_all.csv
		
		for name in `ls -d */ |sed 's/.$//' |grep "with" |cut -d "_" -f1`
		do	
			if [ `echo -e ${name}|cut -c1` == 'P' ]
				then
					echo -n ",Project1_Temp_Inlet_${name}" |tee -a ${path}/Compute_all.csv
				else
					echo -n ",Project2_Temp_Inlet_${name}" |tee -a ${path}/Compute_all.csv
			fi
		done
		
		for name in `ls -d */ |sed 's/.$//' |grep "with" |cut -d "_" -f1`
		do
			echo -n ",${name}_HSC0_Input_Power" |tee -a ${path}/Compute_all.csv
		done
		echo -e "" |tee -a ${path}/Compute_all.csv
		
		#===================================Collect Date Data===================================
		cd ${2}
		for folder in `ls -d */ |sed 's/.$//'`
		do
			cd ${folder}
			time_num1=1
			cat sdr.txt |grep "2024" |cut -c1-15 >> time_format.log
			while [ 1 ]
			do
				format1=`sed -n ${time_num1}p time_format.log |grep "2024" |cut -c1-10`
				format2=`sed -n ${time_num1}p time_format.log |grep "2024" |cut -c11-13`
				format3=`sed -n ${time_num1}p time_format.log |grep "2024" |cut -c14-15`
				echo -e "${format1}${format2}:${format3}" >> ${path}/time.log
				time_num1=$(($time_num1+1))
				total_time_num1=`awk '{print NR}' time_format.log|tail -n1`
				if [ ${time_num1} -ge ${total_time_num1} ]
					then
						break
				fi
			done
			rm -f time_format.log
			cd ..
		done
		cd ${path}
		
		#===================================Sorting log===================================
		for folder in `ls -d */ |sed 's/.$//' |grep "with"`
		do
			cd ${folder}
			for folder1 in `ls -d */ |sed 's/.$//'`
			do	
				cd ${folder1}
				cat sdr.txt |grep "HSC0 Input Power" |awk '{print $5}' >> ${path}/${folder}_HSC0_Input_Power.log
				cat sdr.txt |grep "Temp_Inlet" |awk '{print $3}' >> ${path}/${folder}_temp_inlet.log		
				cd ..
			done
			cd ..
		done
		
		time_num=1
		temp_inlet_num=1
		hsc_power_num=1
		while [ 1 ]
		do
			time=`sed -n ${time_num}p ${path}/time.log`
			echo -n "${time}" |tee -a ${path}/Compute_all.csv
			for folder in `ls -d */ |sed 's/.$//' |grep "with"`
			do
				temp_inlet=`sed -n ${temp_inlet_num}p ${folder}_temp_inlet.log`
				echo -n ",${temp_inlet}" |tee -a ${path}/Compute_all.csv
			done
			for folder in `ls -d */ |sed 's/.$//' |grep "with"`
			do
				hus_power=`sed -n ${hsc_power_num}p ${folder}_HSC0_Input_Power.log`
				echo -n ",${hus_power}" |tee -a ${path}/Compute_all.csv
			done
			echo -e "" |tee -a ${path}/Compute_all.csv
			total_time_num=`awk '{print NR}' ${path}/time.log|tail -n1`
			i=1
			for folder in `ls -d */ |sed 's/.$//' |grep "with"`
			do
				if [ ${i} -eq 1 ]
					then
						total_temp_inlet_num1=`awk '{print NR}' ${folder}_temp_inlet.log|tail -n1`
						total_hsc_power_num1=`awk '{print NR}' ${folder}_HSC0_Input_Power.log|tail -n1`
				fi
				if [ ${i} -eq 2 ]
					then
						total_temp_inlet_num2=`awk '{print NR}' ${folder}_temp_inlet.log|tail -n1`
						total_hsc_power_num2=`awk '{print NR}' ${folder}_HSC0_Input_Power.log|tail -n1`
				fi
				if [ ${i} -eq 3 ]
					then
						total_temp_inlet_num3=`awk '{print NR}' ${folder}_temp_inlet.log|tail -n1`
						total_hsc_power_num3=`awk '{print NR}' ${folder}_HSC0_Input_Power.log|tail -n1`
				fi
				if [ ${i} -eq 4 ]
					then
						total_temp_inlet_num4=`awk '{print NR}' ${folder}_temp_inlet.log|tail -n1`
						total_hsc_power_num4=`awk '{print NR}' ${folder}_HSC0_Input_Power.log|tail -n1`
				fi
				if [ ${i} -eq 5 ]
					then
						total_temp_inlet_num5=`awk '{print NR}' ${folder}_temp_inlet.log|tail -n1`
						total_hsc_power_num5=`awk '{print NR}' ${folder}_HSC0_Input_Power.log|tail -n1`
				fi
				if [ ${i} -eq 6 ]
					then
						total_temp_inlet_num6=`awk '{print NR}' ${folder}_temp_inlet.log|tail -n1`
						total_hsc_power_num6=`awk '{print NR}' ${folder}_HSC0_Input_Power.log|tail -n1`
				fi
				i=$(($i+1))
			done
			if [ ${time_num} -ge ${total_time_num} ] && [ ${temp_inlet_num} -ge ${total_temp_inlet_num1} ] && [ ${hsc_power_num} -ge ${total_hsc_power_num1} ] && [ ${temp_inlet_num} -ge ${total_temp_inlet_num2} ] && [ ${hsc_power_num} -ge ${total_hsc_power_num2} ] && [ ${temp_inlet_num} -ge ${total_temp_inlet_num3} ] && [ ${hsc_power_num} -ge ${total_hsc_power_num3} ] && [ ${temp_inlet_num} -ge ${total_temp_inlet_num4} ] && [ ${hsc_power_num} -ge ${total_hsc_power_num4} ] && [ ${temp_inlet_num} -ge ${total_temp_inlet_num5} ] && [ ${hsc_power_num} -ge ${total_hsc_power_num5} ] && [ ${temp_inlet_num} -ge ${total_temp_inlet_num6} ] && [ ${hsc_power_num} -ge ${total_hsc_power_num6} ]
				then
					break
			fi
			time_num=$(($time_num+1))
			temp_inlet_num=$(($temp_inlet_num+1))
			hsc_power_num=$(($hsc_power_num+1))
		done
		#===================================Remove Log===================================
		for folder in `ls -d */ |sed 's/.$//' |grep "with"`
		do
			rm -f ${folder}_temp_inlet.log ${folder}_HSC0_Input_Power.log
		done
		rm -f time.log
	;;
	"Storage_all")
		path=`pwd`
		#===================================Input title===================================
		echo -n "Date" |tee -a ${path}/Total_Storage.csv
		for ((i=1;i<=3;i++))
		do
			echo -n ",SUT${i}_INLET_TEMP" |tee -a ${path}/Total_Storage.csv
		done
		for ((i=1;i<=16;i++))
		do
			echo -n ",SUT1_Ruler${i}" |tee -a ${path}/Total_Storage.csv
			echo -n ",SUT2_Ruler${i}" |tee -a ${path}/Total_Storage.csv
			echo -n ",SUT3_Ruler${i}" |tee -a ${path}/Total_Storage.csv
		done
		echo -e "" |tee -a ${path}/Total_Storage.csv
		
		#===================================Collect log===================================
		cd Storage_BMC
		for folder in `ls -d */ |sed 's/.$//'`
		do
			cd ${folder}
			cat ${2}/SDR.log |grep "Time" |cut -c5-20 >> ${path}/time.log
			Storage_folder=( "22U_F5" "26U_F4" "29U_F6" )
			for Storage_path in ${Storage_folder[@]}
			do
				cd ${Storage_path}
				cat SDR.log |grep "SYS_INLET_TEMP" |awk '{print $5}' >> ${path}/${Storage_path}_SYS_INLET.log
				for ((i=1;i<=16;i++));
				do
					cat SDR.log |grep "SSD${i}_DRIVE1_x4_TEMP" |awk '{print $5}' >> ${path}/${Storage_path}_SSD${i}.log
				done
				cd ..
			done
			cd ..
		done
		#===================================Sorting log===================================
		time_num=1
		sut1_inlet_num=1
		sut1_ruler_num=1
		sut2_inlet_num=1
		sut2_ruler_num=1
		sut3_inlet_num=1
		sut3_ruler_num=1
		while [ 1 ]
		do
			time=`sed -n ${time_num}p ${path}/time.log`
			sut1_sys_inlet=`sed -n ${sut1_inlet_num}p ${path}/22U_F5_SYS_INLET.log`
			sut1_ruler1=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD1.log`
			sut1_ruler2=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD2.log`
			sut1_ruler3=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD3.log`
			sut1_ruler4=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD4.log`
			sut1_ruler5=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD5.log`
			sut1_ruler6=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD6.log`
			sut1_ruler7=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD7.log`
			sut1_ruler8=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD8.log`
			sut1_ruler9=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD9.log`
			sut1_ruler10=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD10.log`
			sut1_ruler11=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD11.log`
			sut1_ruler12=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD12.log`
			sut1_ruler13=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD13.log`
			sut1_ruler14=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD14.log`
			sut1_ruler15=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD15.log`
			sut1_ruler16=`sed -n ${sut1_ruler_num}p ${path}/22U_F5_SSD16.log`
			sut2_sys_inlet=`sed -n ${sut2_inlet_num}p ${path}/26U_F4_SYS_INLET.log`
			sut2_ruler1=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD1.log`
			sut2_ruler2=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD2.log`
			sut2_ruler3=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD3.log`
			sut2_ruler4=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD4.log`
			sut2_ruler5=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD5.log`
			sut2_ruler6=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD6.log`
			sut2_ruler7=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD7.log`
			sut2_ruler8=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD8.log`
			sut2_ruler9=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD9.log`
			sut2_ruler10=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD10.log`
			sut2_ruler11=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD11.log`
			sut2_ruler12=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD12.log`
			sut2_ruler13=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD13.log`
			sut2_ruler14=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD14.log`
			sut2_ruler15=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD15.log`
			sut2_ruler16=`sed -n ${sut2_ruler_num}p ${path}/26U_F4_SSD16.log`
			sut3_sys_inlet=`sed -n ${sut3_inlet_num}p ${path}/29U_F6_SYS_INLET.log`
			sut3_ruler1=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD1.log`
			sut3_ruler2=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD2.log`
			sut3_ruler3=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD3.log`
			sut3_ruler4=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD4.log`
			sut3_ruler5=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD5.log`
			sut3_ruler6=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD6.log`
			sut3_ruler7=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD7.log`
			sut3_ruler8=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD8.log`
			sut3_ruler9=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD9.log`
			sut3_ruler10=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD10.log`
			sut3_ruler11=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD11.log`
			sut3_ruler12=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD12.log`
			sut3_ruler13=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD13.log`
			sut3_ruler14=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD14.log`
			sut3_ruler15=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD15.log`
			sut3_ruler16=`sed -n ${sut3_ruler_num}p ${path}/29U_F6_SSD16.log`
			echo -n "${time}" |tee -a ${path}/Total_Storage.csv
			value=( "${sut1_sys_inlet}" "${sut2_sys_inlet}" "${sut3_sys_inlet}" "${sut1_ruler1}" "${sut2_ruler1}" "${sut3_ruler1}" "${sut1_ruler2}" "${sut2_ruler2}" "${sut3_ruler2}" "${sut1_ruler3}" "${sut2_ruler3}" "${sut3_ruler3}" "${sut1_ruler4}" "${sut2_ruler4}" "${sut3_ruler4}" "${sut1_ruler5}" "${sut2_ruler5}" "${sut3_ruler5}" "${sut1_ruler6}" "${sut2_ruler6}" "${sut3_ruler6}" "${sut1_ruler7}" "${sut2_ruler7}" "${sut3_ruler7}" "${sut1_ruler8}" "${sut2_ruler8}" "${sut3_ruler8}" "${sut1_ruler9}" "${sut2_ruler9}" "${sut3_ruler9}" "${sut1_ruler10}" "${sut2_ruler10}" "${sut3_ruler10}" "${sut1_ruler11}" "${sut2_ruler11}" "${sut3_ruler11}" "${sut1_ruler12}" "${sut2_ruler12}" "${sut3_ruler12}" "${sut1_ruler13}" "${sut2_ruler13}" "${sut3_ruler13}" "${sut1_ruler14}" "${sut2_ruler14}" "${sut3_ruler14}" "${sut1_ruler15}" "${sut2_ruler15}" "${sut3_ruler15}" "${sut1_ruler16}" "${sut2_ruler16}" "${sut3_ruler16}" )
			for val in ${value[@]}
			do
				echo -n ",${val}" |tee -a ${path}/Total_Storage.csv
			done
			echo -e "" |tee -a ${path}/Total_Storage.csv
			time_num=$(($time_num+1))
			sut1_inlet_num=$(($sut1_inlet_num+1))
			sut1_ruler_num=$(($sut1_ruler_num+1))
			sut2_inlet_num=$(($sut2_inlet_num+1))
			sut2_ruler_num=$(($sut2_ruler_num+1))
			sut3_inlet_num=$(($sut3_inlet_num+1))
			sut3_ruler_num=$(($sut3_ruler_num+1))
			total_time_num=`awk '{print NR}' ${path}/time.log|tail -n1`
			total_sut1_inlet_num=`awk '{print NR}' ${path}/22U_F5_SYS_INLET.log|tail -n1`
			total_sut2_inlet_num=`awk '{print NR}' ${path}/26U_F4_SYS_INLET.log|tail -n1`
			total_sut3_inlet_num=`awk '{print NR}' ${path}/29U_F6_SYS_INLET.log|tail -n1`
			total_sut1_ruler1_num=`awk '{print NR}' ${path}/22U_F5_SSD1.log|tail -n1`
			total_sut1_ruler2_num=`awk '{print NR}' ${path}/22U_F5_SSD2.log|tail -n1`
			total_sut1_ruler3_num=`awk '{print NR}' ${path}/22U_F5_SSD3.log|tail -n1`
			total_sut1_ruler4_num=`awk '{print NR}' ${path}/22U_F5_SSD4.log|tail -n1`
			total_sut1_ruler5_num=`awk '{print NR}' ${path}/22U_F5_SSD5.log|tail -n1`
			total_sut1_ruler6_num=`awk '{print NR}' ${path}/22U_F5_SSD6.log|tail -n1`
			total_sut1_ruler7_num=`awk '{print NR}' ${path}/22U_F5_SSD7.log|tail -n1`
			total_sut1_ruler8_num=`awk '{print NR}' ${path}/22U_F5_SSD8.log|tail -n1`
			total_sut1_ruler9_num=`awk '{print NR}' ${path}/22U_F5_SSD9.log|tail -n1`
			total_sut1_ruler10_num=`awk '{print NR}' ${path}/22U_F5_SSD10.log|tail -n1`
			total_sut1_ruler11_num=`awk '{print NR}' ${path}/22U_F5_SSD11.log|tail -n1`
			total_sut1_ruler12_num=`awk '{print NR}' ${path}/22U_F5_SSD12.log|tail -n1`
			total_sut1_ruler13_num=`awk '{print NR}' ${path}/22U_F5_SSD13.log|tail -n1`
			total_sut1_ruler14_num=`awk '{print NR}' ${path}/22U_F5_SSD14.log|tail -n1`
			total_sut1_ruler15_num=`awk '{print NR}' ${path}/22U_F5_SSD15.log|tail -n1`
			total_sut1_ruler16_num=`awk '{print NR}' ${path}/22U_F5_SSD16.log|tail -n1`
			total_sut2_ruler1_num=`awk '{print NR}' ${path}/26U_F4_SSD1.log|tail -n1`
			total_sut2_ruler2_num=`awk '{print NR}' ${path}/26U_F4_SSD2.log|tail -n1`
			total_sut2_ruler3_num=`awk '{print NR}' ${path}/26U_F4_SSD3.log|tail -n1`
			total_sut2_ruler4_num=`awk '{print NR}' ${path}/26U_F4_SSD4.log|tail -n1`
			total_sut2_ruler5_num=`awk '{print NR}' ${path}/26U_F4_SSD5.log|tail -n1`
			total_sut2_ruler6_num=`awk '{print NR}' ${path}/26U_F4_SSD6.log|tail -n1`
			total_sut2_ruler7_num=`awk '{print NR}' ${path}/26U_F4_SSD7.log|tail -n1`
			total_sut2_ruler8_num=`awk '{print NR}' ${path}/26U_F4_SSD8.log|tail -n1`
			total_sut2_ruler9_num=`awk '{print NR}' ${path}/26U_F4_SSD9.log|tail -n1`
			total_sut2_ruler10_num=`awk '{print NR}' ${path}/26U_F4_SSD10.log|tail -n1`
			total_sut2_ruler11_num=`awk '{print NR}' ${path}/26U_F4_SSD11.log|tail -n1`
			total_sut2_ruler12_num=`awk '{print NR}' ${path}/26U_F4_SSD12.log|tail -n1`
			total_sut2_ruler13_num=`awk '{print NR}' ${path}/26U_F4_SSD13.log|tail -n1`
			total_sut2_ruler14_num=`awk '{print NR}' ${path}/26U_F4_SSD14.log|tail -n1`
			total_sut2_ruler15_num=`awk '{print NR}' ${path}/26U_F4_SSD15.log|tail -n1`
			total_sut2_ruler16_num=`awk '{print NR}' ${path}/26U_F4_SSD16.log|tail -n1`
			total_sut3_ruler1_num=`awk '{print NR}' ${path}/29U_F6_SSD1.log|tail -n1`
			total_sut3_ruler2_num=`awk '{print NR}' ${path}/29U_F6_SSD2.log|tail -n1`
			total_sut3_ruler3_num=`awk '{print NR}' ${path}/29U_F6_SSD3.log|tail -n1`
			total_sut3_ruler4_num=`awk '{print NR}' ${path}/29U_F6_SSD4.log|tail -n1`
			total_sut3_ruler5_num=`awk '{print NR}' ${path}/29U_F6_SSD5.log|tail -n1`
			total_sut3_ruler6_num=`awk '{print NR}' ${path}/29U_F6_SSD6.log|tail -n1`
			total_sut3_ruler7_num=`awk '{print NR}' ${path}/29U_F6_SSD7.log|tail -n1`
			total_sut3_ruler8_num=`awk '{print NR}' ${path}/29U_F6_SSD8.log|tail -n1`
			total_sut3_ruler9_num=`awk '{print NR}' ${path}/29U_F6_SSD9.log|tail -n1`
			total_sut3_ruler10_num=`awk '{print NR}' ${path}/29U_F6_SSD10.log|tail -n1`
			total_sut3_ruler11_num=`awk '{print NR}' ${path}/29U_F6_SSD11.log|tail -n1`
			total_sut3_ruler12_num=`awk '{print NR}' ${path}/29U_F6_SSD12.log|tail -n1`
			total_sut3_ruler13_num=`awk '{print NR}' ${path}/29U_F6_SSD13.log|tail -n1`
			total_sut3_ruler14_num=`awk '{print NR}' ${path}/29U_F6_SSD14.log|tail -n1`
			total_sut3_ruler15_num=`awk '{print NR}' ${path}/29U_F6_SSD15.log|tail -n1`
			total_sut3_ruler16_num=`awk '{print NR}' ${path}/29U_F6_SSD16.log|tail -n1`
			if [ ${time_num} -ge ${total_time_num} ] && [ ${sut1_inlet_num} -ge ${total_sut1_inlet_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler1_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler2_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler3_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler4_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler5_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler6_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler7_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler8_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler9_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler10_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler11_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler12_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler13_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler14_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler15_num} ] && [ ${sut1_ruler_num} -ge ${total_sut1_ruler16_num} ] && [ ${sut2_inlet_num} -ge ${total_sut2_inlet_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler1_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler2_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler3_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler4_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler5_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler6_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler7_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler8_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler9_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler10_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler11_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler12_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler13_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler14_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler15_num} ] && [ ${sut2_ruler_num} -ge ${total_sut2_ruler16_num} ] && [ ${sut3_inlet_num} -ge ${total_sut3_inlet_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler1_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler2_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler3_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler4_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler5_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler6_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler7_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler8_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler9_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler10_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler11_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler12_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler13_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler14_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler15_num} ] && [ ${sut3_ruler_num} -ge ${total_sut3_ruler16_num} ]
				then
					break
			fi
		done
		
		#===================================Remove log===================================
		rm -f ${path}/time.log
		Storage_folder=( "22U_F5" "26U_F4" "29U_F6" )
		for Storage_path in ${Storage_folder[@]}
		do
			rm -f ${path}/${Storage_path}_SYS_INLET.log
			for ((i=1;i<=16;i++));
			do
				rm -f ${path}/${Storage_path}_SSD${i}.log
			done
		done
	;;
esac
