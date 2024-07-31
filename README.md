# WireGuard Configuration Script

This script is used to generate WireGuard configurations for users and create QR codes for the configurations.

## Installation

```sh
# Download the script from GitHub:  
curl -o wg-gen https://raw.githubusercontent.com/Starlexxx/wireguard-generator/main/wg-gen.sh

# Make the script executable:  
chmod +x wg-gen

# Move the script to a directory in your PATH, for example /usr/local/bin:  
sudo mv wg-gen /usr/local/bin/

# Add the following line to your .bashrc or .bash_profile to ensure the script is in your PATH:  
export PATH=$PATH:/usr/local/bin

# Reload your shell configuration:  
source ~/.bashrc
```

## Usage

```sh
wg-gen {server|add|qr} -n <username>
```

## Commands

```sh
wg-gen server # Install WireGuard and configure the server.
wg-gen add -n <username> # Generate a new WireGuard configuration for the specified user.
wg-gen qr -n <username> # Generate a QR code for the specified user's WireGuard configuration.
wg-gen help # Display the help message.
```

## Examples

### Install WireGuard and configure the server:

```sh
wg-gen server
```

### Generate a WireGuard configuration for a user:

```sh
wg-gen add -n Starlexxx
```

### Generate a QR code for the WireGuard configuration of a user named Andrew:

```sh
wg-gen qr -n Starlexxx
```

## Dependencies

wg: WireGuard command-line tool.
qrencode: Tool to generate QR codes.

Make sure these dependencies are installed and available in your system's PATH.

## Notes

The script assumes that the WireGuard configuration directory is /etc/wireguard.
The WireGuard interface is assumed to be wg0.
User configurations are stored in /etc/wireguard/users.