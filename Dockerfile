FROM node:20

WORKDIR /app

COPY packages*.json ./
RUN npm install

COPY . .

RUN npx prisma generate 
RUN npm run build 

EXPOSE 3000

CMD ["npm", "start"]

