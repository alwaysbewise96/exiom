#!/bin/bash

base_dir="$HOME/.exiom"
source "$base_dir/Interact/Includes/vars.sh"
restart="$base_dir/testing_bb.sh"

assign_dir(){

    local choice="$1"  # Receive choice from show_menu function
    local Input_dir
    
    # Ask for installation directory
    echo -e -n "${LightBlue}Input installation Directory\n📁 ${Color_Off}"
    read -r Input_dir

	# Clean up Input_dir to remove any double slashes
    Input_dir=$(realpath -m "$Input_dir")
    
    # Check if the directory exists
    if [ -d "$Input_dir" ]; then
        local state
        read -p "Are you sure you want to install to this directory? (Yes/No) " state
        if [[ "$state" =~ [Yy] ]]; then
			
            echo "Legacy: Your installation tools based on the tools that owner provided you can refer to documentation" # don't forget to add your repo
            echo "Axiom: This installation based on github repo https://github.com/pry0cc/axiom/blob/master/images/provisioners/default.json"
            echo "Reconftw: This installation based on github repo on https://github.com/pry0cc/axiom/blob/master/images/provisioners/reconftw.json"
			echo -e "${LightCyan} Proceeding with installation to $Input_dir ${Color_Off}"
            # Initial setup for install tools
            # bash "$running2"
			
        elif [[  "$state" =~ ^[Nn] ]]; then
			echo -e "${BGreen}Installation canceled.${Color_Off}"
            bash "$restart"
        else
            echo "Please check your typing again."
            echo "Available inputs: Yes/Y/yes/y"
        fi		
    else
        echo "Directory $Input_dir doesn't exist."
        assign_dir
		return  # Call a function to handle directory assignment or provide instructions
        # show_menu  # This line should not be here if you want to handle directory assignment first
    fi

	declare_tools "$Input_dir"
}

declare_tools(){
   
Input_dir="$1"
echo -e "This will output to $Input_dir"
local builders
read -p "Please choose option for your desire Installation builders from this options. (Legacy(L)/Axiom(A)/Reconftw(R)) " builders
	case "$builders" in
        "Legacy" | "L")
            install_tools "Legacy" "$Input_dir"
            ;;
        "Axiom" | "A")
            install_tools "Axiom" "$Input_dir"
            ;;
        "Reconftw" | "R")
            install_tools "Reconftw" "$Input_dir"
            ;;
        *)
            echo -e "${BRed}Invalid choice. Please choose from Legacy(L), Axiom(A), or Reconftw(R).${Color_Off}"
            declare_tools "$Input_dir"  # Recursive call to handle invalid input
            ;;
    esac
}

install_tools() {
    pretools="/usr/local/bin"
    pretools_go="/usr/local/go/bin"

    local builder="$1"
    local Input_dir="$2"
	local repo_url

	declare -A Legacy=(
        [lit-bb-hack-tools]="https://github.com/edoardottt/lit-bb-hack-tools.git"
        [Gf-Patterns-Collection]="https://github.com/emadshanab/Gf-Patterns-Collection.git"
	) 
	declare -A Axiom=(
            # Add tools for Axiom if defined
	)
    declare -A Reconftw=(
        [corsy]="https://github.com/s0md3v/Corsy.git"
        [crlfuzz]="https://github.com/dwisiswant0/crlfuzz.git"
    )

 case "$builder" in
        "Legacy")
            # Use the Legacy associative array
            local tools=("${!Legacy[@]}")
            ;;
        "Axiom")
            # Use the Axiom associative array
            local tools=("${!Axiom[@]}")
            ;;
        "Reconftw")
            # Use the Reconftw associative array
            local tools=("${!Reconftw[@]}")
            ;;
        *)
            echo "Invalid builder specified."
            return 1
            ;;
    esac

    # Iterate over selected builder's tools and install them if not already installed
    for tool in "${tools[@]}"; do
        
        case "$builder" in
            "Legacy")
                repo_url="${Legacy[$tool]}"
                #case for each tools you want to iterate through

                ;;
            "Axiom")
                repo_url="${Axiom[$tool]}"
                ;;
            "Reconftw")
                repo_url="${Reconftw[$tool]}"
                # Check if the directory exists, if not, clone the repository
                if [ ! -d "$Input_dir/$tool" ]; then
                    echo -e "${LightCyan}Installing $tool into directory $Input_dir/$tool${Color_Off}"
                    git clone "$repo_url" "$Input_dir/$tool"
                    echo -e "${LightCyan}Successfully cloned $repo_url ${Color_Off}\n"
                elif [ -d "$Input_dir/$tool" ]; then
                    echo -e "${BLGreen}[INFO]${Color_Off} ${BGreen}$tool already exists in folder $Input_dir/$tool${Color_Off}"
                else
                    echo -e "${Bred}Failed to clone $repo_url ${Color_Off}\n"
                    continue     
                fi
                #Your position inside the tools
                cd "$Input_dir/$tool" || continue
                    case $tool in
                        "corsy")
                            pip3 install requests && cd $Input_dir && sudo cp -r corsy "$pretools"
                            ;;
                        "crlfuzz")
                            cd "$Input_dir/$tool/cmd/crlfuzz" && go build . && sudo mv crlfuzz "$pretools_go"
                            ;;
                        *)
                            echo "No additional setup defined for $tool"
                            ;;
                    esac 
                        
                ;; #reconftw  
        esac
    done
}

assign_dir
#declare_tools
#install_tools