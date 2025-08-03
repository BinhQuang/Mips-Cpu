library verilog;
use verilog.vl_types.all;
entity Datapath_vlg_sample_tst is
    port(
        ALUOp           : in     vl_logic_vector(3 downto 0);
        Branch          : in     vl_logic;
        aluSrc          : in     vl_logic;
        clk             : in     vl_logic;
        condZero        : in     vl_logic;
        memToReg        : in     vl_logic_vector(1 downto 0);
        memWrite        : in     vl_logic;
        pcSrc           : in     vl_logic_vector(1 downto 0);
        regDst          : in     vl_logic_vector(1 downto 0);
        regWrite        : in     vl_logic;
        rst             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end Datapath_vlg_sample_tst;
