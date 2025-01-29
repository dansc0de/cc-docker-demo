# base image to build our app from
FROM golang:1.22 AS build

# setting working directory in the container
WORKDIR /app

# copy go modules
COPY go.mod go.sum ./
RUN go mod download

# copy source code
COPY main.go ./
RUN go mod tidy

# build the artifact
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /bin/server main.go

# smallest image to run our application
FROM scratch

# copy some certificate from the "build" stage
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# setting working directory in the container
WORKDIR /usr/bin

# copy server artifact from the final stage
COPY --from=build /bin/server /usr/bin/server

# expose port 8080
EXPOSE 8080

# set entrypoint or "instructions on starting the container"
ENTRYPOINT ["/usr/bin/server", "--port", "8080"]
