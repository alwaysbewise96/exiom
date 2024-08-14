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

create_instance() {
	name="$1"
	image_id="$2"
	size_slug="$3"
	region="$4"
	boot_script="$5"
  sshkey="$(cat "$base_dir/exiom.json" | jq -r '.sshkey')"
  sshkey_fingerprint="$(ssh-keygen -l -E md5 -f ~/.ssh/$sshkey.pub | awk '{print $2}' | cut -d : -f 2-)"

  keyid=$(cat ~/.ssh/exiom_rsa | grep "$sshkey_fingerprint" | awk '{ print $1 }')
  curl -LO https://partner-images.canonical.com/core/focal/current/ubuntu-focal-core-cloudimg-amd64-root.tar.gz
  wsl --import MyUbuntu C:\WSL\MyUbuntu ubuntu-focal-core-cloudimg-amd64-root.tar.gz --version 2
  wsl -d MyExiom

  sleep 260
}

instance_ip() {
	name="$1"
	instances | jq -r ".[]? | select(.name==\"$name\") | .networks.v4[]? | select(.type==\"public\") | .ip_address" | head -1
}