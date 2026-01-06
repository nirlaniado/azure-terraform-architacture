# Simple Net App Project

This project contains the source code and infrastructure configuration for the `Simple Net App`. It is designed to be deployed on Azure using Terraform and consists of a Python Flask application connected to a PostgreSQL database.

## Project Structure

- **`app/`**: Contains the Python application code.
  - `app.py`: Main Flask application.
  - `db.py`: Database interaction logic.
  - `requirements.txt`: Python dependencies.

- **`infrastructure/`**: Core infrastructure Terraform definitions.
  - Likely contains base network and shared resource definitions.

- **`terraform-app-and-db/`**: Terraform configuration for the Application and Database resources.
  - `main.tf`: Main Terraform configuration.
  - `variables.tf`: Input variables.
  - `modules/`: Reusable Terraform modules (e.g., for Compute, Database, etc.).

## Prerequisites

- **Terraform**: v1.0+ required for infrastructure provisoning.
- **Python**: v3.9+ required for local development.
- **Azure CLI**: Required for authentication with Azure.

## Getting Started

### 1. Infrastructure Deployment

Navigate to the Terraform directory you wish to deploy (e.g., `terraform-app-and-db`):

```bash
cd terraform-app-and-db
terraform init
terraform plan
terraform apply
```

Note: Ensure you have a valid `terraform.tfvars` or pass variables via command line/environment variables as needed.

### 2. Local App Development

To run the application locally:

```bash
cd app
python -m venv venv
# Windows
.\venv\Scripts\activate
# Linux/Mac
source venv/bin/activate

pip install -r requirements.txt
python app.py
```

## Security

- **Sensitive Files**: `.gitignore` is configured to exclude sensitive files like `*.pem`, `tfstate`, and `.env`.
- **SSH Keys**: Ensure `private_key.pem` is kept secure and never committed to version control.
