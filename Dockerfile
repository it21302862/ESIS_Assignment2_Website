# Use a lightweight web server image
FROM nginx:alpine

# Copy all site files into Nginx's default HTML folder
COPY . /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
