.PHONY: run
run:
	xrun -v200x -f filelist.txt -top RISCV_pipeline_tb -access +rwc -gui

.PHONY: clean
clean:
	xrun -v200x -f filelist.txt -top RISCV_pipeline_tb -access +rwc -gui -clean

.PHONY: run_core
run_core:
	xrun -v200x -f filelist.txt -top RISCV_pipeline -access +rwc -gui

.PHONY: run_bin
run_bin:
	xrun -sv -v200x -f filelist_sv.txt -top RISCV_pipeline_tb -access +rwc -gui

