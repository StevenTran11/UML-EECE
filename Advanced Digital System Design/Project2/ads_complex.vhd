---- this file is part of the ADS library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ads;
use ads.ads_fixed.all;

package ads_complex_pkg is
	-- complex number in rectangular form
	type ads_complex is
	record
		re: ads_sfixed;
		im: ads_sfixed;
	end record ads_complex;

	type complex_record is 
	record
		z : ads_complex;
		c : ads_complex;
		stage_data :natural;
		stage_overflow : boolean;
	end record;

	---- functions
	-- make a complex number
	function ads_cmplx (
			re, im: in ads_sfixed
		) return ads_complex;

	-- returns l + r
	function "+" (
			l, r: in ads_complex
		) return ads_complex;

	-- returns l - r
	function "-" (
			l, r: in ads_complex
		) return ads_complex;

	-- returns l * r
	function "*" (
			l, r: in ads_complex
		) return ads_complex;

	-- returns the complex conjugate of arg
	function conj (
			arg: in ads_complex
		) return ads_complex;

	-- returns || arg || ** 2
	function abs2 (
			arg: in ads_complex
		) return ads_sfixed;

	-- constants
	constant complex_zero: ads_complex :=
					ads_cmplx(to_ads_sfixed(0), to_ads_sfixed(0));

end package ads_complex_pkg;

package body ads_complex_pkg is

	-- Function for addition
	function "+" (
			l, r: in ads_complex
		) return ads_complex
	is
		variable ret: ads_complex;
	begin
		ret.re := l.re + r.re;
		ret.im := l.im + r.im;
		return ret;
	end function "+";

	-- Function for subtraction
	function "-" (
			l, r: in ads_complex
		) return ads_complex
	is
		variable ret: ads_complex;
	begin
		ret.re := l.re - r.re;
		ret.im := l.im - r.im;
		return ret;
	end function "-";

	-- Function for complex multiplication
	function "*" (
			l, r: in ads_complex
		) return ads_complex
	is
		variable ret: ads_complex;
	begin
		ret.re := l.re * r.re - l.im * r.im;
		ret.im := l.re * r.im + l.im * r.re;
		return ret;
	end function "*";

	-- Function for complex conjugate
	function conj (
            arg: in ads_complex
        ) return ads_complex
    is
        variable ret: ads_complex;
    begin
        ret.re := arg.re;
        ret.im := -arg.im; -- negate the imaginary part
        return ret;
    end function conj;

	-- Function for squared absolute value
    function abs2 (
            arg: in ads_complex
        ) return ads_sfixed
    is
        variable abs_value: ads_sfixed;
    begin
        abs_value := arg.re * arg.re + arg.im * arg.im;
        return abs_value;
    end function abs2;

	function ads_cmplx (
    	re, im: in ads_sfixed
		) return ads_complex 
	is
    	variable ret: ads_complex;
	begin
		ret.re := re;
		ret.im := im;
		return ret;
	end function ads_cmplx;

end package body ads_complex_pkg;