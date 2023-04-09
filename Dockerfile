# Specify a base image
# Go to docker hub and find a base image with the dependencies that you want
# in this case, we are looking for a node image with its dependencies (*** note: package.json and local files are excluded)
# Hence, once we run docker build .
# It will start Create a temp container, then take an image of it and store in cache
# discard the container
FROM node:14-alpine

# NOTE: We need to include the files in image fs from our harddisk which is package.json and index.js
# Create a workdir 1st in the container, to allowed the files to be copied into
# this will be auto created if it does not already exists!
WORKDIR /usr/app
# Then... COPY  from ./ {current working dir we want to copy to fs} to ./ {dir to copy into container fs}
# Note: we need to ensure that by changing any source codes in our fs, we do not run or reinstall our dependencies 
# in the next rebuild. Hence, we specific the specific package to copy
COPY ./package.json ./


# Install some dependencies - 
# Take the image from above, then create a temp container
# take a snapshot of the filesystem of the container, then store it as an image in cache
# discard the temp container
RUN npm install
# Unless there are changes to the above in the rebuild
COPY ./ ./


# Default command
# Take the image from the above, then create a temp container
# Take a snapshot of the container along with the cmd below, then save as an image in cache
# discard the temp container
CMD ["npm", "start"]

# Steps in docker cli: 
#  ---  docker build -t goodwill80/simplenodejs .
# npm start runs server on post 8080, but alphine image does not have this info
# Therefore, we need specify and map the port in our docket run command
# PORT MAPPING : docker run -p {incoming req to this port}:{ port inside the container} <projId/projName>
#  ---  docker run -p 3000:8080 goodwill80/simplenodejs 
# App should run now!

# Running shell inside the container
# --- docker run -it goodwill80/simplenodejs sh
# You'll see that all project files are stored in the WORKDIR -- /usr/app
