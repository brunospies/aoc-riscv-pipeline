
# XM-Sim Command File
# TOOL:	xmsim	19.09-s005
#

set tcl_prompt1 {puts -nonewline "xcelium> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
set assert_reporting_mode 0
database -open -shm -into waves.shm waves -default
probe -create -database waves :DUV:clock :DUV:data_i :DUV:data_o :DUV:dataAddress :DUV:instruction :DUV:instructionAddress :DUV:MemWrite :DUV:reset :DUV:DATA_PATH:uins_ID :DUV:DATA_PATH:reset :DUV:DATA_PATH:MemWrite :DUV:DATA_PATH:instructionAddress :DUV:DATA_PATH:instruction_out :DUV:DATA_PATH:instruction_IF :DUV:DATA_PATH:dataAddress :DUV:DATA_PATH:data_o :DUV:DATA_PATH:data_i :DUV:DATA_PATH:clock :DUV:DATA_PATH:decodedInstruction_IF :DUV:DATA_PATH:Stage_EX:uins_in :DUV:DATA_PATH:Stage_EX:uins_out :DUV:DATA_PATH:Stage_MEM:uins_out :DUV:DATA_PATH:Stage_WB:uins_out
probe -create -database waves :DUV:DATA_PATH:uins_EX :DUV:DATA_PATH:uins_MEM :DUV:DATA_PATH:uins_WB :DUV:DATA_PATH:PROGRAM_COUNTER:ce :DUV:DATA_PATH:PROGRAM_COUNTER:clock :DUV:DATA_PATH:PROGRAM_COUNTER:d :DUV:DATA_PATH:PROGRAM_COUNTER:INIT_VALUE :DUV:DATA_PATH:PROGRAM_COUNTER:LENGTH :DUV:DATA_PATH:PROGRAM_COUNTER:q :DUV:DATA_PATH:PROGRAM_COUNTER:reset :DUV:DATA_PATH:Stage_ID:ce :DUV:DATA_PATH:Stage_ID:clock :DUV:DATA_PATH:Stage_ID:INIT :DUV:DATA_PATH:Stage_ID:instruction_in :DUV:DATA_PATH:Stage_ID:instruction_out :DUV:DATA_PATH:Stage_ID:pc_in :DUV:DATA_PATH:Stage_ID:pc_out :DUV:DATA_PATH:Stage_ID:reset :DUV:DATA_PATH:Stage_EX:clock :DUV:DATA_PATH:Stage_EX:imm_data_in :DUV:DATA_PATH:Stage_EX:imm_data_out :DUV:DATA_PATH:Stage_EX:INIT :DUV:DATA_PATH:Stage_EX:pc_in :DUV:DATA_PATH:Stage_EX:pc_out :DUV:DATA_PATH:Stage_EX:rd_in :DUV:DATA_PATH:Stage_EX:rd_out :DUV:DATA_PATH:Stage_EX:read_data_1_in :DUV:DATA_PATH:Stage_EX:read_data_1_out :DUV:DATA_PATH:Stage_EX:read_data_2_in :DUV:DATA_PATH:Stage_EX:read_data_2_out :DUV:DATA_PATH:Stage_EX:reset :DUV:DATA_PATH:Stage_EX:rs1_in :DUV:DATA_PATH:Stage_EX:rs1_out :DUV:DATA_PATH:Stage_EX:rs2_in :DUV:DATA_PATH:Stage_EX:rs2_out :DUV:DATA_PATH:Stage_MEM:alu_result_in :DUV:DATA_PATH:Stage_MEM:alu_result_out :DUV:DATA_PATH:Stage_MEM:clock :DUV:DATA_PATH:Stage_MEM:INIT :DUV:DATA_PATH:Stage_MEM:rd_in :DUV:DATA_PATH:Stage_MEM:rd_out :DUV:DATA_PATH:Stage_MEM:reset :DUV:DATA_PATH:Stage_MEM:uins_in :DUV:DATA_PATH:Stage_MEM:write_data_in :DUV:DATA_PATH:Stage_MEM:write_data_out :DUV:DATA_PATH:Stage_WB:alu_result_in :DUV:DATA_PATH:Stage_WB:alu_result_out :DUV:DATA_PATH:Stage_WB:clock :DUV:DATA_PATH:Stage_WB:INIT :DUV:DATA_PATH:Stage_WB:rd_in :DUV:DATA_PATH:Stage_WB:rd_out :DUV:DATA_PATH:Stage_WB:read_data_in :DUV:DATA_PATH:Stage_WB:read_data_out :DUV:DATA_PATH:Stage_WB:reset :DUV:DATA_PATH:Stage_WB:uins_in :DUV:DATA_PATH:ALU:op1_s :DUV:DATA_PATH:ALU:op1_u :DUV:DATA_PATH:ALU:op2_i :DUV:DATA_PATH:ALU:op2_s :DUV:DATA_PATH:ALU:op2_u :DUV:DATA_PATH:ALU:operand1 :DUV:DATA_PATH:ALU:operand2 :DUV:DATA_PATH:ALU:operation :DUV:DATA_PATH:ALU:pc :DUV:DATA_PATH:ALU:result :DUV:DATA_PATH:REGISTER_FILE:clock :DUV:DATA_PATH:REGISTER_FILE:readData1 :DUV:DATA_PATH:REGISTER_FILE:readData2 :DUV:DATA_PATH:REGISTER_FILE:readRegister1 :DUV:DATA_PATH:REGISTER_FILE:readRegister2 :DUV:DATA_PATH:REGISTER_FILE:reg :DUV:DATA_PATH:REGISTER_FILE:reset :DUV:DATA_PATH:REGISTER_FILE:write :DUV:DATA_PATH:REGISTER_FILE:writeData :DUV:DATA_PATH:REGISTER_FILE:writeEnable :DUV:DATA_PATH:REGISTER_FILE:writeRegister :DUV:DATA_PATH:BranchDetection_unit:branch_decision :DUV:DATA_PATH:BranchDetection_unit:branch_prediction :DUV:DATA_PATH:BranchDetection_unit:bubble_branch_ID :DUV:DATA_PATH:BranchDetection_unit:Data1_ID :DUV:DATA_PATH:BranchDetection_unit:Data2_ID :DUV:DATA_PATH:BranchDetection_unit:instruction :DUV:DATA_PATH:Forwarding_unit:Forward1 :DUV:DATA_PATH:Forwarding_unit:Forward2 :DUV:DATA_PATH:Forwarding_unit:ForwardA :DUV:DATA_PATH:Forwarding_unit:ForwardB :DUV:DATA_PATH:Forwarding_unit:ForwardWb_A :DUV:DATA_PATH:Forwarding_unit:ForwardWb_B :DUV:DATA_PATH:Forwarding_unit:rd_stage_EX :DUV:DATA_PATH:Forwarding_unit:rd_stage_MEM :DUV:DATA_PATH:Forwarding_unit:rd_stage_WB :DUV:DATA_PATH:Forwarding_unit:RegWrite_stage_EX :DUV:DATA_PATH:Forwarding_unit:RegWrite_stage_MEM :DUV:DATA_PATH:Forwarding_unit:RegWrite_stage_WB :DUV:DATA_PATH:Forwarding_unit:rs1_stage_EX :DUV:DATA_PATH:Forwarding_unit:rs1_stage_ID :DUV:DATA_PATH:Forwarding_unit:rs2_stage_EX :DUV:DATA_PATH:Forwarding_unit:rs2_stage_ID :DUV:DATA_PATH:HazardDetection_unit:bubble_hazard_EX :DUV:DATA_PATH:HazardDetection_unit:ce :DUV:DATA_PATH:HazardDetection_unit:ce_pc :DUV:DATA_PATH:HazardDetection_unit:ce_stage_ID :DUV:DATA_PATH:HazardDetection_unit:MemToReg_EX :DUV:DATA_PATH:HazardDetection_unit:rs1_ID :DUV:DATA_PATH:HazardDetection_unit:rs2_EX :DUV:DATA_PATH:HazardDetection_unit:rs2_ID :DUV:DATA_PATH:IMM_DATA_EXTRACT:imm_data :DUV:DATA_PATH:IMM_DATA_EXTRACT:instruction :DUV:DATA_PATH:IMM_DATA_EXTRACT:instruction_f :DATA_MEMORY:clock :DATA_MEMORY:address :DATA_MEMORY:data_i :DATA_MEMORY:data_o :DATA_MEMORY:memoryArray :DATA_MEMORY:MemWrite :INSTRUCTION_MEMORY:clock :INSTRUCTION_MEMORY:address :INSTRUCTION_MEMORY:data_i :INSTRUCTION_MEMORY:data_o :INSTRUCTION_MEMORY:memoryArray :INSTRUCTION_MEMORY:MemWrite
probe -create -database waves :DUV:DATA_PATH:branchTarget :DUV:DATA_PATH:branch_decision

simvision -input /home/desenvolvimento/Documents/Disciplinas/6_Semestre/Arq_Org_III/aoc-riscv-pipeline/RV32I/tb/.simvision/6600_desenvolvimento__autosave.tcl.svcf
