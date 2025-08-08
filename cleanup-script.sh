#!/bin/bash

# Script: cleanup.sh
# Description: Clean up all resources created for NCC Transit Hub Lab
# Author: Generated from lab instructions

set -e  # Exit on any error

# Load environment variables
source "$(dirname "$0")/variables-env.sh"

echo "========================================="
echo "CLEANUP WARNING"
echo "========================================="
echo "This script will DELETE ALL resources created for the NCC Transit Hub Lab:"
echo "- Virtual Machines"
echo "- VPN Tunnels and Gateways"
echo "- Cloud Routers"
echo "- NCC Hub and Spokes"
echo "- VPC Networks and Subnets"
echo "- Firewall Rules"
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirm

if [[ $confirm != "yes" ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "Starting cleanup process..."

# Function to handle errors and continue cleanup
cleanup_resource() {
    local resource_type=$1
    local resource_name=$2
    local additional_params=$3
    
    echo "Deleting $resource_type: $resource_name"
    if ! gcloud $resource_type delete $resource_name $additional_params --quiet 2>/dev/null; then
        echo "  ⚠️  Failed to delete $resource_name (may not exist)"
    else
        echo "  ✓ Deleted $resource_name"
    fi
}

echo ""
echo "Step 1: Deleting VMs..."
cleanup_resource "compute instances" "$VM_A_NAME" "--zone=$ZONE_1"
cleanup_resource "compute instances" "$VM_B_NAME" "--zone=$ZONE_2"

echo ""
echo "Step 2: Deleting NCC Spokes..."
cleanup_resource "network-connectivity spokes" "$SPOKE_BO1" "--region=$REGION_1"
cleanup_resource "network-connectivity spokes" "$SPOKE_BO2" "--region=$REGION_2"

echo ""
echo "Step 3: Deleting NCC Hub..."
cleanup_resource "network-connectivity hubs" "$NCC_HUB" ""

echo ""
echo "Step 4: Deleting VPN Tunnels..."
cleanup_resource "compute vpn-tunnels" "transit-to-vpc-a-tu1" "--region=$REGION_1"
cleanup_resource "compute vpn-tunnels" "transit-to-vpc-a-tu2" "--region=$REGION_1"
cleanup_resource "compute vpn-tunnels" "vpc-a-to-transit-tu1" "--region=$REGION_1"
cleanup_resource "compute vpn-tunnels" "vpc-a-to-transit-tu2" "--region=$REGION_1"
cleanup_resource "compute vpn-tunnels" "transit-to-vpc-b-tu1" "--region=$REGION_2"
cleanup_resource "compute vpn-tunnels" "transit-to-vpc-b-tu2" "--region=$REGION_2"
cleanup_resource "compute vpn-tunnels" "vpc-b-to-transit-tu1" "--region=$REGION_2"
cleanup_resource "compute vpn-tunnels" "vpc-b-to-transit-tu2" "--region=$REGION_2"

echo ""
echo "Step 5: Deleting VPN Gateways..."
cleanup_resource "compute vpn-gateways" "$VPN_GW_TRANSIT_R1" "--region=$REGION_1"
cleanup_resource "compute vpn-gateways" "$VPN_GW_TRANSIT_R2" "--region=$REGION_2"
cleanup_resource "compute vpn-gateways" "$VPN_GW_VPC_A" "--region=$REGION_1"
cleanup_resource "compute vpn-gateways" "$VPN_GW_VPC_B" "--region=$REGION_2"

echo ""
echo "Step 6: Deleting Cloud Routers..."
cleanup_resource "compute routers" "$ROUTER_TRANSIT_R1" "--region=$REGION_1"
cleanup_resource "compute routers" "$ROUTER_TRANSIT_R2" "--region=$REGION_2"
cleanup_resource "compute routers" "$ROUTER_VPC_A" "--region=$REGION_1"
cleanup_resource "compute routers" "$ROUTER_VPC_B" "--region=$REGION_2"

echo ""
echo "Step 7: Deleting Firewall Rules..."
cleanup_resource "compute firewall-rules" "$FIREWALL_A" ""
cleanup_resource "compute firewall-rules" "$FIREWALL_B" ""

echo ""
echo "Step 8: Deleting VPC Networks..."
cleanup_resource "compute networks" "$VPC_A" ""
cleanup_resource "compute networks" "$VPC_B" ""
cleanup_resource "compute networks" "$VPC_TRANSIT" ""

echo ""
echo "========================================="
echo "Cleanup completed!"
echo "All resources for the NCC Transit Hub Lab have been deleted."
echo "Note: Some resources may take a few minutes to be fully removed from the console."
echo "========================================="
