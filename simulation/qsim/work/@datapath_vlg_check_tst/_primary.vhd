library verilog;
use verilog.vl_types.all;
entity Datapath_vlg_check_tst is
    port(
        aluZero         : in     vl_logic;
        instr           : in     vl_logic_vector(31 downto 0);
        pc              : in     vl_logic_vector(31 downto 0);
        pcNext          : in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end Datapath_vlg_check_tst;
