# Application Load Balancer with Cloud Armor

This repository contains the complete implementation of a Network Connectivity Center (NCC) transit hub setup that connects two remote branch office VPCs through Google Cloud's backbone network using HA VPN tunnels.

## Video

https://youtu.be/Klbg4NbNXq8

## Architecture Overview

This lab demonstrates how to set up NCC as a transit hub to route traffic between two non-Google networks using Google's backbone network. The architecture simulates two branch offices located in geographically separate locations.

### Components:
- **Hub**: `vpc-transit` - Central transit VPC acting as the hub
- **Spokes**: Two HA VPN tunnel pairs connecting:
  - `vpc-a` (Branch Office 1) in Region 1
  - `vpc-b` (Branch Office 2) in Region 2

```
┌─────────────┐    HA VPN    ┌──────────────┐    HA VPN    ┌─────────────┐
│   vpc-a     │◄─────────────►│ vpc-transit  │◄─────────────►│   vpc-b     │
│ (Region 1)  │              │   (Global)   │              │ (Region 2)  │
│ 10.20.10.0/24│              │              │              │10.20.20.0/24│
└─────────────┘              └──────────────┘              └─────────────┘
```

## Prerequisites

- Google Cloud Project with billing enabled
- Basic knowledge of Google VPC Networking and Compute Engine
- Familiarity with VPN and BGP concepts
- `gcloud` CLI installed and configured

## Project Structure

```
├── README.md
├── scripts/
│   ├── 01-setup-vpcs.sh
│   ├── 02-setup-cloud-routers.sh
│   ├── 03-setup-vpn-gateways.sh
│   ├── 04-setup-vpn-tunnels.sh
│   ├── 05-setup-ncc-hub.sh
│   ├── 06-setup-firewall-rules.sh
│   ├── 07-create-vms.sh
│   └── cleanup.sh
├── configs/
│   ├── network-config.yaml
│   └── variables.env
└── docs/
    ├── architecture.md
    ├── troubleshooting.md
    └── step-by-step-guide.md
```

## Quick Start

1. **Clone the repository**:
   ```bash
   git clone <your-repo-url>
   cd ncc-transit-hub-lab
   ```

2. **Set up environment variables**:
   ```bash
   source configs/variables.env
   # Modify the variables according to your project
   ```

3. **Run the setup scripts in order**:
   ```bash
   # Make scripts executable
   chmod +x scripts/*.sh
   
   # Execute setup scripts
   ./scripts/01-setup-vpcs.sh
   ./scripts/02-setup-cloud-routers.sh
   ./scripts/03-setup-vpn-gateways.sh
   ./scripts/04-setup-vpn-tunnels.sh
   ./scripts/05-setup-ncc-hub.sh
   ./scripts/06-setup-firewall-rules.sh
   ./scripts/07-create-vms.sh
   ```

4. **Test connectivity**:
   ```bash
   # SSH into vpc-a-vm-1 and ping vpc-b-vm-1
   gcloud compute ssh vpc-a-vm-1 --zone=<your-zone>
   ping -c 5 <internal-ip-of-vpc-b-vm-1>
   ```

## Implementation Details

### Task 1: VPC Networks
- **vpc-transit**: Global routing mode, no subnets (transit only)
- **vpc-a**: Regional routing, subnet `10.20.10.0/24` in Region 1
- **vpc-b**: Regional routing, subnet `10.20.20.0/24` in Region 2

### Task 2: Cloud Routers
| Router Name | Network | Region | ASN |
|-------------|---------|--------|-----|
| cr-vpc-transit-use4-1 | vpc-transit | Region 1 | 65000 |
| cr-vpc-transit-usw2-1 | vpc-transit | Region 2 | 65000 |
| cr-vpc-a-use4-1 | vpc-a | Region 1 | 65001 |
| cr-vpc-b-usw2-1 | vpc-b | Region 2 | 65002 |

### Task 3: HA VPN Gateways
Creates redundant VPN tunnels between:
- `vpc-transit` ↔ `vpc-a`
- `vpc-transit` ↔ `vpc-b`

Each connection uses BGP for dynamic routing with pre-configured IP addresses.

### Task 4: NCC Hub and Spokes
- **Hub**: `transit-hub` (global resource)
- **Spokes**: 
  - `bo1` (branch office 1) - vpc-a VPN tunnels
  - `bo2` (branch office 2) - vpc-b VPN tunnels

### Task 5: Testing
Creates VMs in each branch office VPC and tests end-to-end connectivity through the NCC transit hub.

## Key Features

- **High Availability**: Redundant VPN tunnels for each connection
- **Dynamic Routing**: BGP for automatic route advertisement
- **Global Connectivity**: Transit through Google's backbone network
- **Scalable**: Easy to add additional spokes to the hub

## Troubleshooting

### Common Issues:
1. **VPN Tunnel Status**: Ensure all tunnels show "Established" status
2. **BGP Sessions**: Verify BGP sessions are active
3. **Firewall Rules**: Check that ICMP and SSH are allowed
4. **IP Addressing**: Verify no IP conflicts in BGP peer addresses

### Verification Commands:
```bash
# Check VPN tunnel status
gcloud compute vpn-tunnels list

# Check BGP sessions
gcloud compute routers get-status <router-name> --region=<region>

# Test connectivity
gcloud compute ssh <vm-name> --zone=<zone> --command="ping -c 3 <target-ip>"
```

## Cleanup

To clean up all resources created by this lab:
```bash
./scripts/cleanup.sh
```

**Warning**: This will delete all VPCs, VMs, VPN gateways, and NCC resources created during the lab.

## Cost Considerations

This lab creates several billable resources:
- HA VPN Gateways (4 gateways)
- VPN Tunnels (8 tunnels)
- Compute Engine VMs (2 instances)
- Data transfer between regions

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## References

- [Network Connectivity Center Documentation](https://cloud.google.com/network-connectivity/docs/network-connectivity-center)
- [Cloud VPN Documentation](https://cloud.google.com/vpn/docs)
- [Cloud Router Documentation](https://cloud.google.com/router/docs)
