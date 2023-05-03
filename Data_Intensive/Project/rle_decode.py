import sys

def rle_decode(data):
    """
    Performs run length decoding on a given string of data
    """
    decoded_data = ""
    count = ""

    for char in data:
        if char.isdigit():
            count += char
        else:
            try:
                decoded_data += int(count) * char
            except ValueError:
                decoded_data += char
            count = ""

    return decoded_data

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python rle_decode.py <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    # Read the input file
    with open(input_file, "r") as f:
        encoded_data = f.read()

    # Perform RLE decoding on the data
    decoded_data = rle_decode(encoded_data)

    # Write the decoded data to a new file
    with open(output_file, "wb") as f:
        f.write(decoded_data.encode('ISO-8859-1'))
