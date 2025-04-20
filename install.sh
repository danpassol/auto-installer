#!/bin/bash

INSTALLER_DIR=".installers"
VERBOSE=false
INSTALLERS=()

# ======= Include common library =======
source "$(dirname "$0")/.installers/.lib.sh"

# ======= Check if running with sudo =======
if [[ "$EUID" -ne 0 ]]; then
    echo -e "\n\033[1;31m[ERROR]\033[0m This script must be run with sudo or as root."
    echo -e "Please run: \033[1;33msudo $0\033[0m"
    exit 1
fi

# ======= Show menu =======
echo -e "\e[38;5;214m===== Installer Menu =====\e[0m"

i=1
for file in "$INSTALLER_DIR"/*.sh; do
    filename=$(basename "$file")
    [[ "$filename" == .* ]] && continue
    echo "$i) Install ${filename%.sh}"
    INSTALLERS+=("$file")
    ((i++))
done

echo "$i) Exit"

read -p $'\e[34m[QUESTION]\e[0m Select an option [1-'$i']: ' selection

if (( selection == ${#INSTALLERS[@]} + 1 )); then
    log_info "Exiting..."
    exit 0
fi

read -p $'\e[34m[QUESTION]\e[0m Enable verbose output? [y/N]: ' verbose_choice
[[ "$verbose_choice" =~ ^[Yy]$ ]] && VERBOSE=true

# ======= Run the selected installer =======
if [[ "$selection" -ge 1 && "$selection" -lt "$i" ]]; then
    selected_file="${INSTALLERS[$((selection-1))]}"
    log_info "Running installer: $selected_file"
    chmod +x "$selected_file"
    "$selected_file" "$VERBOSE"
else
    log_error "Invalid selection."
fi
