# Use the official Nginx image from Docker Hub
FROM nginx:latest

# Copy local index.html file to the container
COPY index.html /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
