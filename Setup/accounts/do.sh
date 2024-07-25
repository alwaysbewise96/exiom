#!/bin/bash

base_dir="$HOME/.exiom"
source "$base_dir/Interact/Includes/vars.sh"
restart_main="$base_dir/testing_bb.sh"


appliance_name=""
appliance_key=""
appliance_url=""
token=""
region=""
provider=""
size=""
email=""

BASEOS="$(uname)"
case $BASEOS in
'Linux')
    BASEOS='Linux'
    ;;
'FreeBSD')
    BASEOS='FreeBSD'
    alias ls='ls -G'
    ;;
'WindowsNT')
    BASEOS='Windows'
    ;;
'Darwin')
    BASEOS='Mac'
    ;;
'SunOS')
    BASEOS='Solaris'
    ;;
'AIX') ;;
*) ;;
esac

    #Checking doctl before install
    if command -v doctl > /dev/null 2>&1; then
        echo -e "${check_mark} ${LightCyan}doctl already installed${Color_Off}"
    else    
        #Check do has install, if yes then skip installing process and continue. 
        echo -e "${Blue}Installing doctl...${Color_Off}"
        if [[ $BASEOS == "Mac" ]]; then
            brew install doctl
            packer plugins install github.com/digitalocean/digitalocean
        elif [[ $BASEOS == "Linux" ]]; then
            OS=$(lsb_release -i | awk '{ print $3 }')
            if ! command -v lsb_release &> /dev/null; then
                        OS="unknown-Linux"
                        BASEOS="Linux"
            fi
            if [[ $OS == "Arch" ]] || [[ $OS == "ManjaroLinux" ]]; then
                sudo pacman -Syu doctl --noconfirm
            else
                wget -q -O /tmp/doctl.tar.gz https://github.com/digitalocean/doctl/releases/download/v1.66.0/doctl-1.66.0-linux-amd64.tar.gz && tar -xvzf /tmp/doctl.tar.gz && sudo mv doctl /usr/bin/doctl && rm /tmp/doctl.tar.gz
            fi
        fi
    fi

function dosetup(){

echo -e "${BGreen}Sign up for an account using this link for 100\$ free credit: https://m.do.co/c/bd80643300bd\nYou can Obtain a personal access token from: https://cloud.digitalocean.com/account/api/tokens${Color_Off}"
echo -e -n "${Blue}Do you already have a DigitalOcean account? y/n ${Color_Off}"
read acc 

if [[ "$acc" == "n" ]]; then
    echo -e "${Blue}Launching browser with signup page...${Color_Off}"
    if [ $BASEOS == "Mac" ]; then
    open "https://m.do.co/c/bd80643300bd"
    else
    sudo apt install xdg-utils -y
    #xdg-open "https://m.do.co/c/bd80643300bd"
    fi
fi
    max_attempts=3
    attempts=0

	while true; do
        echo -e -n "${Green}Please enter your token (required): \n>> ${Color_Off}"
        read token

        if [[ "$token" == "" ]]; then
            echo -e "${BRed}Please provide a token, your entry contained no input.${Color_Off}"
            continue
        fi

        valid=$(doctl auth init -t "$token" 2>&1 | grep -vi "using token")

        if [[ -z "$valid" ]]; then
            echo -e "${Green}Your token is valid."
            echo -e -n "${Green}Listing available regions with exiom-regions ls \n${Color_Off}"
            doctl compute region list | grep -v false 

            default_region=nyc1
            echo -e -n "${Green}Please enter your default region: (Default '$default_region', press enter) \n>> ${Color_Off}"
            read region
                if [[ "$region" == "" ]]; then
                echo -e "${Blue}Selected default option '$default_region'${Color_Off}"
                region="$default_region"
                fi
                echo -e -n "${Green}Please enter your default size: (Default 's-1vcpu-1gb', press enter) \n>> ${Color_Off}"
                read size
                if [[ "$size" == "" ]]; then
                echo -e "${Blue}Selected default option 's-1vcpu-1gb'${Color_Off}"
                    size="s-1vcpu-1gb"
            fi

            echo -e -n "${Green}Please enter your GPG Recipient Email (for encryption of boxes): (optional, press enter) \n>> ${Color_Off}"
            read email


            data="$(echo "{\"do_key\":\"$token\",\"region\":\"$region\",\"provider\":\"do\",\"default_size\":\"$size\",\"appliance_name\":\"$appliance_name\",\"appliance_key\":\"$appliance_key\",\"appliance_url\":\"$appliance_url\", \"email\":\"$email\"}")"

            echo -e "${BGreen}Profile settings below: ${Color_Off}"
            echo $data | jq
            echo -e "${BGray}Press enter if you want to save these to a new profile, type 'r' if you wish to start again.${Color_Off}"
            read ans

            if [[ "$ans" == "r" ]];
            then
                $0
                exit
            fi

            echo -e -n "${BGray}Please enter your profile name (e.g 'personal', must be all lowercase/no specials)\n>> ${Color_Off}"
            read title

            if [[ "$title" == "" ]]; then
                title="personal"
                echo -e "${Blue}Named profile 'personal'${Color_Off}"
            fi

            echo $data | jq > "$base_dir/accounts/$title.json"
            echo -e "${BGreen}Saved profile '$title' successfully!${Color_Off}"
            $base_dir/Interact/exiom-account $title

        else
            echo -e "${BRed}Failed to authenticate with the provided token.${Color_Off}"
            ((attempts++))

            if [[ $attempts -ge $max_attempts ]]; then
                echo -e "${BRed}Maximun attempts reached.${Color_Off}"
                read -r -p "$(echo -e "${Green}Do you want to restart this process (yes/no)? : ${Color_Off}")" response
                if [[ $response == "yes" ]]; then
                    #echo -e "${BGreen}Skipping this process..${Color_Off}"
                    #dosetup
                    attempts=0 # Reset attempt counter
                    echo -e "${BGreen}Restarting token validation..${Color_Off}"
                else
                    read -r -p "$(echo -e "${Green}Are you want to changes provider (yes/no) : ${Color_Off}")" ans
                    if [[ $ans == "yes" ]];then
                        bash "$base_dir/Interact/exiom-account-setup"
                    else
                        echo "Restarting Your account setup.."
                        exit 0
                    fi
                fi
            fi
        fi
    done
}
dosetup
