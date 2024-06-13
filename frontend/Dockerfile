FROM node:20-alpine

RUN apk add --no-cache  \
    libc6-compat

WORKDIR /frontend

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

COPY . .

EXPOSE 4200

CMD ["yarn", "dev"]
