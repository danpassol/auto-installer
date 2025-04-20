# This hidden file provides logging and color functions used by all installers.
# Sourced by install.sh and each service script.

# Colors
GREEN='\e[32m'
RED='\e[31m'
BLUE='\e[34m'
ORANGE='\e[38;5;214m'
RESET='\e[0m'

# Logging
log_success() { echo -e "${GREEN}[SUCCESS]${RESET} $1"; }
log_error() { echo -e "${RED}[ERROR]${RESET} $1"; exit 1; }
log_info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
log_step() { echo -e "${ORANGE}$1${RESET}"; }