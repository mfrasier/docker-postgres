#!/bin/bash
#restore_dump.sh
# restore database dump file specified in $REFERALL_DUMP_FILE
# directory is set via $REFERALL_DUMP_DIR
# this runs post container start via docker exec ...
if [ -n "$REFERALL_DUMP_FILE" ]; then
	echo "restoring dump file $REFERALL_DUMP_FILE from $REFERALL_DUMP_DIR"
	if [ -f "$REFERALL_DUMP_DIR/$REFERALL_DUMP_FILE" ]; then
		gosu postgres psql < "$REFERALL_DUMP_DIR/$REFERALL_DUMP_FILE"
	else
		echo "$REFERALL_DUMP_DIR/$REFERALL_DUMP_FILE not found"
		exit 1
	fi
else
	echo "no dump file specified"
fi

exit 0