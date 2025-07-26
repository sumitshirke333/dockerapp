FROM node:20-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
EXPOSE 8080
CMD ["node", "src/index.js"]
