# gcp-static-website

[![Terraform](https://img.shields.io/badge/Terraform-1.2.1-blueviolet.svg)](https://www.terraform.io/)
[![Python 3.10](https://img.shields.io/badge/python-3.10-blue.svg)](https://www.python.org/downloads/release/python-377/)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

> The code helps to deploy static-website hosted on GCP Cloud Storage bucket. Every time an object is uploaded to static-website bucket, its `Cache-Control` metadata is updated by Cloud Function.

## Prerequisites
### Required tools
1. The `gcloud` CLI tool - [installation instructions](https://cloud.google.com/sdk/docs/install). 
2. The Terraform tool - [installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli).

### Authorize to GCP with a user account
1. Below command authorizes access and performs other common setup steps:
```bash
gcloud init
```
2. To ONLY authorize yourself use the following command:
```bash
gcloud auth login
```
3. To obtain user access credentials to use for Application Default Credentials (ADC) - necessary for Terraform & SDK, run:
```bash
gcloud auth application-default login
```


## Deploy static website resources
1. First, change the folder to `terraform_files`:
```bash
cd terraform_files/
```
2. Run following command in order to initialize Terraform working directory:
```bash
terraform init
```
3. To see Terraform execution plan run:
```bash
terraform plan
```
4. To apply changes on GCP run:
```bash
terraform apply
```

> :warning: **Note:** After running `terraform plan` & `terraform apply` you will be prompted to enter the GCP project id in which the resources are to be deployed.

5. Once the resources are deployed, upload website content files with following command (should be run from repository root):
```bash
gsutil rsync -R static-website-content gs://<static_website_bucket_name>
```
