
## Docker container for referall postgresql database

* uses official postgres:9.3 base image
* scripts and sql directories are copied into container
* sql from sql/*.sql files ris executed before the database starts in multi-user mode.  i.e. they are run in single-user mode.
* can specify a dump file to restore once database starts.
    * Copy desired plain-text dump file to directory shared as /dumps (see --volume switch on run command)
    * Specify dump file name at container run-time using env var REFERALL_DUMP_FILE
    * Exec /referall/scripts/restore_dump.sh

## Sample commands to create and run our custom postgresql container

### Build image

Build new image tagged as referall/postgres:9.3
```
docker build -t referall/postgres:9.3 .
```

### Create and run a new container

Start new container from image referall/postgres:9.3 with following attributes.

* named pg1
* detached container (long-running daemon-like)
* container TCP port 5432 mapped to docker host port 5432
* volume /dumps mapped to local dir ./dumps
* REFERALL_DUMP_FILE set to point at dumps/okcra-api-data-2014-12-04-0432.sql
* postgres user password is set to 'secret'.  This is just for testing!

The container id is returned from the run command, that big long string.
```
docker run \
  --name pg1 \
  --detach \
  --publish 5432:5432 \
  --volume $(pwd)/dumps:/dumps \
  --env POSTGRES_PASSWORD=secret
  --env REFERALL_DUMP_FILE=okcra-api-data-2014-12-04-0432.sql \ 
  referall/postgres:9.3
b160e7010cf3724d01b9d3f3b85e2e11addd0c6483c2465c7d8c7d038b39f75d
```

### Restore dump file into new container

Restores the dump file specified above
```
docker exec -t pg1 /referall/scripts/restore_dump.sh
```

### A few test queries

psql access via virtual machine TCP port (default 5432)
```
psql -h 192.168.59.103 -U postgres -l
psql -h 192.168.59.103 -U postgres -d referall -c '\dt'
```
