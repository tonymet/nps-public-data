FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine

RUN apk add --no-cache zsh jq
ADD app/* /app/
WORKDIR /app
ENTRYPOINT zsh