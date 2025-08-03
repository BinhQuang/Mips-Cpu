library verilog;
use verilog.vl_types.all;
entity gpio is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        bSel            : in     vl_logic;
        bWrite          : in     vl_logic;
        bAddr           : in     vl_logic_vector(31 downto 0);
        bWData          : in     vl_logic_vector(31 downto 0);
        bRData          : out    vl_logic_vector(31 downto 0);
        gpioInput       : in     vl_logic_vector(15 downto 0);
        gpioOutput      : out    vl_logic_vector(15 downto 0)
    );
end gpio;
