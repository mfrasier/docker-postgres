
# initialize referall database environment
# runs in docker container from postgres base image
# REFERALL_DIR is set in container - see Dockerfile for comments
# if order matters name the files for lexical sort

if [ -d "$REFERALL_DIR" ]; then
  # run sql init files
  for f in $(ls "$REFERALL_DIR"/sql/*.sql); do
  	if [ -f "$f" ]; then 
  	  echo "running sql file $f"
      gosu postgres:postgres postgres --single < "$f"
    fi
  done
else 
	echo "referall directory '$REFERALL_DIR' not found"
fi
