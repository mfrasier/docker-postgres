# use official postgres:9.3 docker base image
FROM postgres:9.3

# refers to container directory to store sql init commands, etc
ENV REFERALL_DIR /referall

# this is sharedhost  directory for sql dump file 
# specified using docker run -v <local_dir>:<REFERALL_DUMP_DIR> ...
# this value can be overridden at container runtime with -e REFERALL_DUMP_DIR=...
ENV REFERALL_DUMP_DIR /dumps

# placeholder for database dump file
# specify using -e switch on container run
# used for exec of restore_dump.sh
ENV REFERALL_DUMP_FILE ""

# install a tiny vi editor
RUN apt-get -qq update && apt-get install -yqq elvis-tiny

# init script(s) to $REFERALL_DIR
ADD sql $REFERALL_DIR/sql

# post-init script(s) to $REFERALL_DIR
ADD scripts $REFERALL_DIR/scripts

# this will be called from docker-entrypoint.sh to initialise db before it starts in multi-user mode
ADD scripts/referall-init.sh /docker-entrypoint-initdb.d/
