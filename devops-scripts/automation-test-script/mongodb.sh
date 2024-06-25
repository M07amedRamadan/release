#!/bin/bash
docker stop mongo && docker rm mongo
docker volume prune -a -f
docker run -d --name mongo -p 4040:27017 --ulimit nofile=500000 -e MONGO_INITDB_ROOT_USERNAME=<mongosh-user> -e MONGO_INITDB_ROOT_PASSWORD=<mongosh-password>  mongo:latest
sleep 10
docker exec mongo bash -c  'mongodump --uri="mongodb+srv://<backup-User>:<backup-password>@cluster0.ghbhwuc.mongodb.net"  --forceTableScan && mongorestore --drop --username adminmongosh --password mongoshpassword --nsExclude='admin.*''

docker exec mongo bash -c 'mongosh --host localhost --port 27017 -u <mongosh-user> -p <mongosh-password> --authenticationDatabase admin <<EOF
use libraries
db.createUser({
    user: "<DB-user>",
    pwd: "<DB-password>",
    roles: [{ role: "readWrite", db: "libraries" }]
})
EOF'

docker exec mongo bash -c 'mongosh --host localhost --port 27017 -u <mongosh-user> -p <mongosh-password> --authenticationDatabase admin <<EOF
use nonProdJwtUserAccessDb
db.createUser({
    user: "<DB-user>",
    pwd: "<DB-password>",
    roles: [{ role: "readWrite", db: "nonProdJwtUserAccessDb" }]
})
EOF'

docker exec mongo bash -c 'mongosh --host localhost --port 27017 -u <mongosh-user> -p <mongosh-password> --authenticationDatabase admin <<EOF
use dataAnalyticsDb
db.createUser({
    user: "<DB-user>",
    pwd: "<DB-password>",
    roles: [{ role: "readWrite", db: "dataAnalyticsDb" } ]
})
EOF'