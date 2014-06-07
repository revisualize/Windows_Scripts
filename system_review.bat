SET SYS_ROOT=%systemroot:~0,2%
%systemroot:~0,2%
cd\
IF NOT EXIST \sys_review (
        MD sys_review
        )


IF "%time:~0,1%" == " " (SET SYS_TIMEHOUR=0%time:~1,1%) ELSE (SET SYS_TIMEHOUR=%time:~0,2%)

REM This is to note when the script was started
SET SYS_DATETIME=%date:~10,4%.%date:~4,2%.%date:~7,2%_%SYS_TIMEHOUR%.%time:~3,2%

REM Set the location of the logfile
SET SYS_LOGFILE=.\sys_review\%computername%___%SYS_DATETIME%


echo %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%.txt
echo [LOCAL ACCOUNTS] >> %SYS_LOGFILE%.txt
net users >> %SYS_LOGFILE%.txt
echo [CURRENT USER SESSIONS] >> %SYS_LOGFILE%.txt
qwinsta >> %SYS_LOGFILE%.txt



REM network info, arp tables, open connections, and firewall status

echo %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-localnet.txt
echo [IPCONFIG /ALL] >> %SYS_LOGFILE%-localnet.txt
ipconfig /all >> %SYS_LOGFILE%-localnet.txt
echo [GETMAC] >> %SYS_LOGFILE%-localnet.txt
getmac >> %SYS_LOGFILE%-localnet.txt
echo [IPCONFIG /DISPLAYDNS] >> %SYS_LOGFILE%-localnet.txt
ipconfig /displaydns >> %SYS_LOGFILE%-localnet.txt
echo [ARP -A] >> %SYS_LOGFILE%-localnet.txt
arp -a >> %SYS_LOGFILE%-localnet.txt
echo [NETSTAT] >> %SYS_LOGFILE%-localnet.txt
netstat -ano >> %SYS_LOGFILE%-localnet.txt
netstat -r >> %SYS_LOGFILE%-localnet.txt
echo [NETSH SHOW HELPER] >> %SYS_LOGFILE%-localnet.txt
netsh show helper >> %SYS_LOGFILE%-localnet.txt
echo [FIREWALL STATE] >> %SYS_LOGFILE%-localnet.txt
netsh firewall show state >> %SYS_LOGFILE%-localnet.txt
netsh firewall show service >> %SYS_LOGFILE%-localnet.txt
echo END %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-localnet.txt



type %systemroot%\system32\drivers\etc\hosts >> %SYS_LOGFILE%-hosts.txt



REM SYSTEM INFORMATION
echo %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-system.txt
echo [SYSTEM INFORMATION] >> %SYS_LOGFILE%-system.txt
systeminfo >> %SYS_LOGFILE%-system.txt
echo [SET VARIABLES] >> %SYS_LOGFILE%-system.txt
set >> %SYS_LOGFILE%-system.txt
echo [BOOT CONFIGURATION] >> %SYS_LOGFILE%-system.txt
bootcfg /query >> %SYS_LOGFILE%-system.txt
echo [TASKLIST] >> %SYS_LOGFILE%-system.txt
tasklist >> %SYS_LOGFILE%-system.txt
echo [SERVICES STATE] >> %SYS_LOGFILE%-system.txt
sc query state= all >> %SYS_LOGFILE%-system.txt
echo [GROUP POLICIES] >> %SYS_LOGFILE%-system.txt
gpresult >> %SYS_LOGFILE%-system.txt
echo [PAGE FILE CONFIG] >> %SYS_LOGFILE%-system.txt
cscript %windir%\system32\pagefileconfig.vbs /Query /FO list >> %SYS_LOGFILE%-system.txt
echo [OPEN FILES] >> %SYS_LOGFILE%-system.txt
openfiles >> %SYS_LOGFILE%-system.txt
echo END %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-system.txt



REM QUERY ALL THE EVENTS ON THE SYSTEM AND DROP IT INTO ITS OWN LOG FILE
cscript %windir%\system32\eventquery.vbs >> %SYS_LOGFILE%-eventquery.txt



REM directory structure of sytemroot, system and system32
REM echo %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-tree_root.txt
REM tree /F /A %systemroot% >> %SYS_LOGFILE%-tree_systemroot.txt
REM echo END %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-tree_root.txt

echo %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-tree_system.txt
tree /F /A %systemroot%\system >> %SYS_LOGFILE%-tree_system.txt
echo END %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-tree_system.txt

echo %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-tree_system32.txt
tree /F /A %systemroot%\system32 >> %SYS_LOGFILE%-tree_system32.txt
echo END %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-tree_system32.txt



REM DRIVERS INSTALLED ON SYSTEM
echo %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-drivers.txt
echo [DRIVER QUERY] >> %SYS_LOGFILE%-drivers.txt
driverquery >> %SYS_LOGFILE%-drivers.txt
echo  >> %SYS_LOGFILE%-drivers.txt
echo  >> %SYS_LOGFILE%-drivers.txt
echo ---------------------------------------------------- >> %SYS_LOGFILE%-drivers.txt
driverquery /si >> %SYS_LOGFILE%-drivers.txt
echo END %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-drivers.txt



REM PRINTER/SCANNER INFORMATION
echo %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-print_scan.txt
echo [TWAIN DIRECTORY] >> %SYS_LOGFILE%-print_scan.txt
dir %windir%\twain_32 >> %SYS_LOGFILE%-print_scan.txt

echo [PRINTERS] >> %SYS_LOGFILE%-print_scan.txt
cscript %WINDIR%\system32\Prnmngr.vbs -l >> %SYS_LOGFILE%-print_scan.txt
echo [PRINT DRIVERS] >> %SYS_LOGFILE%-print_scan.txt
cscript %WINDIR%\system32\Prnmngr.vbs -l >> %SYS_LOGFILE%-print_scan.txt
echo [PRINTER PORTS] >> %SYS_LOGFILE%-print_scan.txt
cscript %WINDIR%\system32\Prnport.vbs -l >> %SYS_LOGFILE%-print_scan.txt
echo END %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%-print_scan.txt



REM Export the registry of the machine

REM HKEY_LOCAL_MACHINE
reg export HKLM %SYS_ROOT%\%SYS_LOGFILE%-hklm.reg

REM HKEY_CURRENT_USER
reg export HKCU %SYS_ROOT%\%SYS_LOGFILE%-hkcu.reg

REM HKEY_CLASSES_ROOT
reg export HKCR %SYS_ROOT%\%SYS_LOGFILE%-hkcr.reg

REM HKEY_USERS
reg export HKU %SYS_ROOT%\%SYS_LOGFILE%-hku.reg

REM HKEY_CURRENT_CONFIG
reg export HKCC %SYS_ROOT%\%SYS_LOGFILE%-hkcc.reg


REM Add the end that the script was ran to the base file
echo - >> %SYS_LOGFILE%.txt
echo - >> %SYS_LOGFILE%.txt
echo This is when the whole scrip ended: >> %SYS_LOGFILE%.txt
echo END %date:~10,4%/%date:~4,2%/%date:~7,2% - %time% >> %SYS_LOGFILE%.txt



REM unsetting SYS_DATETIME, SYS_LOGFILE, SYS_TIMEHOUR and SYS_ROOT
SET SYS_DATETIME=
SET SYS_LOGFILE=
SET SYS_TIMEHOUR=
SET SYS_ROOT=
