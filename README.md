# docker-postgresql

postgres using uid 1000

Dockerfile [cloud-ready/docker-postgresql on Github](https://github.com/cloud-ready/docker-postgresql)

[cloudready/postgresql on Docker Hub](https://hub.docker.com/r/cloudready/postgresql/)


see: https://hub.docker.com/_/postgres/

A replacement for sonarqube's embedded H2 database.

`docker-compose up -d`

Create database for sonarqube

see: https://github.com/sameersbn/docker-postgresql/issues/58

`docker exec -it postgres psql -U postgres -c "CREATE DATABASE sonar;"`
`docker exec -it postgres psql -U postgres -c "CREATE USER sonar SUPERUSER PASSWORD 'sonar';"`
`docker exec -it postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE sonar TO sonar;"`

or

```
psql -v ON_ERROR_STOP=1 -h postgres --username "user" <<-EOSQL
    CREATE DATABASE sonar;
    CREATE USER sonar SUPERUSER PASSWORD 'sonar';
    GRANT ALL PRIVILEGES ON DATABASE sonar TO sonar;
EOSQL
```

`psql -h postgres -d sonar -U sonar -W`

Backup data

`docker exec -t postgres pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql`

`docker exec -t postgres pg_dumpall -c -U postgres | gzip > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql.gz`

Restore data

`cat your_dump.sql | docker exec -i postgres psql -U postgres`
