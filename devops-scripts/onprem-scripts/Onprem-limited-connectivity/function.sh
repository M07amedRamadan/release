vultara_up() {
    gpg --batch --yes --passphrase-file "$PWD/.key/keyfile" -d "$PWD/.docker-compose.yml" > "$PWD/docker-compose.yml"
    docker compose -f $PWD/docker-compose.yml up -d
    rm -f $PWD/docker-compose.yml
  }
vultara_down() {
    gpg --batch --yes --passphrase-file "$PWD/.key/keyfile" -d "$PWD/.docker-compose.yml" > "$PWD/docker-compose.yml"
    docker compose -f $PWD/docker-compose.yml down
    rm -f $PWD/docker-compose.yml
  }
Encrypt() {
    rm -f $PWD/.docker-compose.yml
    gpg --batch --yes --passphrase-file "./.key/keyfile" -c -o ./.docker-compose.yml docker-compose.yml
    rm -f $PWD/docker-compose.yml
  }