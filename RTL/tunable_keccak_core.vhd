library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity tunable_keccak_core is 
	port(sys_clk, io_clk, wr_req, done, sha_reset, sha_ena : in std_logic;
		  data : in std_logic_vector(0 to 15);
		  capacity_ctrl : in std_logic_vector(0 to 1);
		  iterate, squeeze : in std_logic;
		  wr_full : out std_logic;
		  sha_digest : out std_logic_vector(0 to 127));
end tunable_keccak_core;



architecture arr of tunable_keccak_core is
	signal rd_req, rd_empty : std_logic;
	signal q : std_logic_vector(0 to 127);
	signal digest : std_logic_vector(0 to 127);
	
	component tunable_keccak is port(clk, sync_reset, sys_ena, done, rd_empty : in std_logic;
		  capacity_ctrl : in std_logic_vector(0 to 1);
		  iterate, squeeze : in std_logic;
		  in_block : in std_logic_vector(0 to 127);
		  rd_req : out std_logic;
		  digest : out std_logic_vector(0 to 127));
	end component;


	component dsffo is PORT(aclr : in std_logic; data : IN STD_LOGIC_VECTOR (15 DOWNTO 0); rdclk : IN STD_LOGIC; rdreq : IN STD_LOGIC; 
		wrclk : IN STD_LOGIC; 
		wrreq	: IN STD_LOGIC;
		q: OUT STD_LOGIC_VECTOR (127 DOWNTO 0);
		rdempty : OUT STD_LOGIC;
		wrfull : OUT STD_LOGIC);
	end component;
	
	
	begin 
	
	fifo : dsffo port map('0', data, sys_clk, rd_req, io_clk, wr_req, q, rd_empty, wr_full);
	sha3 : tunable_keccak port map(sys_clk, sha_reset, sha_ena, done, rd_empty, capacity_ctrl, iterate, squeeze, q, rd_req, digest);
	
	sha_digest <= digest(0 to 127);
	
end;