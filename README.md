Terraform Deployment Workflow

Overview

This workflow manages Terraform deployments for the following environments:
dev, int, art, and pre.

Each environment is fully isolated, maintaining its own Terraform configuration files. This design allows for environment-specific customization and avoids code overlap when infrastructure or settings differ.

⸻

Environment Configuration

Each environment uses a dedicated GitHub Environment that stores:
	•	Workload identity credentials for authenticating with Azure.
	•	Secrets required for Terraform backend configuration and state management.

This setup ensures secure, consistent, and independent deployments per environment.

⸻

Terraform State Management

All environments are configured to store their Terraform state files in Azure Storage Accounts.
Each environment uses a separate state file, providing isolation between deployments and preventing cross-environment interference.

This structure simplifies backend configuration and helps maintain clear state boundaries across environments.

⸻

Branch Protection

The main branch must be protected to enforce proper change control and ensure only reviewed, approved changes are merged.

⸻

Pull Request and Apply Workflow

The Apply workflow is triggered only when both of the following conditions are met:
	1.	A pull request has been reviewed and approved.
	2.	The validation workflow has successfully completed.

This ensures that all infrastructure changes are validated, peer-reviewed, and compliant before being applied to Azure.

⸻

Repository Structure

Each environment resides in its own directory, containing Terraform configuration files and a dedicated backend configuration for the Azure Storage Account state file.

***bash
terraform-repo/
├── dev/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.hcl
│   └── dev.tfvars
├── int/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.hcl
│   └── int.tfvars
├── crt/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.hcl
│   └── art.tfvars
├── prd/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.hcl
│   └── pre.tfvars
└── common.auto.tfvars


Each environment’s backend.hcl defines its own Azure Storage Account, container, and state file name, ensuring isolated state management and clear backend separation.
