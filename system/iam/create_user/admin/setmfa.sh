#!/bin/bash

# Prompt for IAM username
read -p "Enter IAM username: " IAM_USER

# Check if 'mfacodes' folder exists; if not, create it
[ -d "mfacodes" ] || mkdir "mfacodes"

# Create Virtual MFA device and save output to JSON
aws iam create-virtual-mfa-device --virtual-mfa-device-name "${IAM_USER}_device3" --outfile "mfacodes/${IAM_USER}_mfa_qrcode.png" --bootstrap-method "QRCodePNG" > mfa.json

# Extract serial number from the JSON
SERIAL_NUMBER=$(jq -r '.VirtualMFADevice.SerialNumber' mfa.json)

# Scan QR Code to get secret
SECRET=$(zbarimg --raw "mfacodes/${IAM_USER}_mfa_qrcode.png" | awk -F 'secret=' '{print $2}' | awk -F '&' '{print $1}')

# Generate first OTP
CODE1=$(oathtool --totp -b "$SECRET")

# Notify the user
echo "Sleeping 30 seconds for a new code..."

# Wait for a new 30-second window
sleep 31

# Generate second OTP
CODE2=$(oathtool --totp -b "$SECRET")

# Enable MFA for the user
aws iam enable-mfa-device --user-name "$IAM_USER" --serial-number "$SERIAL_NUMBER" --authentication-code1 "$CODE1" --authentication-code2 "$CODE2"
