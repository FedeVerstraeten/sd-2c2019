library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use std.textio.all;

package utils_pkg is
  function min_width(max_value: natural) return natural;
  function vector_to_string(vect: std_ulogic_vector) return string;
  function reduction_or(v: std_ulogic_vector) return std_ulogic;
  procedure read_unsigned_decimal_from_line(l: inout line;
                        u: inout unsigned);
end package utils_pkg;

package body utils_pkg is
  
  -- Min Width  
  function min_width(max_value: natural) return natural is
  begin
    return integer(ceil(log2(real(max_value))));
  end function min_width;

  -- Vector to string
  function vector_to_string(vect: std_ulogic_vector) return string is
    variable str: string(1 to vect'length);
  begin
    for i in vect'range loop
      if (vect(vect'length - i - 1) = '1') then
        str(i+1) := '1';
      else
        str(i+1) := '0';
      end if;
    end loop;
    return str;
  end function vector_to_string;

  -- Reduction OR
  function reduction_or(v: std_ulogic_vector) return std_ulogic is
  begin
    if (v = std_ulogic_vector(to_unsigned(0, v'length))) then
      return '0';
    else
      return '1';
    end if;
  end function reduction_or;

  -- Read unsigned decimal from line
  procedure read_unsigned_decimal_from_line(l: inout line;
                        u: inout unsigned) is
    variable c:     character;
    variable notEnd:  boolean := true;
    variable i:     integer;
  begin
    u := (u'range => '0');

    while notEnd loop
      read(l, c, notEnd);
      if (notEnd) then
        -- convert c to an integer
        i := character'pos(c) - character'pos('0');
        if ((i < 0) or (i > 9)) then
          -- out of range
          notEnd := false;
        else
          u := resize((u * to_unsigned(10, u'length)),
                u'length)
             + to_unsigned(i, u'length);
        end if;
      end if;
    end loop;
  end procedure read_unsigned_decimal_from_line;

end package body utils_pkg;
