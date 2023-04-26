#!/bin/bash

# Create 200MB of data
echo "Create Data"

# Define variables
DATABASE_FILE="sample-data.db"
TABLE_NAME="mytable"
NUM_ROWS=1000000 # number of rows to insert into the table

# Generate SQL commands to create table and insert data
CREATE_TABLE_COMMAND="CREATE TABLE $TABLE_NAME (id INT, name TEXT);"
INSERT_DATA_COMMAND="INSERT INTO $TABLE_NAME VALUES"

# Create SQLite database and table
echo "Creating database file $DATABASE_FILE..."
sqlite3 $DATABASE_FILE "$CREATE_TABLE_COMMAND"

# Insert data into table in batches
for (( i=1; i<=$NUM_ROWS; i+=100 ))
do
  BATCH_SIZE=$((NUM_ROWS-i+1 < 1000 ? NUM_ROWS-i+1 : 1000))
  SQL_COMMANDS="$INSERT_DATA_COMMAND"
  for (( j=0; j<BATCH_SIZE; j++ ))
  do
    ROW_NUM=$((i+j))
    SQL_COMMANDS+=" ($ROW_NUM, 'Name $ROW_NUM')"
    if (( j < BATCH_SIZE-1 ))
    then
      SQL_COMMANDS+=','
    fi
  done
  sqlite3 $DATABASE_FILE "$SQL_COMMANDS"
done

echo "Done."
