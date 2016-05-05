#!/bin/bash

clear

function color (){
  echo "\e[$1m$2\e[0m"
}

function extend (){
  local str="$1"
  let spaces=60-${#1}
  while [ $spaces -gt 0 ]; do
    str="$str "
    let spaces=spaces-1
  done
  echo "$str"
}

function center (){
  local str="$1"
  let spacesLeft=(78-${#1})/2
  let spacesRight=78-spacesLeft-${#1}
  while [ $spacesLeft -gt 0 ]; do
    str=" $str"
    let spacesLeft=spacesLeft-1
  done

  while [ $spacesRight -gt 0 ]; do
    str="$str "
    let spacesRight=spacesRight-1
  done

  echo "$str"
}

function sec2time (){
  local input=$1

  if [ $input -lt 60 ]; then
    echo "$input seconds"
  else
    ((days=input/86400))
    ((input=input%86400))
    ((hours=input/3600))
    ((input=input%3600))
    ((mins=input/60))

    local daysPlural="s"
    local hoursPlural="s"
    local minsPlural="s"

    if [ $days -eq 1 ]; then
      daysPlural=""
    fi

    if [ $hours -eq 1 ]; then
      hoursPlural=""
    fi

    if [ $mins -eq 1 ]; then
      minsPlural=""
    fi

    echo "$days day$daysPlural, $hours hour$hoursPlural, $mins minute$minsPlural"
  fi
}

function check-ifstatus() { FOUND=`grep "eth0:\|wlan0:\|wlan1:\|usb0" /proc/net/dev`
    if [ -n "$FOUND" ] ; then
      label$FOUND=""
    fi
}

greetingsColor=36
statsLabelColor=33

# Greetings
greetings="$(color $greetingsColor "$(center "Welcome back!")")"
greetings="$greetings$(color $greetingsColor "$(center "$(date +"%A, %d %B %Y, %T")")")"

# System information
read loginFrom loginIP loginDate loginTime <<< $(last $me | awk 'NR==2 { print $2,$3,$4,$7 }')

# TTY login
if [[ $loginDate == - ]]; then
  loginDate=$loginIP
  loginIP=$loginFrom
fi

if [[ $loginDate == *T* ]]; then
  login="$(date -d $loginDate +"%A, %d %B %Y,") $loginTime ($loginIP)"
else
  # Not enough logins
  login="None"
fi

label1="$(extend "$login")"
label1="$(color $statsLabelColor "Last Login..:") $label1"

uptime="$(sec2time $(cut -d "." -f 1 /proc/uptime))"
uptime="$uptime ($(date -d "@"$(grep btime /proc/stat | cut -d " " -f 2) +"%d-%m-%Y %H:%M:%S"))"

label2="$(extend "$uptime")"
label2="$(color $statsLabelColor "Uptime......:") $label2"

label3="$(extend "$(free -m | awk 'NR==2 { printf "Total: %sMB, Used: %sMB, Free: %sMB",$2,$3,$4; }')")"
label3="$(color $statsLabelColor "Memory......:") $label3"

label4="$(extend "$(df -h ~ | awk 'NR==2 { printf "Total: %sB, Used: %sB, Free: %sB",$2,$3,$4; }')")"
label4="$(color $statsLabelColor "Home space..:") $label4"

label5="$(extend "$(/opt/vc/bin/vcgencmd measure_temp | cut -c "6-9") C")"
label5="$(color $statsLabelColor "Temperature.:") $label5"

labeleth0="$(extend "$(ifconfig eth0 | grep "inet ad" | cut -f2 -d: | awk '{print $1}')")"
labeleth0="$(color $statsLabelColor "IP of eth0..:") $labeleth0"

labelwlan0="$(extend "$(ifconfig wlan0 | grep "inet ad" | cut -f2 -d: | awk '{print $1}')")"
labelwlan0="$(color $statsLabelColor "IP of wlan0.:") $labelwlan0"

labelwlan1="$(extend "$(ifconfig wlan1 | grep "inet ad" | cut -f2 -d: | awk '{print $1}')")"
labelwlan1="$(color $statsLabelColor "IP of wlan1.:") $labelwlan1"

labelusb0="$(extend "$(ifconfig usb0 | grep "inet ad" | cut -f2 -d: | awk '{print $1}')")"
labelusb0="$(color $statsLabelColor "IP of usb0..:") $labelusb0"

labelIPv4="$(extend "$(wget -q -O - http://ipv4.icanhazip.com/ | tail)")"
labelIPv4="$(color $statsLabelColor "WAN IPv4....:") $labelIPv4"

labelIPv6="$(extend "$(wget -q -O - http://ipv6.icanhazip.com/ | tail)")"
labelIPv6="$(color $statsLabelColor "WAN IPv6....:") $labelIPv6"

stats="$label1\n$label2\n$label3\n$label4\n$label5\n$labeleth0\n$labelwlan0\n$labelwlan1\n$labelusb0\n$labelIPv4\n$labelIPv6"

echo -e "\n\n$greetings\n$stats\n"
