FROM nginx:alpine

# Create nginx user and set up directories
RUN mkdir -p /var/cache/nginx /var/log/nginx /var/run && \
    chown -R nginx:nginx /var/cache/nginx /var/log/nginx /var/run /usr/share/nginx/html

# Copy static files
COPY --chown=nginx:nginx . /usr/share/nginx/html

# Copy nginx configurations
COPY --chown=nginx:nginx nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=nginx:nginx nginx-main.conf /etc/nginx/nginx.conf

# Switch to nginx user
USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]

