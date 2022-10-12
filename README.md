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

### Pre-requisite
 - AWS CLI
 - AWS Access credentials/IAM Role attached to the instance
 - Terraform 0.14
 
 IAM User/Role should have List,Read,Write and Tagging access of the following services: EC2, S3, VPC, ECS, Codepipeline, Codebuild, IAM, Secret Manager, RDS, ELB, Cloudwatch

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
Currently Codepipeline does no accept any Github related credentials via terraform. We have to login our Github credentials via AWS Console in Codepipeline.


![xen-update-connection](https://user-images.githubusercontent.com/34398133/195197078-3060a5c9-82ae-4a2b-b0a3-a7a48b09dcdb.png)

#### 2. Buildspec file


### Running the database

There’s an SQL dump in `db/rates.sql` that needs to be loaded into a PostgreSQL 13.5 database.

After installing the database, the data can be imported through:

```
createdb rates
psql -h localhost -U postgres < db/rates.sql
```

You can verify that the database is running through:

```
psql -h localhost -U postgres -c "SELECT 'alive'"
```

The output should be something like:

```
 ?column?
----------
 alive
(1 row)
```

### Running the API service

Start from the `rates` folder.

#### 1. Install prerequisites

```
DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y python3-pip
pip install -U gunicorn
pip install -Ur requirements.txt
```

#### 2. Run the application
```
gunicorn -b :3000 wsgi
```

The API should now be running on [http://localhost:3000](http://localhost:3000).

#### 3. Test the application

Get average rates between ports:
```
curl "http://127.0.0.1:3000/rates?date_from=2021-01-01&date_to=2021-01-31&orig_code=CNGGZ&dest_code=EETLL"
```

The output should be something like this:
```
{
   "rates" : [
      {
         "count" : 3,
         "day" : "2021-01-31",
         "price" : 1154.33333333333
      },
      {
         "count" : 3,
         "day" : "2021-01-30",
         "price" : 1154.33333333333
      },
      ...
   ]
}
```

## Case: Data ingestion pipeline

In this section we are seeking high-level answers, use a maximum of couple of paragraphs to answer the questions.

### Extended service

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
