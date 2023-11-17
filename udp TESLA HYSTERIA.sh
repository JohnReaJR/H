#!/bin/bash
# UDP Hysteria menu By Tesla SS
dmain=$(cat domain.txt)
source <(curl -sSL 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/module')
# [MAIN MENU]

#DOMAIN SETTINGS
set_domain() {
  clear
  echo ""
  print_center -ama "PLEASE SPECIFY A DOMAIN/Subdomain"
  print_center -ama "(Press enter to Skip if you dont have one)"
  echo "Your Current Domain:  $dmain"
  msg -bar3
  echo ""
  read -p "DOMAIN: " domain
  echo ""
  if [ -z "$domain" ]; then
    echo "You did not enter a domain"
    sleep 1
    echo "Your Default Server IP will be exposed"
    sleep 3
    menu_main
  else
    echo "You entered $domain" 
      echo "$domain" > domain.txt
      echo " Reboot system to apply changes"
      menu_main
  fi
}
remove_dom() {
  rm -rf domain.txt
  echo "domain removed"
  sleep 3
  menu_main
}

# [Tweak UDP Speed]
tweak_udp_speed() {
  # WARNING!!!
  clear
  echo ""
  msg -bar
  echo "$(msg -verm2 "${a3:-  DONT OVER DO IT}")"
  sleep 2
  echo "$(msg -verm2 "${a8:-  ⇢ patching...}")"
  sleep 2
  # Turn off TCP Timestamps to improve UDP throughput
  echo 0 >/proc/sys/net/ipv4/tcp_timestamps

  # Increase the maximum amount of memory available for network buffers
  echo 4194304 >/proc/sys/net/core/wmem_max
  echo 4194304 >/proc/sys/net/core/rmem_max

  # Increase the default network buffer sizes
  echo 16384 87380 16777216 >/proc/sys/net/ipv4/tcp_wmem
  echo 16384 87380 16777216 >/proc/sys/net/ipv4/tcp_rmem

  # Increase the maximum size of the receive buffer queue
  echo 4096 >/proc/sys/net/ipv4/tcp_max_syn_backlog

  # Increase the maximum number of open files per process
  ulimit -n 65535

  # Reboot networking interface
  sudo apt-get install network-manager -y
  sudo systemctl restart hysteria-server.service

  sleep 2
  echo "${a6:-  ⇢ UDP speed has been improved on this Server.}"
  echo "${a6:-  ⇢ Done!}"
  msg -bar0
  sleep 3
}

vps_info() {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  #information
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ip=$(wget -qO- ipinfo.io/ip)
  region=$(wget -qO- ipinfo.io/region)
  isp=$(wget -qO- ipinfo.io/org)
  timezone=$(wget -qO- ipinfo.io/timezone)
  ossys=$(neofetch | grep "OS" | cut -d: -f2 | sed 's/ //g')
  host=$(neofetch | grep "Host" | cut -d: -f2 | sed 's/ //g')
  LOADCPU=$(printf '%-0.00001s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
  kernel=$(neofetch | grep "Kernel" | cut -d: -f2 | sed 's/ //g')
  uptime=$(neofetch | grep "Uptime" | cut -d: -f2 | sed 's/ //g')
  cpu=$(neofetch | grep "CPU" | cut -d: -f2 | sed 's/ //g')
  memory=$(neofetch | grep "Memory" | cut -d: -f2 | sed 's/ //g')
  clear
  title "\033[3;40m${a10:-•UDP Hysteria | Server} by @teslassh•"
  print_center -ama ' Version: ⇢ 2.3'
  print_center -ama ' VPS Info'
  msg -bar
  echo " "
  echo -e "$CLAY  ⇢ IP Address :$NC $ip $NC"
  echo -e "$CLAY  ⇢ Region :$NC $region $NC"
  echo -e "$CLAY  ⇢ ISP :$NC $isp $NC"
  echo -e "$CLAY  ⇢ Date :$NC $(date +%A) $(date +%m-%d-%Y)"
  echo -e "$CLAY  ⇢ Up Time :$NC $uptime $NC"
  echo -e "$CLAY  ⇢ CPU Load :$NC $LOADCPU $NC"
  echo -e "$CLAY  ⇢ Memory :$NC $memory $NC"
  msg -bar0
  enter
}



menu_udp() {
  clear
  hystban_me
  echo ""
  msg -bar
  if [[ $(systemctl is-active hysteria-server) = 'active' ]]; then
    state="\e[1m\e[32m[RUNNING]"
  else
    state="\e[1m\e[31m[OFFLINE]"
  fi
  print_center -teal "${a576:- 🐞PROJEKT - Data Heist 🌐🕸️}"
  msg -bar0
  print_center -ama "${a12:-⌘ HYSTERIA MENU}"
  msg -bar3
  echo -e " $(msg -verd "[1]") $(msg -verm2 '┈➤') $(msg -verd "${a6:-Create User}")"
  echo -e " $(msg -verd "[2]") $(msg -verm2 '┈➤') $(msg -verm2 "${a7:-Remove User}")"
  #echo -e " $(msg -verd "[3]") $(msg -verm2 '┈➤') $(msg -ama "${a8:-Renew User}")"
 # echo -e " $(msg -verd "[4]") $(msg -verm2 '┈➤') $(msg -blu "${a9:-Freeze/Unfreeze User}")"
  echo -e " $(msg -verd "[5]") $(msg -verm2 '┈➤') $(msg -verm3 "${a10:-User Details}")"
 # echo -e " $(msg -verd "[6]") $(msg -verm2 '┈➤') $(msg -teal "${a11:-Limit Accounts}")"
  echo -e " $(msg -verd "[7]") $(msg -verm2 '┈➤') $(msg -azu "${a2:-Hysteria is:}") $state"
  msg -bar3
  back
  # option=$(selection_fun $num)
  read -p " ⇢  Enter your selection: " option

  case $option in
  1) new_user ;;
 # 22) reset_udp_custom ;;
  2) remove_user ;;
  #3) renew_user ;;
  #4) block_user ;;
  5) detail_user ;;
  #6) limiter ;;
  0) menu_main ;;
  esac
}

menu_main() {
  # title "\033[3;40m${a10:-• UDP Custom | UDP Request Manager} •"
  #main_title "\033[3;40m${a10:-• UDP Custom Manager} •"
  #print_center -ama 'Version: ⇢ 4.7 '
  #print_center -ama 'by Tesla SSH'
  #msg -bar
  clear
  echo -e " _____ _____ ____  _        _      ____ ____  _   _ "
  echo -e "|_   _| ____/ ___|| |      / \    / ___/ ___|| | | |"
  echo -e "  | | |  _| \___ \| |     / _ \   \___ \___ \| |_| |"
  echo -e "  | | | |___ ___) | |___ / ___ \   ___) |__) |  _  |"
  echo -e "  |_| |_____|____/|_____/_/   \_\ |____/____/|_| |_|"                               
  echo ""
  msg -bar
  # calculate RAM and CPU usage
  ram=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
  cpu=$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')

  # print system information
  print_center -ama " $(msg -verd ' ⇢  IP:') $(msg -azu "$request_public_ip")  $(msg -verd 'Ram:') $(msg -azu "$ram") $(msg -verd 'CPU:') $(msg -azu "$cpu")"
  msg -bar0

  # print options menu
  print_center -ama "${a12:-CHOOSE AN OPTION}"
  msg -bar3
  echo " $(msg -verd "[1]") $(msg -verm2 '>') $(msg -teal "${a6:-UDP Hysteria♞}")"
  echo " $(msg -verd "[2]") $(msg -verm2 '>') $(msg -ama "${a8:-Add Domain/Subdomain}")"
  echo " $(msg -verd "[3]") $(msg -verm2 '>') $(msg -teal "${a11:-Restart Hsteria Core}")"
  echo " $(msg -verd "[4]") $(msg -verm2 '>') $(msg -teal "${a10:-VPS Info🌦️}")"
  echo " $(msg -verd "[99]") $(msg -verm2 '>') $(msg -ama "${a8:-Remove Domain}")"
  #echo " $(msg -verd "[10]") $(msg -verm2 '>') $(msg -verm2 "${a3:-Uninstall UDP Manager}")"
  exit2home

  # prompt user for option selection
  read -p " ⇢  Enter your selection: " option

  # handle option selection
  case $option in
  1)
    menu_udp
    ;;
  2)
    set_domain
    ;;
  3)
    tweak_udp_speed
    ;;
  4)
    vps_info
    ;;
  #10)
   # uninstall_udp_manager
   # ;;
  99)
    remove_dom
    ;;
  0)
    exit
    ;;
  esac
}

while [[ $? -eq 0 ]]; do
  menu_main
done
