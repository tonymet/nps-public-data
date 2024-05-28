FROM us-west1-docker.pkg.dev/tonym-us/gcloud-lite/gcloud-lite

RUN apk add --no-cache zsh jq
ADD app/* /app/
WORKDIR /app
ENTRYPOINT [ "/bin/zsh", "/app/migrate-all.sh" ]