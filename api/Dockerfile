FROM node:16-alpine AS builder
# Set working directory for the project to /usr/src/app
# NOTE: all the directives that follow in the Dockerfile will be executed
# in working directory.
WORKDIR /usr/src/app

# Copy the contents of the project folder into the working directory of
# docker image
COPY . /usr/src/app/

# Install any needed packages specified in package.json
RUN npm install --omit=dev

FROM node:16-alpine

COPY --from=builder /usr/src/app .

RUN npm install pm2 -g

EXPOSE 4201

CMD echo "Warming up" && sleep 5

ENTRYPOINT ["pm2-runtime", "server.js"]
