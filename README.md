# VME Bus System – Verilog Implementation on Vivado

This project presents the **Design, Development and Verification** of a **Versa Module Europa (VME) bus** using **Verilog HDL** on **Xilinx Vivado 2018.3**. It demonstrates a modular and scalable communication framework capable of handling **multi-master and multi-slave architectures** with a centralized arbiter and efficient memory-mapped data transfers.

---

## 🔧 What I Built

- **Master Module**  
  Initiates bus requests, performs read/write operations, and handles control signaling in compliance with VME protocol.

- **Slave Module**  
  Responds to requests from master(s), manages memory transactions, and handles acknowledgment or error signaling.

- **Arbiter Module**  
  Regulates access to the shared bus using three arbitration schemes:
  - Round-Robin Arbitration  
  - Priority-Based Arbitration  
  - Single Priority Arbitration

- **Integrated Bus Architecture**  
  Supports real-time communication through structured handshaking, memory mapping, and control signal coordination across all modules.

---

## 📌 Key Features

- **Multi-Master Communication** with bus contention resolution  
- **Arbitration Logic** supporting multiple fairness policies  
- **Modular Verilog Design** for Master, Slave, and Arbiter  
- **Memory Mapping & File-Based Transactions** to model real data flow  
- **Finite State Machines (FSMs)** used for protocol implementation and timing control  
- **Bus Utilization and Latency Metrics** analyzed during verification

---

## 🛠 Tools Used

- **Xilinx Vivado 2018.3**
- **Verilog HDL**
- **Waveform Viewer** (for FSM timing & control signal verification)

---

## 🧪 Project Results

- Successfully implemented **bus arbitration schemes** ensuring fairness and efficiency in multi-master environments.
- **Arbitration Simulation** verified correctness and behavior of the FSM-based controller logic.
- **Read/Write operations** completed without data contention or corruption using handshaking protocols.
- **Latency and bus utilization** measured and optimized, confirming performance under realistic conditions.
- Verified memory transfer consistency via preloaded files in both master and slave modules.

---

## 🙋‍♂️ Author

Ankenagari Rishitha Devi  
B.Tech, Electronics & Communication Engineering    
Academic Year: 2021–25  

---

## 🧠 Future Possibilities

- Real FPGA deployment with hardware-level testing  
- Dynamic arbitration schemes for load balancing  
- Expansion to multi-board communication using VME extensions

---

