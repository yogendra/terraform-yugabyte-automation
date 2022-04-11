# Yugabtye - Terraform Automation


Collection of modules for setting up YugbayteDB infrastructure on cloud(like) environment

## Supported IaaS

1. Tencent

TODO

1. Kubernetes
1. AWS
1. Azure
1. Google
1. Oracle
1. Alicloud
1. vSphere


## Testing


1. Initial Setup

    ```bash
    export TENCENTCLOUD_SECRET_ID=IKIDXXXXXXXXXXXXX
    export TENCENTCLOUD_SECRET_KEY=tWswXXXXXXXXXXXX

    cd modules/<module>/test

    terraform init
    ```

1. Create Infra

    ```bash

    terraform apply
    ```

1. Destroy Infra

    ```bash
    terraform destroy
    ```
