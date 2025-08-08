#!/bin/bash

# Script: 07-create-vms.sh
# Description: Create VMs for testing NCC Transit Hub Lab
# Author: Generated from lab instructions

set -e  # Exit on any error

# Load environment variables
source "$(dirname "$0")/variables-env.sh"

echo "========================================="
echo "Creating Test VMs"
echo "========================================="

echo "Step 1: Creating VM in vpc-a"
gcloud compute instances create $VM_A_NAME \
    --zone=$ZONE_1 \
    --machine-type=$MACHINE_TYPE \
    --network-interface=network-tier=PREMIUM,subnet=$SUBNET_A_NAME \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account="$(gcloud config get-value account)" \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=$VM_A_NAME,image=projects/$IMAGE_PROJECT/global/images/family/$IMAGE_FAMILY,mode=rw,size=$BOOT_DISK_SIZE,type=projects/$PROJECT_ID/zones/$ZONE_1/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=environment=lab,purpose=ncc-testing \
    --reservation-affinity=any

echo "✓ Created VM: $VM_A_NAME in $ZONE_1"

echo "Step 2: Creating VM in vpc-b"
gcloud compute instances create $VM_B_NAME \
    --zone=$ZONE_2 \
    --machine-type=$MACHINE_TYPE \
    --network-interface=network-tier=PREMIUM,subnet=$SUBNET_B_NAME \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account="$(gcloud config get-value account)" \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=$VM_B_NAME,image=projects/$IMAGE_PROJECT/global/images/family/$IMAGE_FAMILY,mode=rw,size=$BOOT_DISK_SIZE,type=projects/$PROJECT_ID/zones/$ZONE_2/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=environment=lab,purpose=ncc-testing \
    --reservation-affinity=any

echo "✓ Created VM: $VM_B_NAME in $ZONE_2"

# Wait for VMs to be ready
echo ""
echo "Waiting for VMs to be ready..."
sleep 30

# Get internal IPs
echo "Getting VM internal IP addresses..."
VM_A_IP=$(gcloud compute instances describe $VM_A_NAME --zone=$ZONE_1 --format='get(networkInterfaces[0].networkIP)')
VM_B_IP=$(gcloud compute instances describe $VM_B_NAME --zone=$ZONE_2 --format='get(networkInterfaces[0].networkIP)')

echo "VM Internal IP Addresses:"
echo "  $VM_A_NAME: $VM_A_IP"
echo "  $VM_B_NAME: $VM_B_IP"

# Verify VM creation
echo ""
echo "Verifying VM creation..."
gcloud compute instances list --filter="name:($VM_A_NAME OR $VM_B_NAME)"

echo ""
echo "VM creation completed successfully!"
echo ""
echo "Next steps:"
echo "1. Test connectivity by SSH'ing into $VM_A_NAME:"
echo "   gcloud compute ssh $VM_A_NAME --zone=$ZONE_1"
echo ""
echo "2. From $VM_A_NAME, ping $VM_B_NAME:"
echo "   ping -c 5 $VM_B_IP"
echo ""
echo "3. If ping is successful, the NCC transit hub is working correctly!"
echo "========================================="
