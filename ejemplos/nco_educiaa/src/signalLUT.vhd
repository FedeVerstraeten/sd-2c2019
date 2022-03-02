---------------------------------------------------------------------------
---- Entity:        signalLUT                                              ----
---- Description:  samples of a signal saved as a constant               ----
---- Author:   Martín A. Heredia                                       ----
---- Last revision: 16/05/2020                                                   ----
---- Dependencies:                                                     ----
----	IEEE.std_logic_1164                                               ----
----	IEEE.numeric_std                                                  ----
----	work.LUTPackage                                                  ----
----	                                                               ----
----	                                                               ----
----                                                                   ----
----                                                                   ----
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.LUTPackage.all;

entity signalLUT is
generic( dataBits : integer := 12; --data bits
	addBits : integer := 10); --address bits
port (
  addr_in         : in  std_logic_vector(addBits-1 downto 0);
  data_out         : out std_logic_vector(dataBits-1 downto 0));
end entity signalLUT;

architecture signalLUT_arch of signalLUT is
begin

	    data_out  <= std_logic_vector(to_unsigned(C_SIG_TABLE(to_integer(unsigned(addr_in))),dataBits));

end architecture signalLUT_arch;
