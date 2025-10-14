# AOC RISC-V Pipeline

A pipelined RISC-V (RV32I) CPU core implemented in **VHDL**, designed for educational and experimental use.  
The project demonstrates a classic 5-stage pipeline, including hazard detection, forwarding, and control logic.

## 🧠 Architecture Overview

- **ISA**: RV32I (base integer instruction set)
- **Pipeline Stages**:
  1. Instruction Fetch (IF)
  2. Instruction Decode (ID)
  3. Execute (EX)
  4. Memory Access (MEM)
  5. Write Back (WB)
- **Hazard Handling**:
  - Data forwarding and stall control
  - Branch flush logic
- **Memory Interfaces**:
  - Separate instruction and data memory (Harvard architecture)

## 🧩 Repository Structure

```
aoc-riscv-pipeline/
├── RV32I/          # VHDL source files for the CPU
├── docs/           # Design notes and documentation
├── Makefile        # Simulation commands
└── README.md
```

## ⚙️ Simulation

This project uses **Cadence Xcelium** for simulation.

### Prerequisites

- Cadence Xcelium (xrun / xcelium)
- GNU Make

### Run Simulation

```bash
make run
```

This will compile and simulate the RISC-V core, showing the waveform and console output (depending on your Makefile configuration).

## 🧾 Documentation

Detailed design documentation and pipeline diagrams can be found in the `docs/` folder.

## 🚀 Future Improvements

- Add CSR and interrupt handling  
- Extend ISA to RV32IM  
- Implement simple branch prediction  
- Improve verification with assembly test suite  

## 📄 License

This project is open-source under the MIT License.
