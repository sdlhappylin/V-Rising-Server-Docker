# Dockerfile for V-Rising Server  
From fragsoc/steamcmd-wine-xvfb to building VRising Server docker image.  
This is a private docker image.  
## Useage  
### Build docker image on local  
*Suppose you are using Ubuntu20.04 and have git, docker and docker-compose installed.*  
*Please find out the usage of ubuntu docker and docker-compose by yourself.*  
#### 1. Clone the repo  
    git clone https://github.com/sdlhappylin/V-Rising-Server-Docker.git
#### 2. Enter the directory V-Rising-Server-Docker  
    cd V-Rising-Server-Docker
#### 3. Build image  
    docker build . -t v-rising-server-docker
#### 4. Make directory and set permissions for your server-data  
*Very Important ！！ If you do not set it ,the container will not setup save in volume!!*  
```
mkdir /path/for/server-data && chmod -R 777 /path/for/server-data
```  
#### 5. Use docker-compose or run docker container  
#####  use docker-compose:  
* new docker-compose.yml  
```
version: "3.1"
services: 
  vrising: 
    container_name: v-rising-server-docker
    image: v-rising-server-docker #need to be changed to your own image name
    volumes: 
      - /path/for/server-data:/vrising/.wine/drive_c/VRisingServer/server-data
    ports: 
      - "9876:9876/udp"
      - "9877:9877/udp"
    restart: unless-stopped
```  
*The image name should change to you own repository name and image name if you are using GitHub Action or other dockeregistry like DockerHub.(format: repository/imagename:latest or ghcr.io/repository/imagename:latest)*  
* run docker-compose  
```
docker-compose up -d
```  
##### run docker containder  
    sudo docker run --name V-Rising-Server-Docker -p 9876:9876/udp -p 9877:9877/udp -v /path/for/server-data:/vrising/.wine/drive_c/VRisingServer/server-data v-rising-server-docker
#### 6. Copy Settings to /path/for/server-data  
#### 7. Refer to the ["V Rising Dedicated Server Instructions"](https://github.com/StunlockStudios/vrising-dedicated-server-instructions)  to modify the ServerHostSettings.json ServerGameSettings.json in Settings directory.  
### Fork the repository and use GitHubActions  
#### 1. Fork the repository  
#### 2. New repository secret  
Click "New repository secret" in "YourReposeitoryPage->Settings->Security->Secrets->Actions" to create an "Actions secrets" and name CR_PAT, then set the value to your "access tokens" which you get in [Personal access tokens](https://github.com/settings/tokens).  
#### 3. Run docker login and then input your password  (on your own server)
    docker login ghcr.io
#### 4. Run docker pull  
    docker pull ghcr.io/yourname/v-rising-server-docker
#### 5. Other steps reference to ["Build docker image on local"](#build-docker-image-on-local).  
## Can not create server-data  
Perhaps volume permission denied.  
You can do somethings like this:  
```
chmod -R 777 /path/for/server-data
```  
or  
```
sudo docker run  –privileged=true --name V-Rising-Server-Docker -p 9876:9876/udp -p 9877:9877/udp -v /path/for/server-data:/vrising/.wine/drive_c/VRisingServer/server-data v-rising-server-docker
```  
