
# 📘 Terraform Day 2 Notes by Alok

---

## 🔁 Terraform Dependencies

Terraform figures out the order of resource creation using **dependencies**.

### 1. Implicit Dependencies
Terraform automatically figures out the order by checking references between resources.

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

➡️ Here, `aws_subnet` will wait for `aws_vpc` because of implicit dependency.

---

### 2. Explicit Dependencies
When there's no direct reference, use `depends_on`.

```hcl
resource "aws_s3_bucket" "bucket" {
  bucket = "alok-explicit-example"

  depends_on = [aws_route_table_association.public]
}
```

➡️ `bucket` waits for `aws_route_table_association.public` even if it doesn’t reference it directly.

---

## 🧩 Variables & `.tfvars`

Variables make your code dynamic, reusable, and clean.

### 1. Define Variables
📄 `variables.tf`
```hcl
variable "aws_region" {}
variable "vpc_cidr" {}
```

---

### 2. Assign Values
📄 `terraform.tfvars`
```hcl
aws_region = "us-east-1"
vpc_cidr   = "10.0.0.0/16"
```

---

### 3. Use Variables in Code
```hcl
provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}
```

---

### Benefits of Variables

- Environment-specific config
- Clean and DRY code
- Secure (no hardcoded secrets)

---

## 🔄 Lifecycle Management in Terraform

By default, Terraform **destroys** a resource and then **re-creates** it when needed.

### Problem:
May cause **downtime** or **data loss**.

---

### ✅ Solution: Use `lifecycle` block

```hcl
resource "aws_instance" "my_ec2" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}
```

➡️ Creates new EC2 **before** destroying the old one.

---

### Other Lifecycle Options

```hcl
lifecycle {
  prevent_destroy = true
}
```
Prevents accidental deletion.

```hcl
lifecycle {
  ignore_changes = [ tags ]
}
```
Ignores tag updates.

---

