# Tag image
docker tag flask-app:latest yaraamrallah/flask-app:latest

# Login to docker-hub
docker login

# Push image
docker push yaraamrallah/flask-app:latest
