#!/bin/bash

# Script: 05-setup-ncc-hub.sh
# Description: Create NCC Hub and Spokes for NCC Transit Hub Lab
# Author: Generated from lab instructions

set -e  # Exit on any error

# Load environment variables
source "$(dirname "$0")/variables-env.sh"

echo "========================================="
echo "Setting up Network Connectivity Center"
echo "========================================="

# Enable Network Connectivity API
echo "Enabling Network Connectivity API..."
gcloud services enable networkconnectivity.googleapis.com

echo "✓ Network Connectivity API enabled"

# Wait for API to be fully enabled
echo "Waiting for API to be ready..."
sleep 10

echo "Step 1: Creating NCC Hub"
gcloud alpha network-connectivity hubs create $NCC_HUB \
    --description="Transit hub for branch office connectivity"

echo "✓ Created NCC hub: $NCC_HUB"

echo "Step 2: Creating spoke for branch office 1 (vpc-a)"
gcloud alpha network-connectivity spokes create $SPOKE_BO1 \
    --hub=$NCC_HUB \
    --description="Branch office 1 spoke" \
    --vpn-tunnel=transit-to-vpc-a-tu1,transit-to-vpc-a-tu2 \
    --region=$REGION_1

echo "✓ Created spoke: $SPOKE_BO1 for branch office 1"

echo "Step 3: Creating spoke for branch office 2 (vpc-b)"
gcloud alpha network-connectivity spokes create $SPOKE_BO2 \
    --hub=$NCC_HUB \
    --description="Branch office 2 spoke" \
    --vpn-tunnel=transit-to-vpc-b-tu1,transit-to-vpc-b-tu2 \
    --region=$REGION_2

echo "✓ Created spoke: $SPOKE_BO2 for branch office 2"

# Verify NCC setup
echo ""
echo "Verifying NCC Hub and Spokes..."
echo "Hub details:"
gcloud alpha network-connectivity hubs describe $NCC_HUB

echo ""
echo "Spokes:"
gcloud alpha network-connectivity spokes list --hub=$NCC_HUB

echo ""
echo "NCC Hub and Spoke setup completed successfully!"
echo "The transit hub is now connecting both branch offices through Google's backbone network."
echo "========================================="
