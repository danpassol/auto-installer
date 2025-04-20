#!/bin/bash

VERBOSE=$1

# ======= Include common library =======
source "$(dirname "$0")/.lib.sh"

# ======= Main logic =======
set -e
set -o pipefail

run_cmd() {
    local cmd="$1"
    local exit_code

    if [[ "$VERBOSE" == "true" ]]; then
        eval "$cmd"
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            log_error "Command failed: $cmd"
        else
            log_success "Command succeeded: $cmd"
        fi
    else
        eval "$cmd" &> /dev/null
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            log_error "Command failed: $cmd"
        else
            log_success "Command completed!"
        fi
    fi
}


# ======= Check if Docker is already installed =======

if command -v docker &> /dev/null; then
    log_info "Docker is already installed: $(docker --version)"
    log_error "Aborting installation to prevent conflicts."
fi

# ======= Detect Distro =======

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION_CODENAME=$VERSION_CODENAME
else
    log_error "Cannot detect Linux distribution."
fi

log_info "Detected distro: $DISTRO ($VERSION_CODENAME)"

# ======= Only proceed on Ubuntu or Debian =======

if [[ "$DISTRO" != "ubuntu" && "$DISTRO" != "debian" ]]; then
    log_error "Unsupported distro: $DISTRO. This script only supports Ubuntu and Debian."
fi

# ======= Start Installation =======

log_step "[STEP 1] Installing dependencies..."

run_cmd "apt update"

run_cmd "apt install -y ca-certificates curl gnupg lsb-release"

log_step "[STEP 2] Setting up Docker GPG and repo..."

run_cmd "install -m 0755 -d /etc/apt/keyrings"
run_cmd "curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
run_cmd "chmod a+r /etc/apt/keyrings/docker.gpg"

run_cmd "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$DISTRO $VERSION_CODENAME stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null"

log_step "[STEP 3] Updating apt and verifying Docker repo..."

APT_OUTPUT=$(apt update 2>&1)
echo "$APT_OUTPUT" | grep -q "download.docker.com"

if [[ $? -eq 0 ]]; then
    log_success "Verified Docker repo in apt output."
else
    log_error "Docker repo not found after apt update."
fi

log_step "[STEP 4] Installing Docker..."

run_cmd "apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"

log_step "[STEP 5] Verifying Docker installation..."

run_cmd "docker --version"

log_success "Docker installation completed successfully!"

read -p $'\e[34m[QUESTION]\e[0m Do you want to install Portainer (Docker UI)? [y/N]: ' install_portainer

if [[ "$install_portainer" =~ ^[Yy]$ ]]; then
    log_info "Installing Portainer..."
    
    run_cmd "docker volume create portainer_data"
    run_cmd "docker run -d -p 9000:9000 -p 9443:9443 \
        --name portainer \
        --restart=always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v portainer_data:/data \
        portainer/portainer-ce:latest"
    
    log_success "Portainer installed!"
    echo -e "\e[32m[ACCESS]\e[0m Access Portainer via: http://$(hostname -I | awk '{print $1}'):9000"
else
    log_info "Skipping Portainer installation."
fi
