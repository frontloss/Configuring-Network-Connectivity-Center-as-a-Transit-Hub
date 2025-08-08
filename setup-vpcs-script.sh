#!/bin/bash

# Script: 01-setup-vpcs.sh
# Description: Create VPC networks for NCC Transit Hub Lab
# Author: Generated from lab instructions

set -e  # Exit on any error

# Load environment variables
source "$(dirname "$0")/variables-env.sh"

echo "========================================="
echo "Setting up VPC Networks"
echo "========================================="

# Delete default network if it exists
echo "Deleting default network..."
gcloud compute networks delete default --quiet 2>/dev/null || echo "Default network already deleted or doesn't exist"

# Create vpc-transit (Global routing, no subnets)
echo "Creating vpc-transit network..."
gcloud compute networks create $VPC_TRANSIT \
    --subnet-mode=custom \
    --bgp-routing-mode=global

echo "✓ Created vpc-transit with global routing"

# Create vpc-a (Regional routing with subnet)
echo "Creating vpc-a network..."
gcloud compute networks create $VPC_A \
    --subnet-mode=custom \
    --bgp-routing-mode=regional

gcloud compute networks subnets create $SUBNET_A_NAME \
    --network=$VPC_A \
    --region=$REGION_1 \
    --range=$SUBNET_A_RANGE

echo "✓ Created vpc-a with subnet $SUBNET_A_RANGE in $REGION_1"

# Create vpc-b (Regional routing with subnet)
echo "Creating vpc-b network..."
gcloud compute networks create $VPC_B \
    --subnet-mode=custom \
    --bgp-routing-mode=regional

gcloud compute networks subnets create $SUBNET_B_NAME \
    --network=$VPC_B \
    --region=$REGION_2 \
    --range=$SUBNET_B_RANGE

echo "✓ Created vpc-b with subnet $SUBNET_B_RANGE in $REGION_2"

# Verify network creation
echo ""
echo "Verifying VPC networks..."
gcloud compute networks list --filter="name:(vpc-transit OR vpc-a OR vpc-b)"

echo ""
echo "VPC setup completed successfully!"
echo "========================================="
