#!/bin/bash

base_dir="$HOME/.exiom"
cloud_install="$base_dir/Interact/exiom-configure"
offline_install="$base_dir/testing_bb2.sh"

Main_menu(){
    echo "1. Installation Tools"
    echo "2. Recon"
    echo "3. Deep Recon"
    echo "4. Exit"
}

show_menu(){
    local choice
    while true; do
        Main_menu
        read -p "Enter your choice : " choice
		#create getops for choice no 1, Legacy & Axiom
        case $choice in
            1) 
                echo "Your choice: Installation Tools"
                install_tools "$choice"  # Pass choice to install_tools function
                ;;
            2)
                echo "Your choice: Recon"
                ;;
            3)
                echo "Your choice: Deep Recon"
                ;;
            4)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid option. Please choose again!"
                ;;
        esac
        echo
    done
}


###########################################################################################################
# Shell setup functions
#
function bash_shell(){
    echo -e "${Blue}Backing up $(echo "$HOME"/.bashrc) to $(echo "$HOME"/.bashrcbak) just in case.${Color_Off}"
    cp "$HOME"/.bashrc "$HOME"/.bashrcbak >> /dev/null 2>&1
    mkdir -p "${HOME}/go"
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
    echo "export GOPATH=\$HOME/go" >> "${HOME}"/.bashrc
    echo "export PATH=\$GOPATH/bin:/usr/local/go/bin:\$PATH:\$HOME/.local/bin" >> "${HOME}"/.bashrc
    source "${HOME}"/.bashrc
    SHELL=$(which bash)
    echo -e "${Green}You're running Bash! Installing exiom to \$PATH...${Color_Off}"
    echo "export PATH=\"\$PATH:\$HOME/.exiom/Interact\"" >>~/.bashrc
    echo "[[ -f ~/.bashrc ]] && . ~/.bashrc" >> "${HOME}"/.bash_profile
    source ~/.bashrc  >> /dev/null 2>&1
}

function zsh_shell(){
    sudo apt install zsh -y
    echo -e "${Blue}Backing up $(echo "$HOME"/.zshrc) to $(echo "$HOME"/.zshrcbak) just in case.${Color_Off}"
    cp "$HOME"/.zshrc "$HOME"/.zshrcbak >> /dev/null 2>&1
    mkdir -p "${HOME}/go"
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
    echo "export GOPATH=\$HOME/go" >>~/.zshrc
    echo "export PATH=\$GOPATH/bin:/usr/local/go/bin:\$PATH:\$HOME/.local/bin"  >>~/.zshrc
    echo -e "${Green}You're running ZSH! Installing exiom to \$PATH...${Color_Off}"
    echo "export PATH=\"\$PATH:\$HOME/.exiom/Interact\"" >>~/.zshrc  
    echo "source $HOME/.exiom/functions/autocomplete.zsh" >>~/.zshrc 
    source "${HOME}"/.zshrc >> /dev/null 2>&1
    SHELL=$(which zsh)
}

function omz_shell(){
    echo -e "${Blue}Backing up $(echo "$HOME"/.zshrc) to $(echo "$HOME"/.zshrcbak) just in case.${Color_Off}"
    cp "$HOME"/.zshrc "$HOME"/.zshrcbak >> /dev/null 2>&1
    sudo apt install zsh zsh-syntax-highlighting zsh-autosuggestions -y
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    mkdir -p "${HOME}/go"
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
    echo "export GOPATH=\$HOME/go" >>~/.zshrc
    echo "export PATH=\$GOPATH/bin:/usr/local/go/bin:\$PATH:\$HOME/.local/bin"  >>~/.zshrc
    echo "export PATH=\$GOPATH/bin:/usr/local/go/bin:\$PATH" >>~/.zshrc
    echo -e "${Green}You're running ZSH! Installing exiom to \$PATH...${Color_Off}"
    echo "export PATH=\"\$PATH:\$HOME/.exiom/Interact\"" >>~/.zshrc  
    echo "source $HOME/.exiom/functions/autocomplete.zsh" >>~/.zshrc   
    source "${HOME}"/.zshrc  >> /dev/null 2>&1
    SHELL=$(which zsh)
}

install_tools(){


###########################################################################################################
# Clone exiom repo

# Check if base directory exists, clone if not
if [ ! -d "$base_dir" ]; then
    echo -e "${Blue}Installing exiom scripts...${Color_Off}"
    git clone https://github.com/alwaysbewise96/exiom "$base_dir"
else
    cd "$base_dir" && git pull
fi

source "$base_dir/Interact/Includes/vars.sh"
	
echo -e "${BWhite}Installing deps! Please wait :) ${Color_Off}"
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

if [[ $BASEOS == "Linux" ]]; then
    if $(uname -a | grep -qi "Microsoft"); then
        OS="UbuntuWSL"
    else
        OS=$(lsb_release -i | awk '{ print $3 }')
        if ! command -v lsb_release &>/dev/null; then
            echo "WARNING: Unless using Ubuntu latest, this install might not work"
            echo "lsb_release could not be found, unable to determine your distribution"
            OS="unknown-Linux"
            BASEOS="Linux"
        fi
    fi
    if [[ $OS == "Arch" ]] || [[ $OS == "ManjaroLinux" ]]; then
        echo -e "${Blue}Congrats, you run arch..."
        echo -e "${Blue}Installing other repo deps...${Color_Off}"
        # Stated dependencies in the Github-wiki
        sudo pacman -Syu git ruby curl jq packer rsync --noconfirm
        # Other dependencies
        sudo pacman -Syu go python-pip net-tools unzip libxslt bc --noconfirm
        echo -e "${Blue}Installing Interlace...${Color_Off}"
        sudo rm -fr /tmp/interlace
        git clone https://github.com/codingo/Interlace.git /tmp/interlace
        cd /tmp/interlace && sudo python3 setup.py install
        echo -e "${BLGreen}[INFO]${Color_Off} ${Green}Done Checking requirements${Color_Off}"

    elif [[ $OS == "Ubuntu" ]] || [[ $OS == "Debian" ]] || [[ $OS == "Linuxmint" ]] || [[ $OS == "Parrot" ]] || [[ $OS == "Kali" ]] || [[ $OS == "unknown-Linux" ]] || [[ $OS == "UbuntuWSL" ]]; then
        if ! command -v sudo &>/dev/null; then
            export DEBIAN_FRONTEND=noninteractive
            #apt-get update && apt-get install sudo curl jq tzdata -y -qq
            #ip=$(curl -s https://ifconfig.me/)
            #ln -fs /usr/share/zoneinfo/$(curl ipinfo.io/"$ip" | jq -r .timezone) /etc/localtime
            #dpkg-reconfigure --frontend noninteractive tzdata

        fi
        echo -e "${BLGreen}[INFO]${Color_Off} ${Blue}Installing other repo deps...${Color_Off}"
        # Add this into requirements tools checking
        #DEBIAN_FRONTEND=noninteractive sudo apt-get update && sudo apt-get install git ruby python3-pip curl lsb-release iputils-ping net-tools unzip xsltproc bc rsync sudo wget nano bsdmainutils openssh-server fail2ban -y
        #ToDo
        #Add testing_bb.sh to parse the tools has been installed
        echo -e "${BLGreen}[INFO]${Color_Off} ${Green}Done Checking requirements${Color_Off}"

    elif [[ $OS == "Fedora" ]]; then
        echo -e "${Blue}Installing other repo deps...${Color_Off}"
        sudo dnf update && sudo dnf -y install mmv bc fzf git rubypick python3-pip curl net-tools unzip util-linux fail2ban
        echo -e "${BLGreen}[INFO]${Color_Off} ${Green}Done Checking requirements${Color_Off}"
    fi
fi

if [[ $BASEOS == "Mac" ]]; then
    echo -e "${Blue}Installing Brew...${Color_Off}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo -e 'Setting permissions'
    sudo chown -R $(whoami) /usr/local/Homebrew
    sudo chown -R $(whoami) /usr/local/var/homebrew
    sudo chown -R $(whoami) /usr/local/etc/bash_completion.d /usr/local/lib/pkgconfig /usr/local/share/aclocal /usr/local/share/doc /usr/local/share/info /usr/local/share/locale /usr/local/share/man /usr/local/share/man/man1 /usr/local/share/man/man3 /usr/local/share/man/man5 /usr/local/share/man/man7
    sudo chown -R $(whoami) /usr/local/share/zsh /usr/local/share/zsh/site-functions
    chmod u w /usr/local/share/zsh /usr/local/share/zsh/site-functions
    chmod u w /usr/local/etc/bash_completion.d /usr/local/lib/pkgconfig /usr/local/share/aclocal /usr/local/share/doc /usr/local/share/info /usr/local/share/locale /usr/local/share/man /usr/local/share/man/man1 /usr/local/share/man/man3 /usr/local/share/man/man5 /usr/local/share/man/man7
    echo -e "${Blue}Installing wget...${Color_Off}"
    brew install wget
    echo -e "${Blue}Installing go...${Color_Off}"
    brew install golang
    mkdir -p "${HOME}/go"
    export GOPATH=$HOME/go
    echo "export GOPATH=$HOME/go" >>~/.zshrc
    echo "export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH:$HOME/.local/bin" >>~/.zshrc
    echo -e "${Green}You're running ZSH! Installing .exiom to $PATH...${Color_Off}"
    echo "export PATH="$PATH:$HOME/.exiom/Interact"" >>~/.zshrc
    echo -e "${Blue}Installing jq...${Color_Off}"
    brew install jq
    echo -e "${Blue}Installing coreutils...${Color_Off}"
    brew install coreutils
    echo -e "${Blue}Installing Python3...${Color_Off}"
    brew install python3
    echo -e "${Blue}Installing Interlace...${Color_Off}"
    sudo rm -fr /tmp/interlace
    git clone https://github.com/codingo/Interlace.git /tmp/interlace
    cd /tmp/interlace && sudo python3 setup.py install
    echo -e "${Blue}Installing packer...${Color_Off}"
    brew tap hashicorp/tap
    brew install hashicorp/tap/packer
    brew upgrade hashicorp/tap/packer
    source "${HOME}"/.zshrc
    SHELL=$(which zsh)
    echo -e "${BLGreen}[INFO]${Color_Off} ${Green}Done Checking requirements${Color_Off}"
fi

if [[ $BASEOS == "Linux" ]]; then
    if [[ $usershell == "omz" ]] || [[ $usershell == 'Oh my zsh' ]] || [[ $usershell == 'Oh My Zsh' ]] || [[ $usershell == "OMZ" ]]; then
        omz_shell
    elif [[ $usershell == "bash" ]] || [[ $usershell == "Bash" ]] || [[ $usershell == "BASH" ]]; then
        bash_shell
    elif [[ $usershell == "zsh" ]] || [[ $usershell == "Zsh" ]] || [[ $usershell == "ZSH" ]]; then
        zsh_shell
    else

        # Pick your shell
        echo -e "${Blue}Choose bash/zsh to add exiom to .bashrc/.zshrc. OMZ installs Oh My Zsh and overwrites .zshrc${Color_Off}"
        PS3="Please select an option : "
        choices=("Bash" "Zsh" 'Oh My Zsh')
        select choice in "${choices[@]}"; do
            case $choice in
            Bash)
                bash_shell
                break
                ;;
            Zsh)
                zsh_shell
                break
                ;;
            'Oh My Zsh')
                omz_shell
                break
                ;;
            esac
        done
    fi
fi


	echo -e "${LightBlue}Checking Requirements Tools"
	
	#Check first before install tools below
	
	pretools_go="/usr/local/go/bin/" #var for Go prerequiresites tools
	pretools="/usr/local/bin/" #var for prerequiresites tools
	echo -e "${LightBlue}This Requirement tools directory : $pretools" 	

	# Check if 'python3' and 'pip3' command exists
	if command -v python3 &> /dev/null; then
		# Check Python version
		echo -e "${check_mark} ${LightCyan}python3 already installed${Color_Off}"
	else
		echo -e "${BRed}Python is not installed. We are installing for you..${Color_Off}"		
		sudo apt install python3 -y && sudo apt install python3-pip -y
		echo -e "${check_mark} ${LightCyan}Python3 is installed.${Color_Off}"		
	fi
	
	#jq
	if command -v jq &> /dev/null; then
		echo -e "${check_mark} ${LightCyan}jq already installed${Color_Off}"
	else
		echo -e "${BRed}jq is not installed. We are installing for you..${Color_Off}"
		sudo apt install jq
		echo -e "${check_mark} ${LightCyan}jq is installed.${Color_Off}"
	fi
	
	# Check if 'Go lang' command exists
	if command -v go &> /dev/null; then
		# Check Go lang version
		echo -e "${check_mark} ${LightCyan}go already installed${Color_Off}"
	else
		echo -e "${BRed}Go is not installed. We are installing for you..${Color_Off}"
		# Continue where you left off
		wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
		sudo tar -C $pretools -xzf go1.22.5.linux-amd64.tar.gz && export GOROOT=$pretools-go && export PATH=$PATH:$GOROOT
		echo -e "${check_mark} ${LightCyan}Go is installed.${Color_Off}"
	fi

	#doctl
	if command -v doctl > /dev/null 2>&1; then
		echo -e "${check_mark} ${LightCyan}doctl already installed${Color_Off}"
	else
		echo -e "${BRed}doctl is not installed. We are installing for you..${Color_Off}"
		sudo apt install doctl > /dev/null 2>&1
		echo -e "${check_mark} ${LightCyan}doctl is installed${Color_Off}"
	fi
	
	#awscli
	if command -v aws > /dev/null 2>&1; then
		echo -e "${check_mark} ${LightCyan}AWS CLI is already installed${Color_Off}"
	else
		echo -e "${BRed}AWS CLI is not installed. We are installing for you..${Color_Off}"
		sudo python3 -m pip3 install awscli > /dev/null 2>&1
		echo -e "${check_mark} ${LightCyan}AWS CLI is installed${Color_Off}"
	fi

	#Linode CLI
	if command -v linode-cli > /dev/null 2>&1; then
		echo -e "${check_mark} ${LightCyan}Linode CLI is already installed${Color_Off}"
	else
		echo -e "${BRed}Linode CLI is not installed. We are installing for you..${Color_Off}"
		sudo pip3 install linode-cli > /dev/null 2>&1
		echo -e "${check_mark} ${LightCyan}Linode CLI is installed${Color_Off}"
	fi

	#Packer
	if command -v packer > /dev/null 2>&1; then
		echo -e "${check_mark} ${LightCyan}Packer is already installed${Color_Off}"
	else
        echo -e "${BRed}Packer is not installed. Installing packer...${Color_Off}"
        wget -q -O /tmp/packer.zip https://releases.hashicorp.com/packer/1.8.1/packer_1.8.1_linux_amd64.zip && cd /tmp/ && unzip packer.zip && sudo mv packer /usr/bin/ && rm /tmp/packer.zip
		echo -e "${check_mark} ${LightCyan}Packer is installed${Color_Off}"
	fi 

	#Interlace 
	if command -v interlace > /dev/null 2>&1; then
		Interlace_check="$(echo -e "${check_mark} ${LightCyan}Interlace is already installed${Color_Off}")"
		echo "$Interlace_check"
	else
        echo -e "${BRed}Interlace is not installed. Installing Interlace...${Color_Off}"
        sudo rm -fr /tmp/interlace
        git clone https://github.com/codingo/Interlace.git /tmp/interlace
        cd /tmp/interlace && sudo python3 setup.py install
		echo -e "${check_mark} ${LightCyan}Interlace is installed${Color_Off}"
	fi

	#Azure-CLI
	if command -v az > /dev/null 2>&1; then
		echo -e "${check_mark} ${LightCyan}Azure-CLI is already installed${Color_Off}"
	else
		echo -e "${BRed}Azure-CLI is not installed. We are installing for you..${Color_Off}"
		sudo sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y -qq > /dev/null 2>&1
		curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
		sudo apt-get install azure-cli -y -qq
		echo -e "${check_mark} ${LightCyan}Azure-CLI is installed${Color_Off}"
	fi

    echo -e "${BLGreen}[INFO]${Color_Off} ${Green}Done Checking requirements${Color_Off}\n"

    echo -e "${LightBlue}Please input your desired choice (Offline for installer tools only or Deploy into cloud with Exiom [(O)ffline/(C)loud])${Color_Off}"
    read -p ">> " desire
    #if local choice continue to install tools instead
    # Processing user choice
    if [[ $desire == "O" || $desire == "offline" ]]; then
        echo -e "${LightBlue}Initiating installation for offline tools only..${Color_Off}"
        bash "$offline_install" # commands for offline installation
    elif [[ $desire == "C" || $desire == "cloud" ]]; then
        echo -e "${LightBlue}Initiating installation into Cloud..${Color_Off}"
        bash "$cloud_install" # commands for cloud deployment
    else
        echo -e "${LightBlue}Not a valid choice.${Color_Off}"
        echo -e "${LightBlue}Please input your desired choice (Offline for installer tools only or Deploy into cloud with Exiom [(O)ffline/(C)loud])${Color_Off}"
        read -p ">> " desire
    fi

}

# Start the menu loop
show_menu
