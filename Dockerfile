# build

FROM node:22.15.0-bullseye AS build

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    autoconf \
    automake \
    zlib1g-dev \
    libpng-dev \
    libvips-dev

COPY package.json package-lock.json ./
RUN npm install --omit=dev

COPY . .

RUN npm run build



# serve

FROM node:22.15.0-bullseye AS serve

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends libvips-dev && \
    rm -rf /var/lib/apt/lists/*

COPY . .
COPY --from=build /opt/app/node_modules/ ./node_modules
COPY --from=build /opt/app/dist/ ./dist

RUN chown -R node:node /opt/app
USER node

EXPOSE 1337
CMD ["npm", "run", "start"]
