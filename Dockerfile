# BUILD PHASE
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
# NOTE: this command builds app to: /app/build directory (this output dir
# is based on whatever tool is actually "building" the output, but is generally
# called "build" when using node modules to do so)
RUN npm run build

# RUN PHASE
# you can imagine that `FROM` 'terminates' the previous block
FROM nginx
# copy from build phase, the directory from that container, and the output dir
# this dest dir is specified in nginx dockerhub documentation
# see: https://hub.docker.com/_/nginx - Hosting some simple static content
COPY --from=builder /app/build /usr/share/nginx/html
# we don't have to "run" nginx, as this container is designed to do that 
# automatically