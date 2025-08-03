library verilog;
use verilog.vl_types.all;
entity register_we is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        we              : in     vl_logic;
        d               : in     vl_logic_vector(15 downto 0);
        q               : out    vl_logic_vector(15 downto 0)
    );
end register_we;
