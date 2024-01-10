# CircleCI Configuration for Terraform Pipeline

This document provides instructions on setting up a pipeline in CircleCI for Terraform automation, including the addition of necessary environment variables.

## Prerequisites

Before getting started, make sure you have the following items:

- An account on [CircleCI](https://circleci.com/)
- A repository configured on CircleCI
- Environment variables defined on CircleCI for sensitive credentials (in this case, `METABASE_DATABASE_PASSWORD`)

## Setting up the Metabase Database Password

The Metabase database password is a sensitive credential that should not be stored in the repository. Instead, it should be stored as an environment variable in CircleCI.

There are two ways to add environment variables in CircleCI: in the project settings or in contexts. The first option is simpler, but the second is more secure, as it allows you to define variables that can be used by multiple projects.

### Adding Environment Variables in CircleCI Project Settings

Follow these steps to add environment variables in CircleCI:

1. In the CircleCI dashboard, navigate to your project.

2. Select the "Project Settings" menu.

3. On the left menu, click on "Environment Variables".

4. Add an environment variable named `METABASE_DATABASE_PASSWORD` and set the corresponding value.

### Adding Environment Variables in CircleCI Contexts

Follow these steps to add environment variables in CircleCI:

1. In the CircleCI, navigate to the "Organization Settings" menu.

2. On the left menu, click on "Contexts".

3. Add a context named `metabase`.

4. Add an environment variable named `METABASE_DATABASE_PASSWORD` and set the corresponding value.

#### Now, whenever you commit to the main branch, the CircleCI pipeline will be triggered, executing the planning step and waiting for approval before applying changes using Terraform. Make sure to review and customize this configuration as needed for your specific environment.


