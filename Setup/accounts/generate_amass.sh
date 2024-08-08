#!/bin/bash

base_dir="$HOME/.exiom"
source "$base_dir/Interact/Includes/vars.sh"

securitytrails=""

echo -n -e "${Blue}Would you like to generate a custom amass config? y/[n] (default n): ${Color_Off}"
read ans

if [[ "$ans" == "y" ]];
then   
    tmp_config="$base_dir/tmp/$RANDOM"
    cp "$base_dir/configs/config.ini" "$tmp_config"
    echo -e "${Green}${Color_Off}"
    echo -n -e "${Blue}Please enter your securitytrails key:${Color_Off}"
    read securitytrails
    if [[ "$securitytrails" != "" ]]; then
        echo -e "[data_sources.SecurityTrails]\nttl = 1440\n[data_sources.SecurityTrails.Credentials]\napikey = $securitytrails\n" >> "$tmp_config"
    fi
    
    mv "$tmp_config" "$base_dir/configs/config.ini"
fi


