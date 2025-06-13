ARG NODE_VERSION=20
FROM node:${NODE_VERSION} 

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/
COPY static/ /usr/share/nginx/html/static/
# Si también tienes tus personalizaciones en algún archivo CSS o JS dentro de src/,
# deberías copiarlos también, o construir el proyecto primero si usa un build step.
# Por ahora, con index.html y static/ es lo básico.

EXPOSE 3000

CMD ["npm", "start", "--", "--host", "0.0.0.0"]