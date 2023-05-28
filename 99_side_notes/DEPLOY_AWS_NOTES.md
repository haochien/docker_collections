
# Virtual Machine: EC2
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

## 3. Deploy built image
Instead of using traditional way to deploy entire source, we can built the docker image, upload to the repository (e.g. Dockerhub), and download from vm.

### 3.1 create dockerhub repository:
![EC2_9](./img/EC2_9.png)

