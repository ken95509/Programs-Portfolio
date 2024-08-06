# Filename: Stress_test.py
# Purpose:  For stress test
# Author: Jack Chang

import os, time, datetime, threading, shutil

def execCmd(cmd):
	r = os.popen(cmd)
	text = r.read()
	r.close()
	return text

def sel():
    datetime_dt = datetime.datetime.today()
    datetime_str = datetime_dt.strftime("%Y.%m.%d_%H%M%S")
    #===============sel_util===============
    with open (r'C:\Users\Administrator\Desktop\log\sel_util.txt', 'a', encoding='UTF-8') as sel_util:
        print("=====================\n" + datetime_str, file=sel_util)
        sel_util.write(execCmd(r'C:\Users\Administrator\Desktop\accycle\reboot\ipmiutil\util\ipmiutil.exe sel'))
        print("\n", file=sel_util)
    #===============sel===============
    with open (r'C:\Users\Administrator\Desktop\log\sel.txt', 'a', encoding='UTF-8') as sel:
        print("=====================\n" + datetime_str, file=sel)
        sel.write(execCmd(r'C:\Users\Administrator\Desktop\accycle\reboot\"ipmitool 1.8.11 wmi"\ipmitool.exe -I wmi sel elist'))
        print("\n", file=sel)
    #===============sel_vvv===============
    with open (r'C:\Users\Administrator\Desktop\log\sel_vvv.txt', 'a', encoding='UTF-8') as sel_vvv:
        print("=====================\n" + datetime_str, file=sel_vvv)
        sel_vvv.write(execCmd(r'C:\Users\Administrator\Desktop\accycle\reboot\"ipmitool 1.8.11 wmi"\ipmitool.exe -I wmi -vvv sel elist'))
        print("\n", file=sel_vvv)
  
def log():
    sel()
    i = 64
    for counter in range(i):
        datetime_dt = datetime.datetime.today()
        datetime_str = datetime_dt.strftime("%Y.%m.%d_%H%M%S")
        #===============pci===============   
        with open (r'C:\Users\Administrator\Desktop\log\pci.txt', 'a', encoding='UTF-8') as pci:
            print("=====================\n" + datetime_str, file=pci)
            pci.write(execCmd(r'C:\Switchtec\switchtec status switchtec0'))
            # pci.write(execCmd(r'C:\Switchtec\switchtec status switchtec1'))
            print("\n", file=pci)
        #===============Smart===============
        with open (r'C:\Users\Administrator\Desktop\log\Smartex.txt', 'a', encoding='UTF-8') as smart:
            print("=====================\n" + datetime_str, file=smart)
            for n in range(2,10):
                smart.write('Ruler#%s\n' % n)
                smart.write(execCmd(r"C:\issdcm\issdcm.exe -drive_index %s -get_log 2" % n))
                print("\n", file=smart)
            print("\n", file=smart)
        #===============sdr===============
        with open (r'C:\Users\Administrator\Desktop\log\sdr.txt', 'a', encoding='UTF-8') as sdr:
            print("=====================\n" + datetime_str, file=sdr)
            sdr.write(execCmd(r'C:\Users\Administrator\Desktop\accycle\reboot\"ipmitool 1.8.11 wmi"\ipmitool.exe -I wmi sdr'))
            print("\n", file=sdr)
        time.sleep(300)
    sel()
    #===============sel clear===============
    os.system(r'C:\Users\Administrator\Desktop\accycle\reboot\"ipmitool 1.8.11 wmi"\ipmitool.exe -I wmi sel clear')

def diskspd():
    os.system("C:\\Users\\Administrator\\Desktop\\Diskspd\\diskspd.exe -b128k -w0 -d19200 -L -h -o4 -t4  #2 #3 #4 #5 #6 #7 #8 #9 >> C:\\Users\\Administrator\\Desktop\\log\\Stress_ruler.txt")

#===============Run Pre Test===============
os.system('PowerShell -Command ".  C:\\WcsTest\\Scripts\\wcsScripts.ps1;Pre-WCSTest -ResultsDirectory Reliability_SW')

#===============Run Diskspd===============
threadObj = threading.Thread (target=diskspd)
threadObj.start()
time.sleep(1)

#===============Capture system log===============
log()

#===============Run Post Test===============
os.system('PowerShell -Command ".  C:\\WcsTest\\Scripts\\wcsScripts.ps1;Post-WCSTest -ResultsDirectory Reliability_SW')

#===============Create folder of system time===============
datetime_dt = datetime.datetime.today()
datetime_str = datetime_dt.strftime("%Y.%m.%d_%H%M%S")
os.mkdir("C://Users//Administrator//Desktop//log//%s" % datetime_str)

#===============Move files===============
time.sleep(600)
files = ['Stress_ruler.txt', 'Smartex.txt', 'pci.txt', 'sdr.txt', 'sel.txt', 'sel_util.txt', 'sel_vvv.txt']
for files in files:
    if os.path.exists(("%s") % files):
        shutil.move("C:\\Users\\Administrator\\Desktop\\log\\%s" % (files), "C:\\Users\\Administrator\\Desktop\\log\\%s" % (datetime_str))
shutil.move("C:\\WcsTest\\Results\\Reliability_SW", "C:\\Users\\Administrator\\Desktop\\log\\%s" % (datetime_str))
time.sleep(300)

#===============System shutdown===============
os.system("shutdown -s")