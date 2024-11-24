
FROM nginx:latest

RUN apt-get update -y

COPY index.html /usr/share/nginx/html

EXPOSE 80

