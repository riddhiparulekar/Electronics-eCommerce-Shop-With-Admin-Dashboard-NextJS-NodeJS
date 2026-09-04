FROM node:20

WORKDIR /app

COPY packages*.json ./
RUN npm install

COPY . .

RUN npx prisma generate 

EXPOSE 3001

CMD ["node", "app.js"]

