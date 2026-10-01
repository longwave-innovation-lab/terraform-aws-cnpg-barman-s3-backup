# Longwave Terraform Template <!-- omit in toc -->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Intro](#intro)
- [Terraform Best Practices](#terraform-best-practices)
  - [Project Structure](#project-structure)
  - [Code Style](#code-style)
    - [Repository Name](#repository-name)
    - [Variables](#variables)
    - [Resources and Datasources](#resources-and-datasources)
    - [Outputs](#outputs)
    - [Providers](#providers)
- [Using as Git Template](#using-as-git-template)
  - [Enforcing Pull Requests](#enforcing-pull-requests)
- [Development Environment Setup](#development-environment-setup)
  - [Pre-commit Hooks](#pre-commit-hooks)
- [Actions](#actions)
  - [Pull Request to main](#pull-request-to-main)
  - [Push on main](#push-on-main)
- [Requirements](#requirements)
- [Providers](#providers-1)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs-1)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Intro

Use this template as a starting point for creating Terraform projects or modules from scratch.

This template includes:

- **Automated Documentation**: GitHub Action generates Terraform docs automatically
- **Version Management**: GitHub Action creates semantic version tags from [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) following [SEMVER](https://semver.org/)
- **Table of Contents**: GitHub Action maintains an up-to-date ToC
- **Code Quality Checks**: Pre-commit hooks validate code before commits (see [Pre-commit Hooks](#pre-commit-hooks))

## Terraform Best Practices

This template follows official Terraform and community best practices:

- [Terraform Style Guide (HashiCorp)](https://developer.hashicorp.com/terraform/language/style)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Standard Module Structure (HashiCorp)](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

### Project Structure

The template follows Terraform best practices with this file structure:

- **`main.tf`** - **[REQUIRED]** Defines the primary resources for your module or project.

- **`variables.tf`** - **[REQUIRED]** Declares input variables with types, descriptions, and defaults. Makes your code reusable and configurable.

- **`outputs.tf`** - **[REQUIRED]** Exports values that other modules can use or displays results after deployment.

- **`providers.tf`** - **[RECOMMENDED]** Configures cloud providers (AWS, Azure, etc.) with authentication and settings.

- **`terraform.tf`** - **[RECOMMENDED]** Specifies version constraints for Terraform and providers to ensure compatibility.

  > **For modules**: Use flexible version constraints (e.g., `>= 1.0`) rather than exact versions to avoid conflicts.

- **`backend.tf`** - **[OPTIONAL]** Configures remote state storage (S3, Terraform Cloud, etc.).

  > **For modules**: Do NOT include this file. Backend configuration belongs in root modules only.

- **`locals.tf`** - **[OPTIONAL]** Defines computed values used across multiple files. Place file-specific locals at the top of their respective files instead.

- **`.terraform.lock.hcl`** - **[REQUIRED]** Auto-generated file that locks provider versions for consistency.

  > **For modules**: Do NOT commit this file.

- **`README.md`** - **[REQUIRED]** Documents usage, examples, inputs, outputs, and requirements.

- **`import.tf`** - **[OPTIONAL]** Used only in root modules for [bulk importing existing resources](https://developer.hashicorp.com/terraform/language/v1.14.x/import/bulk). Delete after the import completes.

**Organizing Large Projects:**

As your project grows, split resources into logical files:

- `main.tf` - General resources (random IDs, account data sources)
- `compute.tf` - Compute resources (EC2, EKS, VMs, AKS)
- `storage.tf` - Storage resources (S3, EFS, EBS, Azure Blob)
- `networking.tf` - Network resources (VPCs, subnets, security groups)
- And so on...

### Code Style

Installing [pre-commit hooks](#pre-commit-hooks) automatically enforces formatting and flags issues like:

- Multi-line comments (use `#` instead of `/* */`)
- Non-snake_case resource names
- Uppercase in resource names
- Locals block position should be at the top of each files
- There should be only one locals block per file

**References:**

- [Terraform Style Conventions](https://developer.hashicorp.com/terraform/language/syntax/style)
- [Terraform Naming Conventions](https://www.terraform-best-practices.com/naming)
- [Longwave Pre-commit Hooks](https://github.com/llw-RnD/longwave-terraform-git-hooks)

#### Repository Name

**For reusable Terraform modules**: `terraform-<provider>-<purpose>`

Example: `terraform-aws-github-codepipeline`

From the name you can deduce that:

- it's a reusable module (`terraform` prefix)
- uses the `aws` provider
- configures CI/CD pipelines with AWS CodePipeline and GitHub source

**For stand-alone Terraform projects**: `<client>-<scope>-<environment>`

Example: `clientname-eks-prod-bootstrap`

From the name you can deduce that:

- it's a project for the `it` client
- manages an `eks` cluster on AWS
- concerns the production environment (`prod-bootstrap`)

#### Variables

All variables must include `type` and `description`.

**For reusable modules:**

- Leave required variables without defaults (forces users to provide values)
- Only set defaults for safe, non-breaking values

**For root modules (infrastructure projects):**

- Set all variables to production-aligned values for team consistency
- **Never store secrets in variables**. Reference secret managers instead (AWS Secrets Manager, SSM Parameter Store)

#### Resources and Datasources

Don't repeat the resource type in the name:

```hcl
resource aws_instance web_api_aws_instance {...} ❌

resource aws_instance web_api {...} ✅
```

While Terraform applies resources in parallel, organizing them by dependency order improves readability.

#### Outputs

Keep outputs minimal to avoid cluttering documentation and terminal output.

All outputs require:

- A clear, concise description
- A value

#### Providers

Use aliases when working with multiple instances of the same provider (e.g., multiple AWS regions).

**Never hardcode secrets** in provider configurations. Use environment variables or credential files instead.

## Using as Git Template

**Before your first commit:**

1. Click `Use this template` → `Create a new repository` on GitHub
2. **Do NOT** select `Include all branches` (breaks PR functionality)
3. Develop on `dev` branch, then PR to `main` to trigger automated [actions](#actions)

### Enforcing Pull Requests

Protect your `main` branch by requiring PRs:

1. Navigate to `Settings` → `Rules` → `Rulesets`
2. Click `New ruleset` → `Import a ruleset`
3. Save this JSON and upload it:

    ```json
    {
      "name": "Force PullRequest",
      "target": "branch",
      "source_type": "Repository",
      "enforcement": "active",
      "conditions": {
        "ref_name": {
          "exclude": [],
          "include": [
            "~DEFAULT_BRANCH"
          ]
        }
      },
      "rules": [
        {
          "type": "deletion"
        },
        {
          "type": "non_fast_forward"
        },
        {
          "type": "pull_request",
          "parameters": {
            "required_approving_review_count": 0,
            "dismiss_stale_reviews_on_push": false,
            "required_reviewers": [],
            "require_code_owner_review": false,
            "require_last_push_approval": false,
            "required_review_thread_resolution": false,
            "allowed_merge_methods": [
              "merge",
              "squash",
              "rebase"
            ]
          }
        }
      ],
      "bypass_actors": [
        {
          "actor_id": 5,
          "actor_type": "RepositoryRole",
          "bypass_mode": "always"
        }
      ]
    }
    ```

This configuration:

- Allows only admins to push directly to `main`
- Requires all other users to submit pull requests

## Development Environment Setup

### Pre-commit Hooks

Automated checks run before each commit to maintain code quality.

Hooks are maintained in the [Longwave repository](https://github.com/llw-RnD/longwave-terraform-git-hooks).

**Prerequisites:**

- Python >= 3.10 ([Download](https://www.python.org/downloads/))

**One-time setup:**

```bash
pip install pre-commit
pre-commit install
```

**Automated checks:**

- Removes trailing whitespace
- Ensures files end with a newline ([why?](https://stackoverflow.com/questions/729692/why-should-text-files-end-with-a-newline))
- Prevents large file commits
- Validates [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format
- Runs `terraform fmt -recursive`
- Runs `terraform validate`
- Enforces `snake_case` naming
- Requires single-line comments (`#` not `/* */`)
- `locals` block should be at the top of each file
- There's should be only one `locals` block per file

**Run manually:**

```bash
pre-commit run --all-files
```

## Actions

### Pull Request to main

Opening or updating a PR triggers automatic README updates:

1. **Terraform docs** via [terraform-docs](https://github.com/terraform-docs/gh-actions)
2. **Table of Contents** via [doctoc](https://github.com/thlorenz/doctoc)
3. **Markdown linting** via [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2-action) against [markdown rules](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md)

> Customize markdown rules in [.markdownlint.json](.markdownlint.json)

**Setting up `terraform-docs`:**

For terraform-docs to work, your `README.md` must include these comment tags that define where the documentation will be inserted:

```markdown
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_id.example](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_string.example_snake_case](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | n/a | `string` | `"my-profile"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"eu-south-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
```

**Setting up `doctoc`:**

For doctoc to work, your `README.md` must include these comment tags that define where the table of contents will be generated:

```markdown
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
Content here will be automatically replaced by doctoc.
<!-- END doctoc generated TOC please keep comment here to allow auto update -->
```

**Excluding headings from TOC:**

To exclude a heading from the table of contents, add `<!-- omit in toc -->` after the heading:

```markdown
# My Heading <!-- omit in toc -->
```

> There's not pre-commit check in the action since each project may vary too much and each pre-commit may need different setups.
> If you want you still can configure a pre-commit job before the `tf-docs` job.

### Push on main

Pushing to `main` automatically:

- Creates a version tag following [Semantic Versioning](https://semver.org/)
- Generates a GitHub release
- Updates the changelog

Versions are determined from [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) in your commit history.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_id.example](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_string.example_snake_case](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | n/a | `string` | `"my-profile"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"eu-south-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
