import sys

def rle_encode(data):
    """
    Performs run length encoding on a given string of data
    """
    encoded_data = ""
    count = 1
    prev_char = data[0]

    for char in data[1:]:
        if char == prev_char:
            count += 1
        else:
            encoded_data += f"{count}{prev_char}"

            count = 1
            prev_char = char

    # Handle the last character
    encoded_data += f"{count}{prev_char}"

    return encoded_data

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python rle_encode.py <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    # Read the input file
    with open(input_file, "rb") as f:
        data = f.read().decode('ISO-8859-1')

    # Perform RLE encoding on the data
    encoded_data = rle_encode(data)

    # Write the RLE encoded data to the output file
    with open(output_file, "w") as f:
        f.write(encoded_data)
