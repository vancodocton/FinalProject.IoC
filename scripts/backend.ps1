# $RESOURCE_GROUP_NAME="null"
# $STORAGE_ACCOUNT_NAME="null"
# $CONTAINER_NAME="null"

az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
