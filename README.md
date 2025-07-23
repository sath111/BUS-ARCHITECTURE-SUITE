# BUS ARCHITECTURE SUITE
This project provides a modular and extensible collection of RAM implementations for common bus protocols in SoC and FPGA designs. Currently, it includes:
* **AXI4 Full RAM:** A fully compliant AXI4 memory-mapped RAM module that supports burst transactions, write strobes, and backpressure.

* **TileLink RAM:** A minimal TileLink-compatible RAM slave implementation for basic simulation and integration.

The aim of this repository is to serve as a foundation for building bus-connected peripherals, protocol bridges, and test infrastructure in hardware design projects. Future expansions will include support for AHB, APB, and bus protocol converters (e.g., AXI ↔ APB bridge, TileLink ↔ AXI bridge, etc.).
