package test_pkg;
	import uvm_pkg::*;
//include uvm_macros.sv
	`include "uvm_macros.svh"
`include "src_xtn.sv"
`include "src_agent_config.sv"
`include "dest_agent_config.sv"
`include "env_config.sv"
`include "src_driver.sv"
`include "src_monitor.sv"
`include "src_sequencer.sv"
`include "src_agent.sv"
`include "src_agent_top.sv"
`include "src_seqs.sv"

`include "dest_xtn.sv"
`include "dest_monitor.sv"
`include "dest_sequencer.sv"
`include "dest_seqs.sv"
`include "dest_driver.sv"
`include "dest_agent.sv"
`include "dest_agent_top.sv"

`include "virtual_sequencer.sv"
`include "virtual_seqs.sv"
`include "scoreboard.sv"

`include "tb.sv"

`include "custom_phase.sv"
`include "uvm_user_phase.sv"
`include "extended_custom_phase.sv"

`include "test_lib.sv"


endpackage
