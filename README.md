# serverless-exif-remover

##AWS/Python/Terraform
Function
When a file is uploaded into BUCKET_A it will trigger a lambda which will then remove the EXIF data and put the file into BUCKET_B.

Setup
This will assume that you already have ```~/.aws/``` config and ```~/.aws/credentials``` with a ```default``` profile configured. This link has more info on how to do this.

Firstly download the required python modules. This process is slightly different depending on whether the running machine is Linux or Windows/MacOS. The latter of which will require Docker to be installed.

This needs to be performed from the root of the repo.
```
# If on linux
pip3 install --target ./serverless-exif-remover Pillow

# Install required python packages using docker if on MacOS/Windows
# zsh/bash
docker run -it -v $(pwd)"/serverless-exif-remover":"/package" python:3.9 pip install --target /package/ Pillow
# fish shell
docker run -it -v (pwd)"/serverless-exif-remover":"/package" python:3.9 pip install --target /package/ Pillow
```
With the modules now downloaded we can run Terraform.

If you want to choose the names of the S3 buckets modify the ```variables.tfvars``` file before continuing.

```
# Change into the terraform directory
cd terraform

# Download terraform providers
terraform init

# Optional: Check the changes terraform wants to make
terraform plan -var-file=variables.tfvars

# Apply terraform changes - there will be a prompt before changes are made. 
terraform apply -var-file=variables.tfvars
```

##IAM Users
There are 2 users created, UserA & UserB. As well as access keys for them. If needed these keys can be found in the state file.

##Removing created infrastructure
The following command will remove all created resources in AWS. The S3 buckets need to be empty before they can be removed. You will need to do this manually.
```
terraform destroy 
```
Important info
The state file for terraform is stored locally, albeit excluded from git.
Logs can be viewed in Cloudwatch - these are not removed on ```terraform destroy```
