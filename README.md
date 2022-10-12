# Xeneta Operations Task


## Practical case: Deployable development environment

### Summary of Solution
Deployed a managed and severless containerised solution on AWS using ECS and Fargate. Terraform was used as an IAC for automating application infratructure setup and pipeline setup on AWS. The solution includes automated import of data after infra setup and updation of config.py DB values during deployment.

### Tools/Services
- IAC : Terraform
- Database: RDS Postgres
- CI/CD: AWS Codepipeline
- Containerization: ECS
- Monitoring/Logs: Cloudwatch
- Logs/Artifact Storage: S3
- Secrets values holder: AWS Secrets Manager

### Pre-requisite
 - AWS CLI
 - AWS Access credentials/IAM Role attached to an instance
 - Terraform 0.14
 
 IAM User/Role should have List,Read,Write and Tagging access of the following services: EC2, S3, VPC, ECS, ECR, Codepipeline, Codebuild, Codedeploy, IAM, Secrets Manager, RDS, ELB, Cloudwatch

### Infra setup steps
```
git clone https://github.com/utkarsh17naik/operations-task-utkarsh.git
```
Here we have stored terraform files in the tf-files directory
```
cd tf-files/
terraform init
terraform plan -var-file=values.tfvars
```
Review the infra to be created/modified.Here, you might be prompted to enter your public key. The same key would be utilized while creating bastion host.
To apply the changes, run the below command.
```
terraform apply -var-file=values.tfvars
```
### Post Infra creation steps
#### 1. Github validation
Currently Codepipeline does not accept any Github related credentials via terraform. It would setup the github repository and branch in the Source stage but would show conection as "Update pending connection" .We have to login our Github credentials and grant access to Codepipeline via AWS Console in Codepipeline-->Edit-->Edit Stage(Source).


![xen-update-connection](https://user-images.githubusercontent.com/34398133/195197078-3060a5c9-82ae-4a2b-b0a3-a7a48b09dcdb.png)

#### 2. Buildspec file

Review the container name in buildspec.yml file (in post build steps) with the one defined in Terraform.

![buildspec1](https://user-images.githubusercontent.com/34398133/195406528-be18a078-dbcc-42e4-b275-20a00081beb9.png)

### Output 
The Terraform code will proceed with creating the network resources such as VPC, Internet Gateway, NAT Gateway, Application Load Balancer followed by ECS, RDS, Codepipeline for a CI/CD enabled managed containerised environment. The config variables like db credentials are stored in secrets manager whose updated values are fetched during pre-build phase. Post creation, a script run at launch of the EC2 jumphost will import the data into the newly created RDS Postgres Database. We can hit the load balancer endpoint to get the required output of the API as shown below.

![task-output](https://user-images.githubusercontent.com/34398133/195433616-838c0bc2-6f39-4ea9-bd63-eb3ccf7a5734.png)

We can map the same to a domain as well using Route 53 or any other DNS provider.


## Case: Data ingestion pipeline

### Extended service

#### Architecture
![Untitled Diagram drawio](https://user-images.githubusercontent.com/34398133/195438651-09624f53-9ea5-44ea-a652-ef92e1989639.png)

Imagine that for providing data to fuel this service, you need to receive and insert big batches of new prices, ranging within tens of thousands of items, conforming to a similar format. Each batch of items needs to be processed together, either all items go in, or none of them do.

Both the incoming data updates and requests for data can be highly sporadic - there might be large periods without much activity, followed by periods of heavy activity.

High availability is a strict requirement from the customers.

* How would you design the system?
* How would you set up monitoring to identify bottlenecks as the load grows?
* How can those bottlenecks be addressed in the future?

Provide a high-level diagram, along with a few paragraphs describing the choices you've made and what factors you need to take into consideration.

### Additional questions

Here are a few possible scenarios where the system requirements change or the new functionality is required:

1. The batch updates have started to become very large, but the requirements for their processing time are strict.

2. Code updates need to be pushed out frequently. This needs to be done without the risk of stopping a data update already being processed, nor a data response being lost.

3. For development and staging purposes, you need to start up a number of scaled-down versions of the system.

Please address *at least* one of the situations. Please describe:

- Which parts of the system are the bottlenecks or problems that might make it incompatible with the new requirements?
- How would you restructure and scale the system to address those?
