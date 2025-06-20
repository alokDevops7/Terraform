
# 📘 Terraform Detailed Revision Notes by Alok

---

## 🌩️ Cloud-Native IaC Tools vs Terraform

### 🧰 Examples of Cloud-Native IaC Tools
| Cloud Platform | IaC Tool             | Format      |
|----------------|----------------------|-------------|
| AWS            | CloudFormation (CFT) | JSON/YAML   |
| Azure          | ARM Templates        | JSON        |
| GCP            | Deployment Manager   | YAML        |

> These tools help automate infrastructure provisioning within their respective cloud platforms.

---

### ❌ Disadvantages of Cloud-Native Tools

1. **Monolithic Templates**  
   All infrastructure code must be written in a single JSON/YAML file. This becomes hard to manage and debug as your infrastructure grows.

2. **Complex Syntax**  
   JSON is particularly verbose and error-prone. YAML is better but still harder to read and write compared to HCL (Terraform’s language).

3. **Poor Import Support**  
   Importing existing resources is challenging in AWS CFT and not supported at all in Azure ARM templates.

4. **Cloud Lock-In**  
   CFT only works on AWS, ARM only on Azure, etc.

5. **No Modules Concept**  
   You cannot reuse template parts (no modularity).

6. **No Workspace Support**  
   Can't isolate environments like dev/test/prod easily.

7. **No Dry Run**  
   You can’t preview what changes will happen before deploying.

---

## ✅ Why Terraform?

- **Cloud-agnostic**: Works with AWS, Azure, GCP, and more.
- **Modular**: Supports reusable modules.
- **Readable**: Uses HashiCorp Configuration Language (HCL).
- **Preview changes**: `terraform plan` allows dry runs.
- **Environment isolation**: Use of workspaces.
- **Resource importing**: Easy with `terraform import`.

---

## 🚀 Terraform: AWS VPC Infrastructure (Basic Example)

### 1. Create `main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "Vpc-Terraform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Vpc-Terraform"
  }
}
```

### 2. Internet Gateway, Subnets, Route Tables, SG

Full config includes:
- `aws_internet_gateway`
- `aws_subnet`
- `aws_route_table`
- `aws_route_table_association`
- `aws_security_group`

### 3. Terraform Commands

```bash
terraform init       # Initialize project and download provider
terraform fmt        # Format code
terraform validate   # Validate syntax
terraform plan       # Show execution plan
terraform apply      # Apply and provision resources
```

### ✅ Verify in AWS Console

Check all resources like VPC, Subnet, IGW, etc.

---

## 🔍 Terraform Data Source

### Use Case:
Using an already existing VPC in AWS console:

```hcl
data "aws_vpc" "existing_vpc" {
  id = "vpc-xxxxxxxxxxxxxxx"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_vpc.existing_vpc.id
}
```

You can reference existing resources using `data` blocks — useful in hybrid or shared environments.

---

## 🛰️ Terraform with Remote State

### Goal:
Split infrastructure into separate projects and share resources between them using remote state.

---

### 🧱 Project 1: `base-infra/`

- VPC, Subnets, IGW, SG, Route Tables
- Store state in S3 backend:

```hcl
terraform {
  backend "s3" {
    bucket = "alokdevopss3bucket"
    key    = "Base-Infra.tfstate"
    region = "us-east-1"
  }
}
```

Outputs from this project should expose values like:
- `vpc_id`
- `subnet_id`
- `security_group_id`

---

### 🚀 Project 2: `main-infra-ec2/`

#### main.tf

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web-1" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.subnet1.id
  vpc_security_group_ids = [data.aws_security_group.allow_all.id]
  key_name               = "us-east-1a"
  associate_public_ip_address = true

  tags = {
    Name  = "Server-1"
    Env   = "Prod"
    Owner = "Alok"
  }
}

terraform {
  backend "s3" {
    bucket = "alokdevopss3bucket"
    key    = "Current-Infra.tfstate"
    region = "us-east-1"
  }
}
```

#### data-source-backend.tf

```hcl
data "aws_vpc" "terraform-aws-testing" {
  id = "vpc-xxxxxxxx"
}

data "aws_subnet" "subnet1" {
  id = "subnet-xxxxxxxx"
}

data "aws_security_group" "allow_all" {
  id = "sg-xxxxxxxx"
}
```

### ✅ Outcome

- EC2 instance launched with existing infra values
- Two separate state files:
  - `Base-Infra.tfstate` (for VPC, subnet, etc.)
  - `Current-Infra.tfstate` (for EC2)
- Clean, reusable, and scalable project structure

---

## 🧠 Summary

| Project         | Purpose               | State File               |
|----------------|------------------------|---------------------------|
| `base-infra/`   | Network infrastructure | `Base-Infra.tfstate`      |
| `main-infra-ec2/` | Compute layer (EC2)    | `Current-Infra.tfstate`   |

---


