# docker-practice-nodejs-and-react
This project is a practice to set up php laravel app with nginx web server from docker.

## Setup Instructions
Suggest to use Docker and Docker Compose to run this app.


### Step 1.
change directory to the target directory
```bash
cd 3_laravel_php_app_with_nginx
```

### Step 2.
update env variables in env/mysql.env if it is required

### Step 3.
initiate laravel app into src folder
```bash
docker-compose run --rm composer create-project --prefer-dist laravel/laravel:^8.0 .
```

### Step 4.
Change db connection setting in src/.env for mysql to what you just defined in step 2
```env
# example:
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret
```

### Step 5.
To create the images and run the containers:
```bash
docker-compose up -d --build server

# to stop containers:
docker-compose down
```

### Step 6.
To run db migration:
```bash
docker-compose run --rm artisian migrate
```

### Step 7.
start server on http://localhost:8000/
