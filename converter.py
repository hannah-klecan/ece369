input_file = "data_mem.mem"
output_file = "data_mem_con.mem"

with open(input_file, "r") as infile, open(output_file, "w") as outfile:
    for line in infile:
        # Extract the part after '<='
        if '<=' in line:
            hex_value = line.split('<=')[1].strip().rstrip(';')  # Remove ';'
            # Remove the "32'h" or similar prefixes
            if "h" in hex_value:
                hex_value = hex_value.split("h")[1]
            # Convert to uppercase hex and pad to 8 digits
            formatted_hex = f"{int(hex_value, 16):08X}"
            outfile.write(f"{formatted_hex}\n")