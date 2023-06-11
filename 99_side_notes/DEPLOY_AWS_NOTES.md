
# Manual Deploy via Own Virtual Machine (AWS EC2):
You need to create a vm via AWS EC2 and manual deploy your docker image from your local machine to vm.

PROs: full control on the virtual machine

CONs: Process is manual, and you really have to know how to properly configure the vm for security, update, ...etc. 

## 1. launch instance
### 1.1 name instance
![EC2_1](./img/EC2_1.png)
### 1.2 choose os
![EC2_2](./img/EC2_2.png)
### 1.3. choose vm instance
https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html

![EC2_3](./img/EC2_3.png)
### 1.4. network setting - define vpc 
https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html

![EC2_4](./img/EC2_4.png)
### 1.5. create key pair
key pair (will be a file in the end) is required to later connect to the vm instance via ssh 

![EC2_5](./img/EC2_5.png)

![EC2_6](./img/EC2_6.png)
### 1.6. Launch instance
### 1.7. Connect to instance from your local machine via ssh
![EC2_7](./img/EC2_7.png)

![EC2_8](./img/EC2_8.png)

For windows, check this post regarding how to set permission of file equivalent to chmod 400: https://gist.github.com/jaskiratr/cfacb332bfdff2f63f535db7efb6df93

## 2. Install Docker in virtual Machine
```bash
# Running sudo yum update -y in a Linux shell allows you to keep your system up to date with the latest security patches, bug fixes, and feature updates provided by the package repositories.
sudo yum update -y

sudo yum -y install docker
sudo service docker start

# adds the ec2-user (the user account you're currently using) to the docker group. By adding (-a) the user to the docker group (-G docker), you grant them permission to execute Docker commands without needing to use sudo. This allows the user to run Docker commands directly.
sudo usermod -a -G docker ec2-user
```

Make sure to log out + back in after running these commands.

Once you logged back in, run this command:

```bash
# configures the Docker service to start automatically when the system boots up.
sudo systemctl enable docker
```

Thereafter, you can check whether Docker is available by running:
```bash
docker version
```

## 3. Deploy built image to vm
Instead of using traditional way to deploy entire source, we can built the docker image, upload to the repository (e.g. Dockerhub), and download from vm.

### 3.1 create dockerhub repository:
![EC2_9](./img/EC2_9.png)

### 3.2 build image for the source codes from the local machine:
```bash
docker build -t test_deploy_image_1 .
docker tag test_deploy_image_1 xxhowchanxx/test_deploy_1

docker login

docker push xxhowchanxx/test_deploy_1
```

### 3.3 download image in vm
log in to vm again and run
```bash
docker pull xxhowchanxx/test_deploy_1
docker run -d --rm -p 80:80 xxhowchanxx/test_deploy_1
```

## 4. connect vm to www via Security Group setup in EC2 
### 4.1. set up Inbound Rule for instance's Security group
In default, vm only allow external to connect to it via ssh. (but the connection from vm inside to external has no limitation).

We need to allow http connection:
![EC2_11](./img/EC2_11.png)
![EC2_12](./img/EC2_12.png)
![EC2_13](./img/EC2_13.png)

### 4.2. find the public ip of the vm
find the public ip of the vm from EC2 instance page (public IPv4):
![EC2_10](./img/EC2_10.png)

And then you can browse your app via enter this ip address in your browser
***
Note: for practice, remember to stop instance while not using it.

Or you can set up an inactive alarm: https://successengineer.medium.com/how-to-automatically-turn-off-your-ec2-instance-in-2021-b73374e51090
***
<br><br><br><br>

# Manual Deploy via Managed Remote Machine (AWS ECS) - Single App:
ECS setup including: Cluster --> Service --> Task --> Container

## 1. Set up ECS
### 1.1. Define Cluster
Cluster is an overall network for running the service

![ECS_4](./img/ECS_4.png)


### 1.2. Configure Task definition and Containers
in this step, container config is similar to how you structure 'docker run' command.

Task is similar to remote machine setup. And 1 task can have multiple container.

![ECS_1](./img/ECS_1.png)

![ECS_2](./img/ECS_2.png)

Worth to mentioned here: in task, when choose Fargate as app environment, it's serverless. Unlike creating a EC2 instance, it only create a server and run the container when the corresponding request comes and stop when no requests. (thus cost effective) 

![ECS_3](./img/ECS_3.png)


### 1.3. create Service to execute Task
![ECS_5](./img/ECS_5.png)

![ECS_6](./img/ECS_6.png)

Since our app is link from external port 80 to internal port 80 and by default the public IP does not expose port 80 to the public. To fix this you'll need to update the security group settings in Service:

![ECS_7](./img/ECS_7.png)

![ECS_8](./img/ECS_8.png)

![ECS_9](./img/ECS_9.png)

### 1.4. Find the public IP address and access the app
In Task config, you can find public IP and use it to access the app from the browser.

![ECS_10](./img/ECS_10.png)


### 1.5. re-deploy update source codes
You need to rebuild the image and push it to repository (e.g. dockerhub).

Then create a revision in the Task (so the task will take the image with latest tag)

![ECS_11](./img/ECS_11.png)

Then update service by choosing the latest revision image (or you can use force new deployment option):

![ECS_12](./img/ECS_12.png)

![ECS_13](./img/ECS_13.png)

Once it is updated, you can go to the new Task and find the public ip address for browsing

![ECS_14](./img/ECS_14.png)
<br><br><br><br>

# Manual Deploy via Managed Remote Machine (AWS ECS) - Multiple Apps:
In this example, you have one node js backend app and one mongo db app

## 0. Prepare images and push to Repository
For ECS, few things need to be aware in the source code when dealing with multi containers:

### a. Cannot use container name in source code to refer to IP address.
Following codes are ok in dev, but won't work after deploy to ECS

```javascript
// in app.js: assume your mongo db container is named mongodb
mongoose.connect(
  `mongodb://${process.env.MONGODB_USERNAME}:${process.env.MONGODB_PASSWORD}@mongodb:27017/course-goals?authSource=admin`,
  ...
);
```
When deploy to ECS, the containers won't necessarily be run in the same machine (thus not the same network).

Unless the containers are run under the same ECS task, then you can use the same network (localhost ip) to connect different containers.

Thus utilize environment variable to solve this issue

```js
// in app.js
mongoose.connect(
  `mongodb://${process.env.MONGODB_USERNAME}:${process.env.MONGODB_PASSWORD}@${process.env.MONGODB_URL}:27017/course-goals?authSource=admin`,
  ...
);

// in .env file, configure the MONGODB_URL for dev you, and you need to do additional configuration for PROD:
MONGODB_URL=mongodb

// in Dockerfile:
ENV MONGODB_URL=mongodb
```

## 1. Set up ECS
### 1.1. Define Cluster
### 1.2. Configure Task definition and Containers
#### - configure 1st container node js backend in the task:
You might need to add the env variables which are only used in PROD env:

![ECS_15](./img/ECS_15.png)

You might also want to configure PROD only docker cmd to override the dev one.

(for example, you use nodemon package to run 'npm start', but you would like to run simply 'node app.js' in PROD)

![ECS_16](./img/ECS_16.png)

#### - configure 2nd container mongo db in the task:
![ECS_17](./img/ECS_17.png)

![ECS_18](./img/ECS_18.png)

