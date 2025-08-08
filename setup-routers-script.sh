#!/bin/bash

# Script: 02-setup-cloud-routers.sh
# Description: Create Cloud Routers for NCC Transit Hub Lab
# Author: Generated from lab instructions

set -e  # Exit on any error

# Load environment variables
source "$(dirname "$0")/variables-env.sh"

echo "========================================="
echo "Setting up Cloud Routers"
echo "========================================="

# Create Cloud Router for vpc-transit in Region 1
echo "Creating Cloud Router: $ROUTER_TRANSIT_R1"
gcloud compute routers create $ROUTER_TRANSIT_R1 \
    --network=$VPC_TRANSIT \
    --region=$REGION_1 \
    --asn=$ASN_TRANSIT \
    --advertisement-mode=DEFAULT

echo "✓ Created $ROUTER_TRANSIT_R1 in $REGION_1"

# Create Cloud Router for vpc-transit in Region 2
echo "Creating Cloud Router: $ROUTER_TRANSIT_R2"
gcloud compute routers create $ROUTER_TRANSIT_R2 \
    --network=$VPC_TRANSIT \
    --region=$REGION_2 \
    --asn=$ASN_TRANSIT \
    --advertisement-mode=DEFAULT

echo "✓ Created $ROUTER_TRANSIT_R2 in $REGION_2"

# Create Cloud Router for vpc-a in Region 1
echo "Creating Cloud Router: $ROUTER_VPC_A"
gcloud compute routers create $ROUTER_VPC_A \
    --network=$VPC_A \
    --region=$REGION_1 \
    --asn=$ASN_VPC_A \
    --advertisement-mode=DEFAULT

echo "✓ Created $ROUTER_VPC_A in $REGION_1"

# Create Cloud Router for vpc-b in Region 2
echo "Creating Cloud Router: $ROUTER_VPC_B"
gcloud compute routers create $ROUTER_VPC_B \
    --network=$VPC_B \
    --region=$REGION_2 \
    --asn=$ASN_VPC_B \
    --advertisement-mode=DEFAULT

echo "✓ Created $ROUTER_VPC_B in $REGION_2"

# Verify router creation
echo ""
echo "Verifying Cloud Routers..."
echo "Routers in $REGION_1:"
gcloud compute routers list --filter="region:$REGION_1"
echo ""
echo "Routers in $REGION_2:"
gcloud compute routers list --filter="region:$REGION_2"

echo ""
echo "Cloud Router setup completed successfully!"
echo "========================================="
