FROM node:14.17.5-alpine

COPY . .

RUN npm install

EXPOSE 3000

CMD [ "npm", "start" ]