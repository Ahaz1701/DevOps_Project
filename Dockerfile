FROM node:14.17.5-alpine

COPY . .

RUN npm install

EXPOSE 80

CMD [ "npm", "start" ]