uuid=$(openssl rand -hex 32 | tr -dc 'a-zA-Z0-9' | fold -w 5  | head -n 1)
aksname="lalaks-$uuid"
RESOURCE_GROUP=$aksname
AKS_CLUSTER=$aksname
VM_SIZE=Standard_D2s_v3
node_count=3
kube_version=1.12.6
location=westeurope

network_prefix='10.0.0.0/16'
network_aks_subnet='10.0.0.0/22'



#Create a RG
az group create --name  $RESOURCE_GROUP -l $location
#Create a VNET
az network vnet create -g $RESOURCE_GROUP -n $aksname --address-prefix $network_prefix     --subnet-name aks --subnet-prefix $network_aks_subnet -l $location
#Create a AKS subnet
#i#az network vnet subnet create -g $RESOURCE_GROUP --vnet-name iotsuite -n $AKS_CLUSTER  --address-prefix 10.0.1.0/24




#List Subnet belonging to VNET
SUBNET="$(az network vnet subnet list --resource-group $RESOURCE_GROUP --vnet-name $aksname --query [].id --output tsv  | grep aks)"
echo $SUBNET

#azure group deployment create \
# --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER  --template-file loganalytics.json


#Create AKS Cluster with Service Principle
az aks create \
 --resource-group $RESOURCE_GROUP \
 --disable-rbac \
 --network-plugin "azure" \
 --node-count $node_count \
 --node-vm-size=$VM_SIZE \
 --kubernetes-version=$kube_version \
 --name $AKS_CLUSTER \
 --docker-bridge-address "172.17.0.1/16" \
 --dns-service-ip "11.2.0.10" \
 --service-cidr "11.2.0.0/24" \
 --location $location \
 --enable-addons "monitoring,http_application_routing" \
 --vnet-subnet-id $SUBNET

#--network-plugin "azure" \
#i#--vnet-subnet-id $SUBNET \
