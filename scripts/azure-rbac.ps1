# $env:ARM_SP_NAME="SP_FE"

$env:ARM_RESOURCE_GROUP_ID = (az group show --name $env:resource_group_name --query id)

$credentials = az ad sp create-for-rbac --name $env:ARM_SP_NAME --role contributor `
    --scopes $env:ARM_RESOURCE_GROUP_ID `
    --sdk-auth
Write-Output $credentials;
$credentialsObject = $credentials | ConvertFrom-Json

$env:ARM_SUBSCRIPTION_ID = $credentialsObject.subscriptionId
$env:ARM_CLIENT_ID = $credentialsObject.clientId
$env:ARM_TENANT_ID = $credentialsObject.tenantId
$env:ARM_CLIENT_SECRET = $credentialsObject.clientSecret

az login --service-principal -u $env:ARM_CLIENT_ID -p $env:ARM_CLIENT_SECRET --tenant $env:ARM_TENANT_ID