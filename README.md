# ArkCase Core Deployment

This image contains the base ArkCase deployment artifacts:

* ArkCase
* ArkCase configuration files (.arkcase)
* PDFTron binaries

Sub-images should override these artifacts, or include their own. To disable an artifact from deployment, simply overwrite it with a file of size 0 (i.e. 0 bytes long), and this will signal the deployment script(s) that this file is to be ignored.

## How to build:

docker build -t public.ecr.aws/arkcase/deploy-core:latest .
