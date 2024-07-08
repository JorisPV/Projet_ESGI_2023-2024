#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <vpc-id>"
    exit 1
fi

VPC_ID="$1"

delete_network_interfaces() {
    NETWORK_INTERFACE_IDS=$(aws ec2 describe-network-interfaces --filters "Name=vpc-id,Values=$VPC_ID" --query "NetworkInterfaces[*].NetworkInterfaceId" --output text)
    for NETWORK_INTERFACE_ID in $NETWORK_INTERFACE_IDS; do
        echo "Détachement et suppression de l'interface réseau $NETWORK_INTERFACE_ID"
        aws ec2 delete-network-interface --network-interface-id $NETWORK_INTERFACE_ID
    done
}

delete_instances() {
    INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=vpc-id,Values=$VPC_ID" --query "Reservations[*].Instances[*].InstanceId" --output text)
    for INSTANCE_ID in $INSTANCE_IDS; do
        echo "Arrêt de l'instance $INSTANCE_ID"
        aws ec2 terminate-instances --instance-ids $INSTANCE_ID
        aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID
    done
}

IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query "InternetGateways[0].InternetGatewayId" --output text)
if [ "$IGW_ID" != "None" ]; then
    aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
    aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID
fi

delete_instances

SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query "Subnets[*].SubnetId" --output text)
for SUBNET_ID in $SUBNET_IDS; do
    echo "Suppression du sous-réseau $SUBNET_ID"
    aws ec2 delete-subnet --subnet-id $SUBNET_ID
done

ROUTE_TABLE_IDS=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query "RouteTables[?Associations[0].Main!=true].RouteTableId" --output text)
for ROUTE_TABLE_ID in $ROUTE_TABLE_IDS; do
    echo "Suppression de la table de routage $ROUTE_TABLE_ID"
    aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID
done

SG_IDS=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query "SecurityGroups[?GroupName!='default'].GroupId" --output text)
for SG_ID in $SG_IDS; do
    echo "Suppression du groupe de sécurité $SG_ID"
    aws ec2 delete-security-group --group-id $SG_ID
done

NACL_IDS=$(aws ec2 describe-network-acls --filters "Name=vpc-id,Values=$VPC_ID" --query "NetworkAcls[?IsDefault==false].NetworkAclId" --output text)
for NACL_ID in $NACL_IDS; do
    echo "Suppression de l'ACL réseau $NACL_ID"
    aws ec2 delete-network-acl --network-acl-id $NACL_ID
done

delete_network_interfaces

aws ec2 delete-vpc --vpc-id $VPC_ID

echo "La VPC $VPC_ID et ses ressources associées ont été supprimées."
