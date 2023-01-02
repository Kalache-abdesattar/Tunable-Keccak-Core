library ieee;
use ieee.std_logic_1164.all;



entity sha3_tb is 
	generic(constant c2 : std_logic_vector(0 to 127) := x"A3A3A3A3A3A3A3A3A3A3A3A3A3A3A3A2");
end entity;



architecture a of sha3_tb is 
	signal in_block : std_logic_vector(0 to 127);
	signal clk, rd_empty : std_logic := '0';
	signal done, reset : std_logic := '1';
	signal digest : std_logic_vector(0 to 127);

	component sha3_final is port(clk, sync_reset, done, rd_empty : in std_logic;
		  in_block : in std_logic_vector(0 to 127);
		  rd_req : out std_logic;
		  digest : out std_logic_vector(0 to 127));
	end component;


	begin 
		clk <= not clk after 1ns;
		done <= '0' after 30ns, '1' after 40ns;
			
		reset <= '0' after 1ns;
		rd_empty <= '1' after 40ns;
		in_block <= c2;
		
		p : sha3_final port map(clk, reset, done, rd_empty, in_block, OPEN, digest);
end;
		
	
