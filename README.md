# Terraform 初期セットアップ手順（envs/dev）

## ✅ 手順

### 1. `envs/dev` ディレクトリに移動

```bash
cd terraform/envs/dev
```
### 2. terraform.tfvarsを作成
```bash
cp terraform.tfvars.example terraform.tfvars
```

### 3. 自分のグローバルIPを取得し、terraform.tfvars に記述
```bash
curl https://checkip.amazonaws.com
```

```tfvars
bastion_allowed_ips = ["203.0.xx.xx/32"]
```

### 4. AWS Consoleでキーペアを作成し、秘密鍵（.pem）を保存
踏み台サーバー用とControlPlane用の2つキーペアを用意してください。
作成直後に`.pem`ファイルが自動ダウンロードされます。
- 例
  - 踏み台: myapp-dev-bastion.pem
  - ControlPlane用: myapp-dev-k8s

### 5. .pem ファイルを ~/.ssh に移動し、権限を設定
作成した2つのキーペアで同じ操作をしてください。
```bash
mkdir -p ~/.ssh
mv ~/Downloads/myapp-dev-bastion.pem ~/.ssh/ # キーペア名は適宜変更してください
chmod 400 ~/.ssh/myapp-dev-bastion.pem
```

### 6. terraform.tfvars にキーペア名を記述
```tfvars
k8s_key_name="myapp-dev-k8s"
bastion_key_name = "myapp-dev-bastion"
```

### 7. Terraformを初期化
```bash
terraform init
```

### 8. Terraform を適用
```bash
terraform apply
```

### 9. 踏み台サーバーにControlPlane用のキーペアを転送
```bash
scp -i ~/.ssh/myapp-dev-bastion.pem ~/.ssh/myapp-dev-k8s.pem ec2-user@<bastion-public-ip>:~/
```

### 10. 踏み台サーバーにssh接続し、権限の調整
```bash
chmod 400 ~/myapp-dev-k8s.pem
```

### 11. 踏み台サーバーからControlPlaneにssh接続確認
```bash
ssh -i ~/myapp-dev-k8s.pem ubuntu@<control-plane-private-ip>
```