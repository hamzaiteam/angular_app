# ---- Stage 1: Build Angular App ----
    FROM node:16-alpine AS build
    WORKDIR /app
    
    # Copy package.json and package-lock.json
    COPY package*.json ./
    RUN npm install
    
    # Copy the rest of the source code
    COPY . .
    
    # Build the Angular app
    RUN npm run build
    
    # ---- Stage 2: Serve with NGINX ----
    FROM nginx:alpine
    # Copy build output to NGINX's default public folder
    COPY --from=build /app/dist /usr/share/nginx/html
    
    # Expose port 80
    EXPOSE 80
    
    # Start NGINX
    CMD ["nginx", "-g", "daemon off;"]
    