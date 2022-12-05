terraform init
terraform workspace select default
terraform apply -auto-approve -input=false
pwsh -Command (terraform output -raw script_gh_secret_publish_profile)
pwsh -Command (terraform output -raw script_gh_secret_publish_profile)