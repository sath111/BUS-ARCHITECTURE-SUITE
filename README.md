# BUS ARCHITECTURE SUITE
This project provides a modular and extensible collection of RAM implementations for common bus protocols in SoC and FPGA designs. Currently, it includes:
* **AXI4 Full RAM:** A fully compliant AXI4 memory-mapped RAM module that supports burst transactions, write strobes, and backpressure.

* **TileLink RAM:** A minimal TileLink-compatible RAM slave implementation for basic simulation and integration.

The aim of this repository is to serve as a foundation for building bus-connected peripherals, protocol bridges, and test infrastructure in hardware design projects. Future expansions will include support for AHB, APB, and bus protocol converters (e.g., AXI ↔ APB bridge, TileLink ↔ AXI bridge, etc.).

## AXI Full Master Interface with Synchronous RAM
This module implements a fully functional AXI Master interface that connects to a synchronous RAM. It supports AXI4 full protocol with burst transfers, separate read and write paths, and response handling. The design includes FIFOs to decouple the slave interface from the master logic and uses FSMs for managing write and read operations.

### Architecture Overview
| **Module**         | **Function**                                                                                                                                  |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| FIFO             | Buffers for each AXI channel (AW, W, B, AR, R) to decouple input AXI transactions from memory-side latency. Supports `push/pop/empty/full`.   |
| FSM_MASTER_WRITE | Finite State Machine to control the write address/data process. Pops from AW and W FIFOs, handles bursts, and generates write signals to RAM. |
| FSM_MASTER_READ  | FSM for read transactions. Pops from AR FIFO, manages burst reads, and triggers RAM read with proper burst addressing.                        |
| BRESP            | Collects write response signals from RAM and pushes to B FIFO for returning AXI `BVALID` + `BRESP`.                                           |
| DECODE_ADDR      | Used in both FSMs to calculate burst addresses based on initial address and incrementing offset (`+size`) per beat.                           |
| `i_waddr/i_raddr`  | Address bus going to RAM, driven by burst logic from FSMs.                                                                                    |
| `i_wdata/i_rdata`  | Data bus for writing to or reading from RAM.                                                                                                  |
| RAM              | Synchronous RAM with separate `i_ren` and `i_wen` signals. The memory is shared by both read/write logic through time-multiplexing.           |

Supported AXI Channels
Write Address (AW)
Pushed into FIFO on valid handshake; popped by FSM_MASTER_WRITE.

Write Data (W)
Pushed into FIFO; each beat includes WDATA, WSTRB, WLAST.

Write Response (B)
Generated after full write burst completion and pushed to FIFO.

Read Address (AR)
Buffered into FIFO; FSM_MASTER_READ fetches and drives read bursts.

Read Data (R)
After reading from RAM, data is pushed into FIFO with RVALID, RRESP, and RLAST.

