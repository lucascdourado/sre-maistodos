# Best Practices for Repository Organization and Deployment

When structuring your infrastructure and application projects, it's a recommended practice to separate different parts into dedicated repositories. This facilitates code management, collaboration, and maintenance. Here are some guidelines on how to organize your repositories:

## Repository Organization

## 1. Helm

- **Purpose:** Store Helm charts that describe the Kubernetes infrastructure of your application.

- **Example Directory Structure:**
    ```plaintext
    /helm
        /aws
            /templates
            Chart.yaml
        /metabase
            /templates
            Chart.yaml
            values.yaml
## 2. Terraform

- **Purpose:** Contains Terraform code to provision and manage the infrastructure needed for your application.

- **Example Directory Structure:**
    ```plaintext
    /terraform
        /modules
        main.tf
        variables.tf
        outputs.tf
        provider.tf
# Advantages

- **Focused Management:** Each repository deals with a specific concern, making it easier to understand, update, and maintain the code.

- **Reuse:** Repositories can be reused in other projects, promoting modularity and consistency.

- **Efficient Collaboration:** Teams can work in parallel on different parts of the application without interference.

- **Specific CI/CD:** Specific CI/CD pipelines can be implemented for each part of the application, providing greater flexibility.

# Suggested Deployment Flow

1. **Updates to Helm Chart:** Changes to Kubernetes infrastructure are reflected in the Helm charts of the helm repository.

2. **Updates to Terraform:** Modifications to cloud infrastructure are managed in the terraform repository.

3. **Continuous Integration:** Implement specific CI/CD pipelines for each repository to ensure automated testing, builds, and deployments.

By following these practices, you can create a more modular, easily manageable, and collaborative development environment. This will result in a more efficient and sustainable implementation of your application.

### Check out the documentation for each part – [Helm](./helm/metabase/README.md) and [Terraform](./terraform/README.md) – in their respective folders for detailed information.

**Author: [Lucas Dourado](https://www.linkedin.com/in/lucascdourado/)**

<!-- E aí, me contrata aí? Tô pronto pra somar e botar muita energia boa no time! -->