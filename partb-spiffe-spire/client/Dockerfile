FROM golang:1.22 AS build
WORKDIR /app
COPY . .
RUN go mod init client || true
RUN go mod tidy
RUN go build -o client ./main.go

FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=build /app/client /app/
ENTRYPOINT ["/app/client"]
