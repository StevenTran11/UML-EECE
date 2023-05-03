import argparse

CHUNK_SIZE = 1024 * 1024  # 1 MB

def encode_data(input_file, output_file):
    # Initialize variables for encoding
    current_byte = None
    current_count = 0
    encoded_data = bytearray()

    # Read the input file in chunks and encode the data using run-length encoding
    with open(input_file, 'rb') as f:
        while True:
            chunk = f.read(CHUNK_SIZE)
            if not chunk:
                # End of file
                break
            
            for byte in chunk:
                if current_byte is None:
                    current_byte = byte
                    current_count = 1
                elif byte == current_byte and current_count < 255:
                    current_count += 1
                else:
                    encoded_data.append(current_count)
                    encoded_data.append(current_byte)
                    current_byte = byte
                    current_count = 1
    
    # Encode the last byte sequence
    encoded_data.append(current_count)
    encoded_data.append(current_byte)

    # Write the encoded data to the output file
    with open(output_file, 'wb') as f:
        f.write(encoded_data)


def decode_data(input_file, output_file):
    # Initialize variables for decoding
    decoded_data = bytearray()

    # Read the encoded data from the input file in chunks and decode it using run-length encoding
    with open(input_file, 'rb') as f:
        while True:
            chunk = f.read(CHUNK_SIZE)
            if not chunk:
                # End of file
                break
            
            i = 0
            while i < len(chunk):
                count = chunk[i]
                byte = chunk[i+1]
                decoded_data.extend([byte] * count)
                i += 2

    # Write the decoded data to the output file
    with open(output_file, 'wb') as f:
        f.write(decoded_data)


if __name__ == '__main__':
    # Parse command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('input_file', help='path to input file')
    parser.add_argument('output_file', help='path to output file')
    parser.add_argument('-d', '--decode', action='store_true', help='decode the input file')
    args = parser.parse_args()

    # Call the appropriate function based on the command line arguments
    if args.decode:
        decode_data(args.input_file, args.output_file)
    else:
        encode_data(args.input_file, args.output_file)
