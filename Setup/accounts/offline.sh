#!/bin/bash

base_dir="$HOME/.exiom"
source "$base_dir/Interact/Includes/vars.sh"

type=""
provider=""
communicator=""


function setupoffline(){


echo -e -n "${Green}Please enter to begin your installation: ( press enter ) \n>> ${Color_Off}"
read type
	if [[ "$type" == "" ]]; then
	echo -e "${Blue}Selected default option 'localhost'${Color_Off}"
	type="shell-local"
	fi

data="$(echo "{\"type\":\"$type\",\"communicator\":\"none\",\"provider\":\"offline\"}")"

echo -e "${BGreen}Profile settings below: ${Color_Off}"
echo $data | jq
echo -e "${BWhite}Press enter if you want to save these to a new profile, type 'r' if you wish to start again.${Color_Off}"
read ans

if [[ "$ans" == "r" ]];
then
    $0
    exit
fi

echo -e -n "${BWhite}Please enter your profile name (e.g 'personal', must be all lowercase/no specials)\n>> ${Color_Off}"
read title

if [[ "$title" == "" ]]; then
    title="personal"
    echo -e "${Blue}Named profile 'personal'${Color_Off}"
fi

echo "Running offline.sh"
echo $data | jq > "$base_dir/accounts/$title.json"
echo -e "${BGreen}Saved profile '$title' successfully!${Color_Off}"
$base_dir/Interact/exiom-account $title

}

setupoffline