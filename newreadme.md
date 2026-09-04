# App Description
Web application named Singitronic is a full stack e-commerce web app with customer facing store and admin dashboard.
Customer can browse products by category, search, filter/sort, view product details, add items to a cart or wishlist, and check out.
Admins get a separate dashboard to manage products, categories, merchants, orders, and users.
The app is split into two parts: a Next.js frontend (the website + admin UI) and a separate Node.js/Express backend (the REST API), both talking to a shared MySQL database through Prisma. 

# Optimisation Choices
Next.js - output: "standalone"  added to trace only files that are needed at runtime
Multi-stage Docker build in Dockerfile 

Base image used : node:20-alpine

layer caching

.dockerignore

# Final Image Size
Before optimzation :
Frontend image size: 1.1GB
Backend image size: 579MB

After Optimization:
Final backend image size is 129MB
Final Frontend image size is 144MB

# Architecture Notes

frontend (Next.js) + backend (Express)+ Mysql (database)  as separate containers

