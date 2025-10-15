# ---------- Build stage ----------
FROM golang:1.22 AS build
WORKDIR /app
COPY . .
RUN go build -o server ./main.go

# ---------- Runtime stage ----------
FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=build /app/server /app/
EXPOSE 8443
ENTRYPOINT ["/app/server"]
