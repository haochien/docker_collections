# docker-practice-nodejs-and-react
This project is a simple practice to set up docker for a multi-app application.

The frontend is React, backend is NodeJS, and DB is MongoDB


## Setup Instructions
Suggest to use Docker and Docker Compose to run this app.


### Step 1.
change directory to the target directory
```bash
cd 1_node_react_multi_app
```

### Step 2.
To create the images and run the containers:
```bash
docker-compose up -d
```

To stop the container:
```bash
docker-compose down
```

### Step 3.
Open the browser and navigate to http://localhost:3000/
