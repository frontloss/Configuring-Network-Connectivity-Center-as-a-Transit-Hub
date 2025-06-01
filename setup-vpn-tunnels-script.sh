#!/bin/bash

# Script: 04-setup-vpn-tunnels.sh
# Description: Create VPN Tunnels and BGP Sessions for NCC Transit Hub Lab
# Author: Generated from lab instructions

set -e  # Exit on any error

# Load environment variables
source "$(dirname "$0")/../configs/variables.env"

echo "========================================="
echo "Setting up VPN Tunnels and BGP Sessions"
echo "========================================="

# Function to create VPN tunnels
create_vpn_tunnels() {
    local tunnel_name_1=$1
    local tunnel_name_2=$2
    local local_gateway=$3
    local peer_gateway=$4
    local router=$5
    local region=$6
    
    echo "Creating VPN tunnels: $tunnel_name_1 and $tunnel_name_2"
    
    gcloud compute vpn-tunnels create $tunnel_name_1 \
        --peer-gcp-gateway=$peer_gateway \
        --region=$region \
        --ike-version=2 \
        --shared-secret=$SHARED_SECRET \
        --router=$router \
        --vpn-gateway=$local_gateway \
        --interface=0

    gcloud compute vpn-tunnels create $tunnel_name_2 \
        --peer-gcp-gateway=$peer_gateway \
        --region=$region \
        --ike-version=2 \
        --shared-secret=$SHARED_SECRET \
        --router=$router \
        --vpn-gateway=$local_gateway \
        --interface=1
}

# Function to create BGP sessions
create_bgp_session() {
    local router=$1
    local region=$2
    local interface_name=$3
    local peer_ip=$4
    local peer_asn=$5
    local tunnel_name=$6
    local local_ip=$7
    
    echo "Creating BGP interface and session for $tunnel_name"
    
    gcloud compute routers add-interface $router \
        --interface-name=$interface_name \
        --vpn-tunnel=$tunnel_name \
        --region=$region \
        --ip-address=$local_ip \
        --mask-length=30

    gcloud compute routers add-bgp-peer $router \
        --peer-name=$interface_name \
        --interface=$interface_name \
        --peer-ip-address=$peer_ip \
        --peer-asn=$peer_asn \
        --region=$region
}

echo "Step 1: Creating VPN tunnels between vpc-transit and vpc-a"

# Create tunnels from vpc-transit to vpc-a
create_vpn_tunnels "transit-to-vpc-a-tu1" "transit-to-vpc-a-tu2" \
    $VPN_GW_TRANSIT_R1 $VPN_GW_VPC_A $ROUTER_TRANSIT_R1 $REGION_1

# Create tunnels from vpc-a to vpc-transit
create_vpn_tunnels "vpc-a-to-transit-tu1" "vpc-a-to-transit-tu2" \
    $VPN_GW_VPC_A $VPN_GW_TRANSIT_R1 $ROUTER_VPC_A $REGION_1

echo "Step 2: Creating BGP sessions for vpc-transit to vpc-a tunnels"

# BGP sessions for transit-to-vpc-a tunnels
create_bgp_session $ROUTER_TRANSIT_R1 $REGION_1 "transit-to-vpc-a-bgp1" \
    $BGP_VPC_A_TU1_IP $ASN_VPC_A "transit-to-vpc-a-tu1" $BGP_TRANSIT_A_TU1_IP

create_bgp_session $ROUTER_TRANSIT_R1 $REGION_1 "transit-to-vpc-a-bgp2" \
    $BGP_VPC_A_TU2_IP $ASN_VPC_A "transit-to-vpc-a-tu2" $BGP_TRANSIT_A_TU2_IP

# BGP sessions for vpc-a-to-transit tunnels
create_bgp_session $ROUTER_VPC_A $REGION_1 "vpc-a-to-transit-bgp1" \
    $BGP_TRANSIT_A_TU1_IP $ASN_TRANSIT "vpc-a-to-transit-tu1" $BGP_VPC_A_TU1_IP

create_bgp_session $ROUTER_VPC_A $REGION_1 "vpc-a-to-transit-bgp2" \
    $BGP_TRANSIT_A_TU2_IP $ASN_TRANSIT "vpc-a-to-transit-tu2" $BGP_VPC_A_TU2_IP

echo "Step 3: Creating VPN tunnels between vpc-transit and vpc-b"

# Create tunnels from vpc-transit to vpc-b
create_vpn_tunnels "transit-to-vpc-b-tu1" "transit-to-vpc-b-tu2" \
    $VPN_GW_TRANSIT_R2 $VPN_GW_VPC_B $ROUTER_TRANSIT_R2 $REGION_2

# Create tunnels from vpc-b to vpc-transit
create_vpn_tunnels "vpc-b-to-transit-tu1" "vpc-b-to-transit-tu2" \
    $VPN_GW_VPC_B $VPN_GW_TRANSIT_R2 $ROUTER_VPC_B $REGION_2

echo "Step 4: Creating BGP sessions for vpc-transit to vpc-b tunnels"

# BGP sessions for transit-to-vpc-b tunnels
create_bgp_session $ROUTER_TRANSIT_R2 $REGION_2 "transit-to-vpc-b-bgp1" \
    $BGP_VPC_B_TU1_IP $ASN_VPC_B "transit-to-vpc-b-tu1" $BGP_TRANSIT_B_TU1_IP

create_bgp_session $ROUTER_TRANSIT_R2 $REGION_2 "transit-to-vpc-b-bgp2" \
    $BGP_VPC_B_TU2_IP $ASN_VPC_B "transit-to-vpc-b-tu2" $BGP_TRANSIT_B_TU2_IP

# BGP sessions for vpc-b-to-transit tunnels
create_bgp_session $ROUTER_VPC_B $REGION_2 "vpc-b-to-transit-bgp1" \
    $BGP_TRANSIT_B_TU1_IP $ASN_TRANSIT "vpc-b-to-transit-tu1" $BGP_VPC_B_TU1_IP

create_bgp_session $ROUTER_VPC_B $REGION_2 "vpc-b-to-transit-bgp2" \
    $BGP_TRANSIT_B_TU2_IP $ASN_TRANSIT "vpc-b-to-transit-tu2" $BGP_VPC_B_TU2_IP

echo ""
echo "Waiting for VPN tunnels to establish..."
sleep 30

# Verify tunnel status
echo "Verifying VPN tunnel status..."
gcloud compute vpn-tunnels list --filter="name:transit-to-vpc OR name:vpc-a-to-transit OR name:vpc-b-to-transit"

echo ""
echo "VPN tunnels and BGP sessions setup completed successfully!"
echo "Note: It may take a few minutes for all tunnels to show 'Established' status"
echo "========================================="
