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


function check-ifstatus() {
FOUND=`grep "eth0:\|wlan0:\|wlan1:\|usb0" /proc/net/dev`
    if  [ -n "$FOUND" ] ; then
      label$FOUND=""
    fi
}



borderColor=35
headerLeafColor=32
headerRaspberryColor=31
greetingsColor=36
statsLabelColor=33

borderLine="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
borderTopLine=$(color $borderColor "┏$borderLine┓")
borderBottomLine=$(color $borderColor "┗$borderLine┛")
borderBar=$(color $borderColor "┃")
borderEmptyLine="$borderBar                                                                              $borderBar"

# Header
header="$borderTopLine\n$borderEmptyLine\n"
header="$header$borderBar$(color $headerLeafColor "          .~~.   .~~.                                                         ")$borderBar\n"
header="$header$borderBar$(color $headerLeafColor "         '. \ ' ' / .'                                                        ")$borderBar\n"
header="$header$borderBar$(color $headerRaspberryColor "          .~ .~~~..~.                      _                          _       ")$borderBar\n"
header="$header$borderBar$(color $headerRaspberryColor "         : .~.'~'.~. :     ___ ___ ___ ___| |_ ___ ___ ___ _ _    ___|_|      ")$borderBar\n"
header="$header$borderBar$(color $headerRaspberryColor "        ~ (   ) (   ) ~   |  _| .'|_ -| . | . | -_|  _|  _| | |  | . | |      ")$borderBar\n"
header="$header$borderBar$(color $headerRaspberryColor "       ( : '~'.~.'~' : )  |_| |__,|___|  _|___|___|_| |_| |_  |  |  _|_|      ")$borderBar\n"
header="$header$borderBar$(color $headerRaspberryColor "        ~ .~ (   ) ~. ~               |_|                 |___|  |_|          ")$borderBar\n"
header="$header$borderBar$(color $headerRaspberryColor "         (  : '~' :  )                                                        ")$borderBar\n"
header="$header$borderBar$(color $headerRaspberryColor "          '~ .~~~. ~'                                                         ")$borderBar\n"
header="$header$borderBar$(color $headerRaspberryColor "              '~'                                                             ")$borderBar"

me=$(whoami)

# Greetings
greetings="$borderBar$(color $greetingsColor "$(center "Welcome back, $me!")")$borderBar\n"
greetings="$greetings$borderBar$(color $greetingsColor "$(center "$(date +"%A, %d %B %Y, %T")")")$borderBar"

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
label1="$borderBar  $(color $statsLabelColor "Last Login....:") $label1$borderBar"

uptime="$(sec2time $(cut -d "." -f 1 /proc/uptime))"
uptime="$uptime ($(date -d "@"$(grep btime /proc/stat | cut -d " " -f 2) +"%d-%m-%Y %H:%M:%S"))"

label2="$(extend "$uptime")"
label2="$borderBar  $(color $statsLabelColor "Uptime........:") $label2$borderBar"

label3="$(extend "$(free -m | awk 'NR==2 { printf "Total: %sMB, Used: %sMB, Free: %sMB",$2,$3,$4; }')")"
label3="$borderBar  $(color $statsLabelColor "Memory........:") $label3$borderBar"

label4="$(extend "$(df -h ~ | awk 'NR==2 { printf "Total: %sB, Used: %sB, Free: %sB",$2,$3,$4; }')")"
label4="$borderBar  $(color $statsLabelColor "Home space....:") $label4$borderBar"

label5="$(extend "$(/opt/vc/bin/vcgencmd measure_temp | cut -c "6-9")ºC")"
label5="$borderBar  $(color $statsLabelColor "Temperature...:") $label5$borderBar"

labeleth0="$(extend "$(ifconfig eth0 | grep "inet ad" | cut -f2 -d: | awk '{print $1}')")"
labeleth0="$borderBar  $(color $statsLabelColor "IP of eth0....:") $labeleth0$borderBar"

labelwlan0="$(extend "$(ifconfig wlan0 | grep "inet ad" | cut -f2 -d: | awk '{print $1}')")"
labelwlan0="$borderBar  $(color $statsLabelColor "IP of wlan0...:") $labelwlan0$borderBar"

labelwlan1="$(extend "$(ifconfig wlan1 | grep "inet ad" | cut -f2 -d: | awk '{print $1}')")"
labelwlan1="$borderBar  $(color $statsLabelColor "IP of wlan1...:") $labelwlan1$borderBar"

labelusb0="$(extend "$(ifconfig usb0 | grep "inet ad" | cut -f2 -d: | awk '{print $1}')")"
labelusb0="$borderBar  $(color $statsLabelColor "IP of usb0....:") $labelusb0$borderBar"

label10="$(extend "$(wget -q -O - http://icanhazip.com/ | tail)")"
label10="$borderBar  $(color $statsLabelColor "IP of WAN.....:") $label10$borderBar"

stats="$label1\n$label2\n$label3\n$label4\n$label5\n$labeleth0\n$labelwlan0\n$labelwlan1\n$labelusb0\n$label10"


# Print motd

#check-ifstatus
echo -e "$header\n$borderEmptyLine\n$greetings\n$borderEmptyLine\n$stats\n$borderEmptyLine\n$borderBottomLine"
