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

#### Explanation

Considering the unpredictable nature of volumes of data to be ingested and the requirement of High Availability, the critical aspects or possible bottlenecks can be the capacity of the server ingesting the data into the database and the capabilities of the database to manage large amount of incoming data ingestion along side the existing traffic from the application in a way that regular application usage and activities are not affected. Also, expanding the storage withinn less time considering large amounts of incoming data can be a critical point. Due to the mentioned reasons, AWS Batch and Amazon Aurora for compute and database respectively would be suitable for this scenario. We have considered S3 as the storage for Data / DB Dump prior to ingestion and Lmabda to trigger the AWS Batch jobs. Due to AWS Batch requiring a docker image for running its containerised workloads, the process of building a docker file and uploading the same to Elastic Container Registry (ECR) is automated.

AWS Batch is specifically designed for running large workloads parallely as a managed service (although it has unmanaged options as well). The compute environment, which uses ECS with either EC2 instances or Fargate is provisioned according to each jobs priority in the queue and workload requirements. We can specify the instances types, family and the minimum, maximum and desired instances. Keeping minimum instances as 0 will save a lot of cost as instances will be provisioned only when a job is ready to run will terminate after the job is complete. For Database, Amazon Aurora has much more capabilities in terma of scalability, availablity, disaster recovery and effectively balancing traffic. It can scale up or down in very less time according to requirements. For monitoring and alerts, we can use Cloudwatch along with Simple Notification Service(SNS) to send notifications once a decided threshhold is crossed. The Cloudwatch alarms based on selected metrics like cpu utilization, memory utlization can be useful to upscale or downscale the infra based on the load.


### Additional questions

1. The batch updates have started to become very large, but the requirements for their processing time are strict.

Answer: AWS Batch compute provisioning time for a ready job in the queue can sometimes be a bottleneck in this scenario, especially in case of minimum instances set to zero. Also, in case of very large batch updates, Fargate might not be suitable as it doesn't support GPUs currently. Therefore, it will be wise to keep minimum instance of 1 in case of expeted large batch updates which will reduce the compute provioning time for ready jobs. Also, instead of fargate, ECS with EC2 nodes should be selected in AWS Batch for the option of GPU instance classes. For database, Aurora needs to be used in place of regular RDS with Multi AZ replica nodes and autoscaling enabled for both instance and disk.

2. Code updates need to be pushed out frequently. This needs to be done without the risk of stopping a data update already being processed, nor a data response being lost.

Answer: Frequent Code Update and subsequent frequent deployments can be a bottleneck as the application might momentarily loose connectivity with the database or might suffer minor downtime which might result in loss of data or inconsistant data due to the user activity during deployment. The solution to this is using Blue Green deployment provided by Codedeploy/Codepipeline. It is a costly option but will create an identical (Green) environment to the existing (Blue). While the blue environment is stable, changes can be applied and tested on the green environment. Once stable, the traffic can be routed to the green environment while deployments go on in blue environment. Using Aurora, database can be scaled to accomodate traffic from two environments with occasional high or low rates. This will ensure that neither loss of data nor stoppage of data update takes place

3. For development and staging purposes, you need to start up a number of scaled-down versions of the system.

Answer: For development and staging environments, scaled down environment is ok in initial phases when features are less, traffic is negligible and cost saving is important. As features increases, the low configurations become bottlenecks in the intended flow of the application. This may lead to an overall delay in the timeline as due to dependency of any one bottleneck, implmenetation and testing of critical features takes considerable time.Also it is difficult to predict how much load can be handled by the application if the ennvironment is scaled down too much as we cannot directly test the same on production. Setting up auto scaling, using serverless services like lambda, Shutting down non-production systems during night hours and weekends are comparatively better ways of saving cost rather than downscaling the enviroments more than required.
