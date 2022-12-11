# $env:CONTAINER_NAME="null"
# $env:resource_group_location = "null"
# $env:resource_group_name = "null"

az storage account create --resource-group $env:resource_group_name --name $env:STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

az storage container create --name $env:CONTAINER_NAME --account-name $env:STORAGE_ACCOUNT_NAME

(az storage account keys list --resource-group $env:resource_group_name --account-name $env:STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
