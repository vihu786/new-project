#!/bin/bash

#Pull the repo code in local 
sudo git clone https://github.com/fliprlab/devops-task.git

# Variables
search_text="localhost"
replace_text="13.127.88.246"
directory="./devops-task"

# Find and replace text in all files in the specified directory
find "$directory" -type f -exec sed -i "s/$search_text/$replace_text/g" {} +
## Old and new MONGO_URI values
file="./devops-task/backend/.env"
old_uri="MONGO_URI=mongodb://mongo:27017/sampleApp"
new_uri="MONGO_URI=mongodb://13.127.88.246:27017/sampleApp"

# Use sed to replace the old URI with the new one
sed -i "s|${old_uri}|${new_uri}|g" "$file"
echo "MONGO_URI has been updated in $file."
cp  Dockerfile-backend  ./devops-task/backend
mv ./devops-task/backend/Dockerfile-backend ./devops-task/backend/Dockerfile
cp  Dockerfile-frontend  ./devops-task/frontend
mv ./devops-task/frontend/Dockerfile-frontend ./devops-task/frontend/Dockerfile
echo "Docker file has been copied successuflly!"
# Variables
FRONTEND_IMAGE="viru786/frontend1"
BACKEND_IMAGE="viru786/backend1"
VERSION=$(date +%Y%m%d%H%M%S)  # Version based on current date and time

# Step 1: Build Docker images
echo "Building Docker images..."
docker build -t ${FRONTEND_IMAGE}:${VERSION} ./devops-task/frontend
docker build -t ${BACKEND_IMAGE}:${VERSION} ./devops-task/backend

# Step 2: Tag images with appropriate versions
echo "Tagging images..."
docker tag ${FRONTEND_IMAGE}:${VERSION} ${FRONTEND_IMAGE}:latest
docker tag ${BACKEND_IMAGE}:${VERSION} ${BACKEND_IMAGE}:latest

# Step 3: Push images to Docker Hub
echo "Pushing images to Docker Hub..."
docker push ${FRONTEND_IMAGE}:${VERSION}
docker push ${FRONTEND_IMAGE}:latest
docker push ${BACKEND_IMAGE}:${VERSION}
docker push ${BACKEND_IMAGE}:latest

# Step 4: Update docker-compose.yml file with new image versions
echo "Updating docker-compose.yml with new image versions..."
sed -i "s|${FRONTEND_IMAGE}:.*|${FRONTEND_IMAGE}:${VERSION}|g" docker-compose.yml
sed -i "s|${BACKEND_IMAGE}:.*|${BACKEND_IMAGE}:${VERSION}|g" docker-compose.yml

# Step 5: Run Docker Compose to start the application
echo "Starting the application with Docker Compose..."
docker-compose down  # Stop any existing containersi
docker-compose up -d # Start new containers with latest images




echo "Application is up and running with updated images!"

