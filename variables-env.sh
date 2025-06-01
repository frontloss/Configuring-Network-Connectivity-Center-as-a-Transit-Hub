#!/bin/bash
# Environment variables for NCC Transit Hub Lab

# Project Configuration
export PROJECT_ID="your-project-id"  # Replace with your actual project ID
export REGION_1="us-east4"           # Replace with your preferred region 1
export REGION_2="us-west2"           # Replace with your preferred region 2
export ZONE_1="us-east4-a"           # Replace with your preferred zone 1
export ZONE_2="us-west2-a"           # Replace with your preferred zone 2

# Network Configuration
export VPC_TRANSIT="vpc-transit"
export VPC_A="vpc-a"
export VPC_B="vpc-b"

# Subnet Configuration
export SUBNET_A_NAME="vpc-a-sub1-use4"
export SUBNET_A_RANGE="10.20.10.0/24"
export SUBNET_B_NAME="vpc-b-sub1-usw2"
export SUBNET_B_RANGE="10.20.20.0/24"

# Cloud Router Configuration
export ROUTER_TRANSIT_R1="cr-vpc-transit-use4-1"
export ROUTER_TRANSIT_R2="cr-vpc-transit-usw2-1"
export ROUTER_VPC_A="cr-vpc-a-use4-1"
export ROUTER_VPC_B="cr-vpc-b-usw2-1"

# ASN Configuration
export ASN_TRANSIT="65000"
export ASN_VPC_A="65001"
export ASN_VPC_B="65002"

# VPN Gateway Configuration
export VPN_GW_TRANSIT_R1="vpc-transit-gw1-use4"
export VPN_GW_TRANSIT_R2="vpc-transit-gw1-usw2"
export VPN_GW_VPC_A="vpc-a-gw1-use4"
export VPN_GW_VPC_B="vpc-b-gw1-usw2"

# VPN Tunnel Configuration
export SHARED_SECRET="gcprocks"

# VM Configuration
export VM_A_NAME="vpc-a-vm-1"
export VM_B_NAME="vpc-b-vm-1"
export MACHINE_TYPE="e2-medium"
export BOOT_DISK_SIZE="10GB"
export IMAGE_FAMILY="debian-11"
export IMAGE_PROJECT="debian-cloud"

# Firewall Rules
export FIREWALL_A="fw-a"
export FIREWALL_B="fw-b"

# NCC Configuration
export NCC_HUB="transit-hub"
export SPOKE_BO1="bo1"
export SPOKE_BO2="bo2"

# BGP IP Addresses for VPC-A tunnels
export BGP_TRANSIT_A_TU1_IP="169.254.1.1"
export BGP_VPC_A_TU1_IP="169.254.1.2"
export BGP_TRANSIT_A_TU2_IP="169.254.1.5"
export BGP_VPC_A_TU2_IP="169.254.1.6"

# BGP IP Addresses for VPC-B tunnels
export BGP_TRANSIT_B_TU1_IP="169.254.1.9"
export BGP_VPC_B_TU1_IP="169.254.1.10"
export BGP_TRANSIT_B_TU2_IP="169.254.1.13"
export BGP_VPC_B_TU2_IP="169.254.1.14"

echo "Environment variables loaded successfully!"
echo "Project ID: $PROJECT_ID"
echo "Region 1: $REGION_1"
echo "Region 2: $REGION_2"
