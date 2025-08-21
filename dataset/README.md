# Synthetic ID-xApp Interference Detection Dataset

## Overview
This dataset simulates 10 mobile UEs across 2 cells over 1000 timestamps, intended for testing an interference detection application (ID-xApp) in a handover optimization scenario.

The generated dataset contains per-UE measurements such as RSRP, RSRQ, SINR, PRB usage, position, and speed, along with a boolean flag indicating detected interference.

## Dataset Generation

### Parameters
- **Number of cells:** 2
- **Number of UEs:** 10
- **Number of timestamps:** 1000
- **Per UE parameters:**
  - RSRP (serving and neighbor)
  - RSRQ
  - SINR
  - UE PRB usage (%)
  - UE position within cell (x, y coordinates in meters)
  - UE speed (km/h)
- **Per cell parameters:**
  - PRB usage (%)
  - Cell position

### Method
1. **Cell positions** fixed:  
   - Cell 0: (0, 0) m  
   - Cell 1: (1000, 0) m  

2. **Cell PRB usage** randomized per timestamp between 30% and 95%.

3. **UE positions, speeds, and PRB usage** randomized for each timestamp:
   - x: between -300 m and 1300 m  
   - y: between -400 m and 400 m  
   - Speed: 0–90 km/h  
   - PRB usage: 2%–25%  

4. **Radio model**:
   - Pathloss: 3GPP Urban Macro model  
     PL(dB) = 128.1 + 37.6 * log10(d_km)
   - Shadow fading: N(0, 6 dB)
   - Tx power: 43 dBm
   - Noise: -104 dBm (10 MHz)

5. **RSRP, SINR, RSRQ computation**:
   - Serving cell = max RSRP
   - SINR = Signal / (Interference + Noise)
   - RSRQ ≈ N_RB × RSRP / RSSI (N_RB=50)

6. **Interference detection heuristic**:
   Flag as interference if any:
   - RSRP_serv > -100 dBm and SINR < 0 dB
   - RSRQ < -12 dB and (RSRP_serv − RSRP_nei) < 6 dB
   - High load (>80% and >70%) and (RSRP_serv − RSRP_nei) < 10 dB

## Plots
1. **SINR vs RSRQ with Interference Flags** — red points indicate interference.
2. **UE/Cell Layout (t=0)** — shows positions of UEs and cells.