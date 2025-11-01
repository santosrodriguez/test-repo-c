Terraform Deployment Workflow (Gated CI/CD)

Overview

This repository implements a gated CI/CD pipeline for Terraform.
Environments: dev (implemented here). The same pattern can be duplicated for int, art, and pre.

Each environment should keep its own Terraform configuration and separate state file stored in an Azure Storage Account.

⸻

Environment Configuration
	•	Each environment uses a dedicated GitHub Environment (here: dev) holding:
	•	OIDC workload identity secrets: AZURE_CLIENT_ID, AZURE_TENANT_ID, AZURE_SUBSCRIPTION_ID.
	•	Backend state secrets: TF_STORAGE_ACCOUNT, TF_CONTAINER_NAME, TF_RESOURCE_GROUP_NAME, TF_SUBSCRIPTION_ID.
	•	Authentication uses GitHub OIDC via azure/login@v2 (no long-lived cloud secrets).

⸻

Terraform State Management
	•	State is stored in Azure Storage (azurerm backend).
	•	One state file per environment (container/key isolated per env).

⸻

Gated CI/CD Pipeline

A change must pass both gates before any apply happens:
	1.	Validation Gate – plan.yml (job: pr-infra-check)
	•	Triggers: pull_request to main with changes under dev/**, or manual workflow_dispatch with target_ref.
	•	Runs in: ./dev
	•	Steps: terraform init (backend from secrets) → fmt -check → validate → plan.
	•	Outputs: Posts a rich PR comment containing init/fmt/validate status and the full plan.
	2.	Approval & Merge Gate – apply.yml (job: terraform)
	•	Trigger: push to dev/**.
	•	Eligibility checks (gate script):
	•	Commit is associated with a PR to main.
	•	PR is merged into main.
	•	PR has at least one APPROVED review.
	•	The validation workflow pr-infra-check completed successfully on the PR’s commit.
	•	Apply behavior:
	•	On refs/heads/main: login with OIDC → terraform init (backend) → terraform apply -auto-approve.
	•	On non-main: runs init -backend=false, fmt, validate (no apply).

This design enforces peer review, successful validation, and merge control before deployment.

⸻

Branch Protection

Protect main (required reviews, required status checks including pr-infra-check, etc.). The Apply workflow already enforces these conditions at runtime.

⸻

Permissions (Least-Privilege)
	•	plan.yml: id-token: write, issues: write, pull-requests: write, contents: read
(posts plan to PR and uses OIDC).
	•	apply.yml: id-token: write, contents: read, pull-requests: read, checks: read
(reads PR/checks for gating and uses OIDC).

⸻

Repository Structure

Each environment lives in its own folder with a dedicated backend config (example shows dev implemented):

⸻

Manual Plan Runs

You can run a plan against a specific ref using the manual dispatch input:
	•	workflow_dispatch → target_ref: main (or a specific branch/tag).
