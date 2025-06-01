#!/bin/bash

# Script: 03-setup-vpn-gateways.sh
# Description: Create HA VPN Gateways for NCC Transit Hub Lab
# Author: Generated from lab instructions

set -e  # Exit on any error

# Load environment variables
source "$(dirname "$0")/../configs/variables.env"

echo "========================================="
echo "Setting up HA VPN Gateways"
echo "========================================="

# Create VPN Gateway for vpc-transit in Region 1
echo "Creating VPN Gateway: $VPN_GW_TRANSIT_R1"
gcloud compute vpn-gateways create $VPN_GW_TRANSIT_R1 \
    --network=$VPC_TRANSIT \
    --region=$REGION_1

echo "✓ Created $VPN_GW_TRANSIT_R1 in $REGION_1"

# Create VPN Gateway for vpc-transit in Region 2
echo "Creating VPN Gateway: $VPN_GW_TRANSIT_R2"
gcloud compute vpn-gateways create $VPN_GW_TRANSIT_R2 \
    --network=$VPC_TRANSIT \
    --region=$REGION_2

echo "✓ Created $VPN_GW_TRANSIT_R2 in $REGION_2"

# Create VPN Gateway for vpc-a in Region 1
echo "Creating VPN Gateway: $VPN_GW_VPC_A"
gcloud compute vpn-gateways create $VPN_GW_VPC_A \
    --network=$VPC_A \
    --region=$REGION_1

echo "✓ Created $VPN_GW_VPC_A in $REGION_1"

# Create VPN Gateway for vpc-b in Region 2
echo "Creating VPN Gateway: $VPN_GW_VPC_B"
gcloud compute vpn-gateways create $VPN_GW_VPC_B \
    --network=$VPC_B \
    --region=$REGION_2

echo "✓ Created $VPN_GW_VPC_B in $REGION_2"

# Verify VPN Gateway creation
echo ""
echo "Verifying VPN Gateways..."
echo "VPN Gateways in $REGION_1:"
gcloud compute vpn-gateways list --filter="region:$REGION_1"
echo ""
echo "VPN Gateways in $REGION_2:"
gcloud compute vpn-gateways list --filter="region:$REGION_2"

echo ""
echo "VPN Gateway setup completed successfully!"
echo "========================================="
