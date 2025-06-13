ARG NODE_VERSION=20
FROM node:${NODE_VERSION} 

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci

FROM nginx:alpine
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Asegúrate que index.html y static/ no están en la raíz, sino dentro de build/
COPY build/ /usr/share/nginx/html/
# Si NGINX necesita acceder directamente a subcarpetas como static/, también puedes poner:
# COPY build/static/ /usr/share/nginx/html/static/
# Pero COPY build/ /usr/share/nginx/html/ suele ser suficiente si build/ contiene todo lo estático.

EXPOSE 3000

CMD ["npm", "start", "--", "--host", "0.0.0.0"]