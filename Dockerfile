# --- Etapa 1: Construcción del Sitio Docusaurus ---
    FROM node:lts-alpine as builder

    WORKDIR /app
    
    COPY package.json package-lock.json ./
    RUN npm install
    
    COPY . .
    RUN npm run build
    
    # --- Etapa 2: Servir el Sitio con NGINX ---
    FROM nginx:stable-alpine
    
    # Copiamos la configuración de NGINX personalizada
    COPY nginx.conf /etc/nginx/conf.d/default.conf
    
    # Eliminar la configuración por defecto de NGINX
    RUN rm /etc/nginx/conf.d/default.conf
    
    # Copiar los archivos estáticos generados desde la etapa 'builder'
    COPY --from=builder /app/build /usr/share/nginx/html/
    
    # Crear nuestro propio script de entrada
    COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
    RUN chmod +x /usr/local/bin/docker-entrypoint.sh
    
    # Exponer el puerto 80 (puerto por defecto de NGINX)
    EXPOSE 80
    
    # Usar nuestro propio script como ENTRYPOINT
    ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
    
    # CMD no es necesario si el ENTRYPOINT ya ejecuta Nginx directamente
    CMD []