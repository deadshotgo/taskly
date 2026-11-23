# syntax=docker/dockerfile:1

FROM golang:1.27.3-alpine AS base
WORKDIR /src

# dev: образ для розробки. Код монтується з хоста, air перезбирає й перезапускає при змінах.
FROM base AS dev
RUN go install github.com/air-verse/air@v1.67.4
CMD ["air", "-c", ".air.toml"]

# build: компіляція статичного бінарника для продакшну.
FROM base AS build
COPY go.mod go.sum* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/app ./cmd/notifier

# prod: мінімальний образ. Останній етап — його збирає docker build без --target.
FROM gcr.io/distroless/static-debian12:nonroot AS prod
COPY --from=build /out/app /app
USER nonroot:nonroot
ENTRYPOINT ["/app"]
