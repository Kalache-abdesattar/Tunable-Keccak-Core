library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity kdf_tb is 
end entity;


architecture arc of kdf_tb is 
	signal counter : unsigned(0 to 15) := (others => '0');
	
	signal sha_ena : std_logic := '1';
	signal sha_reset : std_logic := '1';
	signal sys_clk, io_clk : std_logic := '1';
	signal wr_req : std_logic := '0';
	signal rd_empty, wr_full, done : std_logic := '0';
	signal data : std_logic_vector(0 to 15);
	signal sha_digest : std_logic_vector(0 to 127);
	
	signal capacity_ctrl : std_logic_vector(0 to 1);
	signal iterate : std_logic;

	component kdf_refined is port(sys_clk, io_clk, wr_req, done, sha_reset, sha_ena : in std_logic;
		  data : in std_logic_vector(0 to 15);
		 capacity_ctrl : in std_logic_vector(0 to 1);
		 iterate : in std_logic;
		  wr_full : out std_logic;
		  sha_digest : out std_logic_vector(0 to 127));
	end component;

	begin 
	sys_clk <= not sys_clk after 1ns;
	io_clk <= not io_clk after 2ns;
	
	process(io_clk)
		begin 
			if(io_clk'event and io_clk = '1') then
				if(counter = 32767) then 
					counter <= (others => '0');
				else counter <= counter + 1;
				end if;
			end if;
	end process;
	
	data <= std_logic_vector(counter);
	
	wr_req <= not wr_full; 
	sha_reset <= '0' after 2ns;
	sha_ena <= '1' after 12ns;
	done <= '0', '1' after 16ns, '0' after 60ns, '1' after 120ns, '0' after 175ns, '1' after 200ns;
	capacity_ctrl <= "00";
	iterate <= '0';
	

	dsff0 : kdf_refined port map(sys_clk, io_clk, wr_req, done, sha_reset, sha_ena, data, capacity_ctrl, iterate, wr_full, sha_digest);

	
end;