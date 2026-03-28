#  Geo API Service on AWS

A simple Geo API service deployed on AWS using Terraform (IaC).
Given an IP address, it returns the geographic location details.

---

## Architecture
```
User/Client
     ↓
API Gateway (HTTP Endpoint)
     ↓
Lambda Function (Python)
     ↓
ip-api.com (Geo Database)
     ↓
JSON Response
```

## Prerequisites

- AWS Account
- AWS CLI installed and configured
- Terraform installed
- Python 3.11+
- Git

---

##  Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/Bharathwaj-2001/geo-api.git
cd geo-api
```

### 2. Configure AWS credentials
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter region: us-east-1
# Enter output format: json
```

### 3. Zip the Lambda function
```bash
cd lambda
zip ../lambda.zip handler.py
cd ..
```

### 4. Initialize Terraform
```bash
terraform init
```

### 5. Preview changes
```bash
terraform plan
```

### 6. Deploy to AWS
```bash
terraform apply
# Type 'yes' when prompted
```

### 7. Get the API URL
```bash
# After apply completes, you will see:
# api_url = "https://XXXXX.execute-api.us-east-1.amazonaws.com/prod/geo"
```

---

## API Usage

### Endpoint
```
GET https://w7oduk8z75.execute-api.us-east-1.amazonaws.com/prod/geo
```

## 🗑️ Cleanup (Destroy Resources)

To avoid AWS charges, destroy resources when done:
```bash
terraform destroy
# Type 'yes' when prompted
```

---

## Author
Bharathwaj T
```

