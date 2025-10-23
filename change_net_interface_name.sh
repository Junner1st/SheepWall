#!/usr/bin/env sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
    echo "run with root privilege sudo ./change_net_interface_name.sh"
    exec sudo sh "$0" "$@"
fi

printf "(AP) Network interface 1: "
read -r net1
net1_mac=$(cat "/sys/class/net/$net1/address")

printf "(Forwarder/wifi connector) Network interface 2: "
read -r net2
net2_mac=$(cat "/sys/class/net/$net2/address")

rule_dir="/etc/udev/rules.d"
rule_file="${rule_dir}/70-persistent-net.rules"

AP_name="ap0"
FORWARDER_name="forwarder0"

mkdir -p "$rule_dir"

: > "$rule_file"
echo "SUBSYSTEM==\"net\", ACTION==\"add\", ATTR{address}==\"$net1_mac\", NAME=\"$AP_name\"" >> "$rule_file"
echo "SUBSYSTEM==\"net\", ACTION==\"add\", ATTR{address}==\"$net2_mac\", NAME=\"$FORWARDER_name\"" >> "$rule_file"

echo "Network interface $net1 with MAC $net1_mac will be renamed to $AP_name"
echo "Network interface $net2 with MAC $net2_mac will be renamed to $FORWARDER_name"

echo "Reloading udev rules..."
udevadm control --reload-rules
udevadm trigger

printf "Reboot system now? (y/[n]): "
read -r reboot_choice
if [ "$reboot_choice" = "y" ] || [ "$reboot_choice" = "Y" ]; then
    echo "Rebooting system..."
    reboot
else
    echo "Reboot the system later to apply the changes."
fi
