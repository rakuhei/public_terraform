# Docker Iac 
### Images
# OS : centos8
FROM centos:8

### Define
ARG AWS_REGION="ap-northeast-1"
ARG S3BUCKET="https://public-srcfile.s3-ap-northeast-1.amazonaws.com"
ARG REPOSITORY="https://github.com/rakuhei/terraform.git"
SHELL [ "/bin/bash", "-c" ]
ARG TF_VER="1.0.5"
ARG E

### Function

### Common Install
RUN  dnf update -y && \
  dnf clean all
RUN dnf install wget unzip -y

### AWS Setup
COPY ./config/root/.aws/config /root/.aws/config

### Terraform Install/Setup
RUN wget https://releases.hashicorp.com/terraform/"$TF_VER"/terraform_"$TF_VER"_linux_amd64.zip
RUN unzip terraform_"$TF_VER"_linux_amd64.zip -d /usr/local/bin
RUN chmod 755 /usr/local/bin/terraform
