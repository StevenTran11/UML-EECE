#!/bin/bash

# Define the sample data set
DATA_FILE="sample-data.txt"
echo "Sample data set: $DATA_FILE"
echo "-------------------------------------"
cat $DATA_FILE
echo "-------------------------------------"

# Define the compression algorithms to test
ALGORITHMS=("Block-based compression" "Dictionary-based compression" "Delta encoding" "Run-length encoding")

# Test each compression algorithm
for ALGORITHM in "${ALGORITHMS[@]}"
do
  echo "Testing $ALGORITHM..."
  
  # Compress the sample data set
  echo "Compressing data set with $ALGORITHM..."
  START_TIME=$(date +%s.%N)
  case $ALGORITHM in
    "Block-based compression")
      COMPRESSED_FILE="sample-data-block-compressed.txt"
      tar czf $COMPRESSED_FILE $DATA_FILE
      ;;
    "Dictionary-based compression")
      COMPRESSED_FILE="sample-data-dictionary-compressed.txt"
      dictzip -k $DATA_FILE
      mv $DATA_FILE.gz $COMPRESSED_FILE
      ;;
    "Delta encoding")
      COMPRESSED_FILE="sample-data-delta-encoded.txt"
      bzip2 -zk $DATA_FILE
      mv $DATA_FILE.bz2 $COMPRESSED_FILE
      ;;
    "Run-length encoding")
      COMPRESSED_FILE="sample-data-run-length-encoded.txt"
      rlencode -c $DATA_FILE $COMPRESSED_FILE
      ;;
  esac
  END_TIME=$(date +%s.%N)
  COMPRESSION_TIME=$(echo "$END_TIME - $START_TIME" | bc)
  echo "Compression time: $COMPRESSION_TIME seconds"

  # Measure the compression ratio and output storage space
  ORIGINAL_SIZE=$(wc -c < $DATA_FILE)
  COMPRESSED_SIZE=$(wc -c < $COMPRESSED_FILE)
  COMPRESSION_RATIO=$(echo "scale=2; $ORIGINAL_SIZE / $COMPRESSED_SIZE" | bc)
  OUTPUT_SPACE=$(du -h $COMPRESSED_FILE | awk '{print $1}')
  echo "Compression ratio: $COMPRESSION_RATIO"
  echo "Output storage space: $OUTPUT_SPACE"

  # Test query performance
  echo "Testing query performance..."
  START_TIME=$(date +%s.%N)
  case $ALGORITHM in
    "Block-based compression")
      tar xzf $COMPRESSED_FILE
      ;;
    "Dictionary-based compression")
      gunzip $COMPRESSED_FILE
      ;;
    "Delta encoding")
      bunzip2 -k $COMPRESSED_FILE
      ;;
    "Run-length encoding")
      rldecode -c $COMPRESSED_FILE sample-data-decoded.txt
      ;;
  esac
  END_TIME=$(date +%s.%N)
  QUERY_TIME=$(echo "$END_TIME - $START_TIME" | bc)
  echo "Query time: $QUERY_TIME seconds"

  # Measure the compression and decompression speed
  COMPRESSION_SPEED=$(echo "scale=2; $ORIGINAL_SIZE / $COMPRESSION_TIME / 1000000" | bc)
  DECOMPRESSION_SPEED=$(echo "scale=2; $ORIGINAL_SIZE / $QUERY_TIME / 1000000" | bc)
  echo "Compression speed: $COMPRESSION_SPEED MB/s"
  echo "Decompression speed: $DECOMPRESSION_SPEED MB/s"

  echo "-------------------------------------"
done
