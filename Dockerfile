FROM node:latest
WORDIR /app
COPY package.json ./
RUN npm install
COPY . .
CMD["npm","service.json"]
