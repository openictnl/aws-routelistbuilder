#!/bin/bash

# variables that can be changed
aws_url="https://ip-ranges.amazonaws.com/ip-ranges.json"
aws_region="eu-west-1"
save_location="./routelist.txt"

# static values
info_message="script usage: bash ./convert.sh [-a] [-o dir/loc/filename.txt]"
remove_file=true

send_help()
{
   # Display Help
   echo "Remaps the json values from the aws ip-ranges site into an openvpn format push routelist"
   echo
   echo "Syntax: convert.sh [-o|h|a]"
   echo "flags:"
   echo "-o <to/path.txt>     Overrules the default outlocation in which the file will be saved, defaults to: ${save_location}."
   echo "-a                   Appends to a file, instead of deleting and creation the new one."
   echo
   echo "Script can be started like: ${info_message}"
}

# select the flags on the commandline > the outfile can be overruled by using the -o <outfile flag>.txt
while getopts ':oah' opt; do
  case $opt in
    o) save_location=$opt ;;
    a) remove_file=false ;;
    h) send_help ; exit 1 ;;
    ?) echo "$info_message" >&2 ; exit 1 ;;
  esac
done
shift $(( OPTIND - 1 ))

# test if we should remove the original file, or append to it. Appending can be set with the -a flag (append)
if $remove_file; then
  if test -f "$save_location"; then
    $(rm $save_location)
  fi
fi

# use the ip-ranges json from amazon and read it in as an array with jq, more info @ https://stedolan.github.io/jq/
ip_ranges=$(curl -s "${aws_url}") 
nested_ips=$(jq -r '.prefixes[] | select(.region == "'${aws_region}'").ip_prefix' <<< "${ip_ranges}") 

echo "...starting the conversion of the given IPs"
for ip in $nested_ips
do
    ip_subnetmask=$(ipcalc $ip | awk '/Address/ {print $2} /Netmask/ {print $2}' | tr ' \n' ' ' | xargs;)
    open_vpn_str='push "route '$ip_subnetmask'";'
    echo $open_vpn_str >> $save_location
done
echo "...done!"
