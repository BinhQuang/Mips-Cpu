library verilog;
use verilog.vl_types.all;
entity CPU_pl is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        aluZero         : out    vl_logic;
        instr           : out    vl_logic_vector(31 downto 0);
        pc              : out    vl_logic_vector(31 downto 0);
        pcNext          : out    vl_logic_vector(31 downto 0);
        aluResult       : out    vl_logic_vector(31 downto 0)
    );
end CPU_pl;
