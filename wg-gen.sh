#!/bin/bash

WG_DIR="/etc/wireguard"
WG_INTERFACE="wg0"
WG_CONFIG="${WG_DIR}/${WG_INTERFACE}.conf"
USER_CONFIG_DIR="${WG_DIR}/users"

# Function to generate WireGuard configuration for a new user
generate_user_config() {
    local username=$1
    local user_dir="${USER_CONFIG_DIR}/${username}"
    local user_private_key=$(wg genkey)
    local user_public_key=$(echo "${user_private_key}" | wg pubkey)
    local user_ip="10.10.10.$(( $(latest_ip)))"

    mkdir -p "${user_dir}"

    # Generate user configuration file
    cat <<EOF > "${user_dir}/${username}.conf"
[Interface]
PrivateKey = ${user_private_key}
Address = ${user_ip}/24
DNS = 10.10.10.1

[Peer]
PublicKey = $(wg show ${WG_INTERFACE} public-key)
Endpoint = $(curl -s ifconfig.me):51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

    # Add user to the server configuration
    cat <<EOF >> "${WG_CONFIG}"

# ${username}
[Peer]
PublicKey = ${user_public_key}
AllowedIPs = ${user_ip}/32
EOF

    # Restart WireGuard to apply changes
    wg-quick down ${WG_INTERFACE}
    wg-quick up ${WG_INTERFACE}

    echo "Configuration for ${username} has been generated and added to the server."
    echo "User configuration file: ${user_dir}/${username}.conf"
}

function latest_ip() {
    local latest_ip=$(grep -oP '10\.10\.10\.\K\d+' ${WG_CONFIG} | sort -n | tail -1)
    # return error if latest ip is 255
    if [[ "${latest_ip}" -eq 255 ]]; then
      echo "The IP range is full."
      exit 1
    fi

    if [[ -z "${latest_ip}" ]]; then
        echo "2"
    else
        echo "${latest_ip} + 1"
    fi
}

# Function to generate QR code for a user's WireGuard configuration
generate_qr_code() {
    local username=$1
    local user_dir="${USER_CONFIG_DIR}/${username}"
    local config_file="${user_dir}/${username}.conf"

    if [[ -f "${config_file}" ]]; then
        qrencode -t ansiutf8 < "${config_file}"
    else
        echo "Configuration file for ${username} does not exist."
        exit 1
    fi
}

# Function to display help
display_help() {
    echo "Usage: $0 {add|qr} -n <username>"
    echo
    echo "Commands:"
    echo "  add -n <username>    Generate a new WireGuard configuration for the specified user."
    echo "  qr -n <username>     Generate a QR code for the specified user's WireGuard configuration."
    echo "  help                 Display this help message."
}

# Main script logic
if [[ "$1" == "add" && "$2" == "-n" && -n "$3" ]]; then
    generate_user_config "$3"
elif [[ "$1" == "qr" && "$2" == "-n" && -n "$3" ]]; then
    generate_qr_code "$3"
elif [[ "$1" == "help" ]]; then
    display_help
else
    display_help
    exit 1
fi