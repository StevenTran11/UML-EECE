entity make_ppm is
end entity make_ppm;

architecture demo of make_ppm is
begin

	write_file: process is
		file out_file: text open write_mode is "my_picture_file.ppm";
		variable out_line: line;
		variable r, g, b: natural range 0 to 15;
	begin
		-- magic number
		write(out_file, "P3" & LF);
		-- resolution
		write(out_file, "40 20" & LF);
		-- maximum color
		write(out_file, "15" & LF);

		for j in 0 to 19 loop
			for i in 0 to 39 loop
				r := i mod 16;
				g := (i + j) mod 16;
				b := (15 - j) mod 16;
				-- write pixel to file
				write(out_line,
						integer'image(r) & " "
							& integer'image(g) & " "
							& integer'image(b));
				writeline(out_file, out_line);
			end loop;
		end loop;
		
		wait;
	end process write_file;

end architecture demo;