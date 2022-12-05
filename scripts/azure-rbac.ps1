# $env:resource_group_name="null"
# $env:ARM_SP_NAME="SP_FE"

$env:ARM_RESOURCE_GROUP_ID = (az group show --name $env:resource_group_name --query id)

az ad sp create-for-rbac --name $env:ARM_SP_NAME --role contributor `
    --scopes $env:ARM_RESOURCE_GROUP_ID `

$env:ARM_SUBSCRIPTION_ID = "null"
$env:ARM_CLIENT_ID = "null"
$env:ARM_TENANT_ID = "null"
$env:ARM_CLIENT_SECRET = "null"

az login --service-principal -u $env:ARM_CLIENT_ID -p $env:ARM_CLIENT_SECRET --tenant $env:ARM_TENANT_ID