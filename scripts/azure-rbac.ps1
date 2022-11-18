# $env:ARM_RESOURCE_GROUP_NAME="null"
# $env:ARM_APP_NAME="null"

az group show --name $env:ARM_RESOURCE_GROUP_NAME

$env:ARM_RESOURCE_GROUP_ID="null"

az ad sp create-for-rbac --name $env:ARM_APP_NAME --role contributor `
    --scopes $env:ARM_RESOURCE_GROUP_ID `
    --sdk-auth

$env:ARM_SUBSCRIPTION_ID="null"
$env:ARM_CLIENT_ID="null"
$env:ARM_TENANT_ID="null"
$env:ARM_CLIENT_SECRET="null"

az login --service-principal -u $env:ARM_CLIENT_ID -p $env:ARM_CLIENT_SECRET --tenant $env:ARM_TENANT_ID