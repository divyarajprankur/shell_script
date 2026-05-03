#!/bin/bash
IMAGE_NAME="custom-mysql:8"
CONTAINER_NAME="mysql-container"
MYSQL_ROOT_PASSWORD="root123"
MYSQL_DATABASE="mydb"
MYSQL_USER="devuser"
MYSQL_PASSWORD="devpass"
echo "==========================================="
echo "Step 1: Creating SQL file..."
echo "==========================================="
cat <<EOF > init.sql
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

USE ${MYSQL_DATABASE};

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO users (name, email) VALUES
('Divya', 'divya@example.com'),
('Raj', 'raj@example.com');

EOF

echo "==========================================="
echo "Step 2: Creating Dockerfile..."
echo "==========================================="




cat <<EOF >Dockerfile
FROM mysql:8
ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
ENV MYSQL_DATABASE=${MYSQL_DATABASE}
ENV MYSQL_USER=${MYSQL_USER}
ENV MYSQL_PASSWORD=${MYSQL_PASSWORD}
COPY init.sql /docker-entrypoint-initdb.d/

EOF

echo "==========================================="

echo "Step 3: Building Docker Image..."

echo "==========================================="

docker build -t ${IMAGE_NAME} .

echo "==========================================="

echo "Step 4: Running Container..."
echo "==========================================="
docker run -d \
  --name ${CONTAINER_NAME} \
  -p 3306:3306 \
  ${IMAGE_NAME}

echo "==========================================="

echo "Done! MySQL is running."
echo "==========================================="

