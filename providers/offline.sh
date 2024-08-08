#!/bin/bash

base_dir="$HOME/.exiom"
source "$base_dir/Interact/Includes/appliance.sh"
LOG="$base_dir/log.txt"

# takes no arguments, outputs JSON object with instances
instances() {
	wsl list --json
	#wsl linodes list --json | jq '.[] | [.label,.ipv4[],.region,.specs.memory]'
}

instance_id() {
	name="$1"
	instances | jq ".[] | select(.label==\"$name\") | .id"
}

# takes one argument, name of instance, returns raw IP address
instance_ip() {
	name="$1"
	instances | jq -r ".[] | select(.label==\"$name\") | .ipv4[0]"
}

poweron() {
    instance_name="$1"
    wsl boot $(instance_id $instance_name)
}

poweroff() {
    instance_name="$1"
    wsl shutdown $(instance_id $instance_name)
}

reboot(){
    instance_name="$1"
    wsl reboot $(instance_id $instance_name)
}