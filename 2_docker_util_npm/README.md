# docker-practice-nodejs-and-react
This project is a simple practice to set up docker utility for running npm command.

## Setup Instructions
Suggest to use Docker and Docker Compose to run this app.


### Step 1.
change directory to the target directory
```bash
cd 2_docker_util
```

### Step 2.
To create the images and run the containers and then run npm command:
```bash
# docker-compose run --rm npm ${command}
docker-compose run --rm npm init 
docker-compose run --rm npm install 
docker-compose run --rm npm install express --save 
```

