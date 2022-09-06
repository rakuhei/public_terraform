# 基本設計

- Terraformでは、各種AWS/GCP コンポーネントの構成管理を行う。OS内の各種設定やミドルウェア等の設定については、Ansibleで管理する為、Terraformでは管理対象外とする。
- tfstateファイルは、S3バケット上に配置し、branch/commit間で同一のtfstateファイルを共有可能な構成とする。

## 初期環境構築
Terraformの実行にあたり、以下を初期設定として手動構築する必要がある。また、以下のリソースについては、Terraformの構成管理外とする。
各項目の詳細は、補足事項を確認

### 開発環境
1. docker comopose build する前に、下記コマンドにて、aws credentials fileの暗号化/復号化が必要
```
■暗号化
openssl enc -e -aes-256-cbc -salt -in ./docker_terraform/config/root/.aws/config -out ./docker_terraform/config/root/.aws/config -k ${パスワード}

■復号化
openssl enc -d -aes-256-cbc -salt -in ./docker_terraform/config/root/.aws/config -out ./docker_terraform/config/root/.aws/config -k
```

### 本番環境
#### AWS+Github+Linuxの場合
1. S3 Buket - terraform tfstate用
2. CloudShellにTerraform Install
  ```
  curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n 
  wget $URL
  unzip 
  rm -f terraform_*.zip
  mv terraform /usr/local/bin/
  ```
3. CloudShellからTerraformの実行

#### GCP+Githubの場合
1. CloudStorage - terraform tfstate用
2. Githubにて、Google Cloud Buildのインストール

#### AWS+Gitlabの場合
1. IAM_Role     - terraform repositoryへのミラーリング用
2. CodeCommit   - terraform repository
3. CodeBuild    - terraform deploy用
4. S3 Bucket    - tfstateファイル保存用
5. CodePipeLine - 一連のデプロイ処理を定義する

#### GCP+Gitlabの場合
1. CloudStorage - terraform tfstate用
TBD


## Directory Structure

```
terraform/
├ ReadMe.md
├ environments/
│  ├ aws_production/
│  │  ├ network/
│  │  ├ security_group/
│  │  ├ ec2_elb/
│  │  └ etc.....
│  └ aws_development/ ※同じ構造
│  ├ gcp_production/
│  │  ├ network/
│  │  ├ security_group/
│  │  ├ ec2_elb/
│  │  └ etc.....
│  └ gcp_development/ ※同じ構造  
└ aws_modules/
│  └ resources/
│     ├ ec2/
│     ├ vpc/
│     ├ elb/
│     ├ eip/
│     ├ security_group/
│     ├ route
│     ├ route_table
│     ├ route_table_association      
│     └ etc.....
└ gcp_modules/
```

* environments - 各環境/Regionのディレクトリを作成し、その配下に各種設定を記述していく。
* *_modules - モジュール(オブジェクト/関数)を作成する。environmentsで定義した設定情報を引数として受け取り、モジュール内で、各種コンポーネントの作成/変更/削除等の処理を行い、outputsにて定義した値を返り値として返す。resources配下のディレクトリは、"resource"ディレクティブ毎に作成すること。

# 詳細設計


## コーディングルール

### 命名規則

- ファイル名
  - スネークケースを利用
  - 小文字のみ利用
  - Region/環境(商用/検証)に依存しないファイル名とすること。
  - ファイルでどのリソースを管理しているかわかるようにすること。
- 変数名
  - スネークケースを利用
  - 小文字のみ利用

### コーディングスタイル

- **★Simple is best★**
- 変数や値を代入する際、"="(イコール)の位置を合わせること。(terraform fmtは使用不可)

### 禁止事項

- Modules配下の各種ファイルは、環境(商用,STG,検証,開発等)で差分が発生しないこと。
- 差分が発生する部分については、変数等を用いてenvironments配下のファイルに記述すること。
- また、差分について、リスト化できるものは、変数化してリストで記載すること。

### 制限事項

- 

###  推奨事項

- 

  

# 実行環境


## terraform実行方法

### Produciton
```shell
(例)
1. su - deploy
2. cd ~/terraform/environments/aws_production/network/
3. terraform init
4. terraform plan -var-file=_prd.tfvars
5. terraform apply -var-file=_prd.tfvars
```

### Managed
```shell
1. su - deploy
2. cd ~/terraform/environments/aws_managed/poc-server/
3. terraform init
4. terraform plan -var "ami_id=$AMI-ID"
5. terraform apply -var "ami_id=$AMI-ID"
```

# 補足事項

## 初期構築時の設定

### CodeBuild
初期に実行する必要があるのは、Module CodeBuild/CodePipeLineとなる。
そこで、各リソースに応じたCodeBuildを設定する。

### Code Commit
ベースとなるTerraformレポジトリからミラーリング/Webhockし、AWS上のCodeCommitへレポジトリを転記する。

### S3
terraformのtfstateファイル保管バケット

### ECR(Elastic Container Registory)
Codebuildにて、Terraformを実行する為のDockerコンテナレジストリ


