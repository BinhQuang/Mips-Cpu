library verilog;
use verilog.vl_types.all;
entity Datapath is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        condZero        : in     vl_logic;
        pcSrc           : in     vl_logic_vector(1 downto 0);
        regDst          : in     vl_logic_vector(1 downto 0);
        memToReg        : in     vl_logic_vector(1 downto 0);
        aluSrc          : in     vl_logic;
        regWrite        : in     vl_logic;
        memWrite        : in     vl_logic;
        Branch          : in     vl_logic;
        ALUOp           : in     vl_logic_vector(3 downto 0);
        aluZero         : out    vl_logic;
        instr           : out    vl_logic_vector(31 downto 0);
        pc              : out    vl_logic_vector(31 downto 0);
        pcNext          : out    vl_logic_vector(31 downto 0)
    );
end Datapath;
