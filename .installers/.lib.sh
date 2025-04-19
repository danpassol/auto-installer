# This hidden file provides logging and color functions used by all installers.
# Sourced by install.sh and each service script.

# Colors
GREEN='\e[32m'
RED='\e[31m'
BLUE='\e[34m'
ORANGE='\e[38;5;214m'
RESET='\e[0m'

# Animations
spinner_active=false
spinner_pid=""

start_spinner() {
    local message="$1"
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    spinner_active=true

    (
        trap '' SIGTERM
        i=0
        while true; do
            printf "\r${ORANGE}%s %s${RESET}" "$message" "${frames[i]}"
            ((i = (i + 1) % ${#frames[@]}))
            sleep 0.1
        done
    ) &
    spinner_pid=$!
    disown "$spinner_pid"  # Detach from current process group
}



stop_spinner() {
    if $spinner_active && [[ -n "$spinner_pid" ]]; then
        kill "$spinner_pid" 2&1>/dev/null
        wait "$spinner_pid" 2>/dev/null
        spinner_active=false
        spinner_pid=""
        tput cnorm  # Show cursor
        printf "\r\033[K"  # Clear spinner line
    fi
}


# Logging
log_success() { echo -e "${GREEN}[SUCCESS]${RESET} $1"; }
log_error() { echo -e "${RED}[ERROR]${RESET} $1"; exit 1; }
log_info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
log_step() { echo -e "${ORANGE}$1${RESET}"; }