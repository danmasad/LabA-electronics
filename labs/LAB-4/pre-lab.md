# Lab 4: Bipolar Junction Transistors (BJT) — Preliminary Report

**Students:** [Name 1] · 208632216 &nbsp;|&nbsp; [Name 2] · 206505307  
**Date:** [Date]  
**Course:** Lab A — Electronics, TAU Faculty of Engineering, Semester B 2025-2026  

---

## I. Preparatory Questions

---

## 1. BJT Basics

### 1.1 NPN and PNP Structures & Operating Modes

An NPN transistor consists of a thin P-type base sandwiched between a heavily doped N-type emitter and a lightly doped N-type collector. The device symbol shows the emitter arrow pointing **outward** (away from the base). In a PNP transistor the structure is complementary — a thin N-type base between two P-type regions — and the emitter arrow points **inward** (into the base).

**Active-region biasing (NPN):**
$$
V_{BE} \approx 0.7\,\text{V} \quad (\text{B–E forward biased}), \qquad V_{CB} > 0 \quad (\text{C–B reverse biased})
$$
Minority carriers injected from the emitter diffuse across the thin base and are swept into the collector. The terminal currents are related by:
$$
I_C = \beta\,I_B = \alpha\,I_E, \qquad I_E = I_B + I_C
$$
where $\beta = h_{FE}$ is the common-emitter current gain (typically 50–300) and $\alpha = \beta/(\beta+1) \approx 1$.

**Four operating modes:**

| Mode | $V_{BE}$ | $V_{BC}$ | Description |
|------|-----------|-----------|-------------|
| Cut-off | $< 0.5\,\text{V}$ | Reverse | Both junctions off; $I_C \approx 0$. Open switch. |
| **Forward active** | $\approx 0.7\,\text{V}$ | Reverse | Normal amplification; $I_C = \beta\,I_B$. |
| Saturation | $\approx 0.7\,\text{V}$ | Forward | Both junctions on; $V_{CE} \approx 0.2\,\text{V}$. Closed switch. |
| Reverse active | Reverse | Forward | Emitter/collector roles swapped; very low gain. Rarely used. |

For a **PNP** transistor all polarities are reversed: the emitter is the most positive terminal, $V_{EB} \approx 0.7\,\text{V}$, and $V_{BC} < 0$ in active mode.

---

### 1.2 CE, CB, and CC Configurations

#### (a) Common Emitter (CE)

The emitter terminal is shared between input and output ports.

- **Input:** base, **Output:** collector
- Voltage gain: $A_V = -g_m R_C$ — **large magnitude, inverting**
- Current gain: $\beta$ — large
- $R_{in} = r_\pi = \beta/g_m$ — moderate ($\sim$kΩ)
- $R_{out} = R_C \| r_o$ — moderate ($\sim$kΩ)
- **Applications:** General-purpose voltage amplification; most widely used configuration.

#### (b) Common Base (CB)

The base terminal is AC-grounded; input is at the emitter, output at the collector.

- Voltage gain: $A_V = +g_m R_C$ — large, non-inverting
- Current gain: $\alpha < 1$
- $R_{in} = 1/g_m$ — very small ($\sim$tens of Ω)
- $R_{out} \approx r_o$ — very large
- **Applications:** RF/high-frequency stages (no Miller capacitance multiplication); current buffers.

#### (c) Common Collector (CC) — Emitter Follower

The collector is AC-grounded (connected to supply); input is at the base, output at the emitter.

- Voltage gain: $A_V \approx +1$ — unity, non-inverting
- Current gain: $\beta + 1$ — large
- $R_{in} \approx r_\pi + (\beta+1)R_E$ — very large
- $R_{out} \approx R_E \| (1/g_m)$ — very small ($\sim$tens of Ω)
- **Applications:** Impedance buffer — follows the input voltage while driving low-impedance loads.

---

### 1.3 Four Amplifier Types

| Type | Input | Output | Gain | Ideal $R_{in}$ | Ideal $R_{out}$ | Typical BJT impl. |
|------|-------|--------|------|-----------------|------------------|-------------------|
| Voltage amplifier | $V$ | $V$ | $A_V = V_{out}/V_{in}$ | Large | Small | CE stage |
| Current amplifier | $I$ | $I$ | $A_I = I_{out}/I_{in}$ | Small | Large | CB stage |
| Trans-conductance | $V$ | $I$ | $G_m = I_{out}/V_{in}$ | Large | Large | CE with $R_E$ |
| Trans-resistance | $I$ | $V$ | $R_m = V_{out}/I_{in}$ | Small | Small | Transimpedance (feedback) |

**Rationale for impedance requirements:** For a voltage amplifier, a large $R_{in}$ avoids loading the driving source (voltage divider effect), while a small $R_{out}$ ensures the full output voltage is delivered to the load regardless of its impedance. The same logic applies to each type according to the nature of its input and output signals.

---

### 1.4 Emitter Degeneration Resistor

A resistor $R_E$ placed between the emitter and ground introduces **series-series negative feedback**:
$$
A_V = \frac{-g_m R_C}{1 + g_m R_E} \approx -\frac{R_C}{R_E} \quad \text{(when } g_m R_E \gg 1\text{)}
$$
**Comparison with and without $R_E$:**

| Parameter | Without $R_E$ | With $R_E$ |
|-----------|----------------|-------------|
| Voltage gain $\|A_V\|$ | $g_m R_C$ (large) | $\approx R_C/R_E$ (reduced) |
| Bias stability | Poor — $I_C$ varies strongly with $\beta$ and $T$ | Excellent — NFB stabilizes $I_C$ |
| Input resistance | $R_{in} = r_\pi$ | $R_{in} = r_\pi + (\beta+1)R_E$ (much larger) |
| Output resistance | $R_{out} \approx R_C \| r_o$ | $R_{out} \approx R_C \| r_o(1+g_m R_E)$ (larger) |
| Linearity | Moderate | Improved — distortion reduced by NFB |
| Dynamic range | Smaller | Extended — $V_{CE}$ excursion is larger |

**Physical intuition:** If $I_C$ rises (e.g., due to temperature increase), $V_E = I_E R_E$ rises, reducing $V_{BE} = V_B - V_E$, which suppresses $I_C$. The gain-stability trade-off is the central design choice in CE amplifier design.

---

## 2. NPN-BJT Characteristics

### 2.1 $I_B = f(V_{BE})$ — DC Sweep Simulation

**Circuit (Fig. 1):** Q2N2222, $R_b = 10\,\text{k}\Omega$, $R_2 = 1000\,\text{M}\Omega$ (open-circuit emulation).  
**Sweep:** V1 from $-1\,\text{V}$ to $10\,\text{V}$ in $0.1\,\text{V}$ steps.

![Fig. 1 — NPN IB vs VBE characteristic](assets/fig1_npn_ib_vbe.png)  
*Figure 1: Simulated $I_B = f(V_{BE})$ characteristic of the NPN Q2N2222 transistor. The exponential diode-like behavior is evident above $V_{BE} \approx 0.5\,\text{V}$, with the junction conducting significantly above $0.6\text{–}0.7\,\text{V}$.*

**Explanation:** The B–E junction behaves as a forward-biased p-n diode governed by the Shockley equation:
$$
I_B = \frac{I_S}{\beta}\left(e^{V_{BE}/V_T} - 1\right)
$$
For $V_{BE} < 0.5\,\text{V}$ the current is negligible. Above $\approx 0.6\,\text{V}$ the exponential growth becomes significant, and the junction reaches its nominal $0.7\,\text{V}$ operating point at the typical bias current. For negative $V_{BE}$, $I_B \approx -I_S/\beta \approx 0$ (reverse saturation).

---

### 2.2 $I_C = f(V_{CE},\, I_B)$ — Double DC Sweep Simulation

**Circuit (Fig. 2):** Q2N2222, $R_b = 100\,\text{k}\Omega$, $R_C = 100\,\Omega$.  
**Primary sweep:** $V_{CC}$ from $-1\,\text{V}$ to $10\,\text{V}$, $0.1\,\text{V}$ steps.  
**Secondary sweep:** $V_{bb}$ from $0\,\text{V}$ to $10\,\text{V}$, $2\,\text{V}$ steps (5 curves).

![Fig. 2 — NPN IC vs VCE family of curves](assets/fig2_npn_ic_vce.png)  
*Figure 2: Simulated output characteristics $I_C = f(V_{CE})$ of the NPN Q2N2222 for five values of $V_{bb}$ (0, 2, 4, 6, 8 V), corresponding to increasing $I_B$. Three distinct regions are visible: saturation ($V_{CE} < 0.2\,\text{V}$), active (flat $I_C$ plateau), and breakdown (if $V_{CE}$ is pushed too high).*

**Explanation:** In the **active region**, $I_C = \beta\,I_B$ is nearly independent of $V_{CE}$ — each curve is a flat plateau whose level scales with $I_B$. The slight upward slope is due to the **Early effect** (channel-length modulation analog in BJTs): increasing $V_{CE}$ widens the depletion region at the C-B junction, effectively narrowing the base and increasing $\beta$. In the **saturation region** ($V_{CE} < V_{CE,sat} \approx 0.2\,\text{V}$) both junctions are forward-biased and $I_C$ drops sharply.

**For a PNP transistor:** All polarities are reversed. The curves would appear in the third quadrant ($V_{CE} < 0$, $I_C < 0$), with $V_{bb}$ replaced by $-V_{EE}$ driving the emitter. The shape of the family of curves is identical in structure; only the sign convention changes.

---

## 3. PNP-BJT Characteristics

### 3.1 $I_E = f(V_{EB})$ — DC Sweep Simulation

**Circuit (Fig. 3):** Q2N3906, $R_e = 1\,\text{k}\Omega$, $R_2 = 100\,\text{M}\Omega$.  
**Sweep:** V1 from $-1\,\text{V}$ to $10\,\text{V}$, $0.1\,\text{V}$ steps.

![Fig. 3 — PNP IE vs VEB characteristic](assets/fig3_pnp_ie_veb.png)  
*Figure 3: Simulated $I_E = f(V_{EB})$ characteristic of the PNP Q2N3906 transistor. The curve mirrors the NPN $I_B\text{–}V_{BE}$ characteristic: exponential conduction above $V_{EB} \approx 0.6\,\text{V}$, negligible current for $V_{EB} < 0.5\,\text{V}$.*

**Explanation:** The E–B junction of a PNP device is also a forward-biased p-n junction when $V_{EB} > 0$. The curve is structurally identical to the NPN $I_B\text{–}V_{BE}$ result, reflecting the device symmetry. The measured current is $I_E$ (emitter, the majority-carrier injecting terminal) rather than $I_B$, hence its magnitude is larger by a factor of $\alpha^{-1} \approx 1 + 1/\beta$.

---

### 3.2 $I_C = f(V_{CB},\, I_E)$ — Double DC Sweep Simulation

**Circuit (Fig. 4):** Q2N3906, $R_e = 1\,\text{k}\Omega$, $R_C = 100\,\Omega$.  
**Primary sweep:** $V_{CC}$ from $-10\,\text{V}$ to $1\,\text{V}$, $0.1\,\text{V}$ steps.  
**Secondary sweep:** $-V_{EE}$ from $0\,\text{V}$ to $10\,\text{V}$, $2\,\text{V}$ steps.

![Fig. 4 — PNP IC vs VCB family of curves](assets/fig4_pnp_ic_vcb.png)  
*Figure 4: Simulated output characteristics $I_C = f(V_{CB})$ of the PNP Q2N3906. The family of curves — one per $-V_{EE}$ step — occupies the third quadrant ($V_{CB} < 0$, $I_C < 0$) and mirrors the NPN output characteristic with reversed sign convention.*

**Explanation:** The PNP device operates in its active region when $V_{CB} < 0$ (C–B reverse biased) and $V_{EB} > 0.6\,\text{V}$. The flat plateaus of $I_C$ (negative in PNP convention) correspond to $I_C = -\alpha\,I_E$. The saturation region appears near $V_{CB} \approx 0\,\text{V}$ where both junctions become forward biased. The structure of the family is identical to the NPN output characteristic — the PNP is simply the NPN operated with all supply polarities inverted.

---

## 4. Common-Emitter (CE) Amplifier

**Circuit (Fig. 5):** $V_{CC} = 15\,\text{V}$, $R_g = 220\,\Omega$, $R_{b1} = 30\,\text{k}\Omega$, $R_{b2} = 12\,\text{k}\Omega$, $R_C = 2\,\text{k}\Omega$, $R_e = 2\,\text{k}\Omega$, $R_6 = 20\,\text{k}\Omega$, $C_1 = C_2 = C_e = 22\,\mu\text{F}$, Q1 = Q2N2222.

---

### 4.1 CE Bias Point

#### 4.1.1 Analytical Derivation

**Thevenin equivalent of the voltage-divider bias network:**
$$
V_{TH} = V_{CC} \cdot \frac{R_{b2}}{R_{b1}+R_{b2}} = 15 \cdot \frac{12\,\text{k}}{42\,\text{k}} = 4.286\,\text{V}
$$
$$
R_{TH} = R_{b1} \| R_{b2} = \frac{30\,\text{k} \times 12\,\text{k}}{42\,\text{k}} = 8.571\,\text{k}\Omega
$$
**KVL around the base–emitter loop** ($\beta = 100$, $V_{BE} = 0.7\,\text{V}$):
$$
I_B = \frac{V_{TH} - V_{BE}}{R_{TH} + (\beta+1)R_e} = \frac{4.286 - 0.7}{8.571\,\text{k} + 101 \times 2\,\text{k}} = \frac{3.586}{210.571\,\text{k}} = 17.0\,\mu\text{A}
$$
$$
I_C = \beta\,I_B = 100 \times 17.0\,\mu\text{A} = 1.70\,\text{mA}
$$
$$
I_E = (\beta+1)\,I_B = 101 \times 17.0\,\mu\text{A} = 1.717\,\text{mA}
$$
**Node voltages:**
$$
V_E = I_E \cdot R_e = 1.717\,\text{mA} \times 2\,\text{k} = 3.43\,\text{V}
$$
$$
V_B = V_{BE} + V_E = 0.7 + 3.43 = 4.13\,\text{V} \quad (\approx V_{TH} = 4.29\,\text{V}\ \checkmark)
$$
$$
V_C = V_{CC} - I_C \cdot R_C = 15 - 1.70 \times 2\,\text{k} = 11.60\,\text{V}
$$
$$
\boxed{V_{CE} = V_C - V_E = 11.60 - 3.43 = 8.17\,\text{V}, \qquad I_C = 1.70\,\text{mA}}
$$
**Bias stability:** $R_{TH} = 8.57\,\text{k} \ll (\beta+1)R_e = 202\,\text{k}\Omega$ — the voltage divider is stiff, making the bias point nearly independent of $\beta$.

**Small-signal parameters at the Q-point:**
$$
g_m = \frac{I_C}{V_T} = \frac{1.70\,\text{mA}}{26\,\text{mV}} = 65.4\,\text{mA/V}, \qquad r_\pi = \frac{\beta}{g_m} = 1.53\,\text{k}\Omega
$$
#### 4.1.2 Circuit with Annotated Bias Points

```
              +15 V (Vcc)
                  |
            Rc = 2 kΩ         Vc = 11.60 V
                  |
         +--------+----------→ (Vout via C2)
         |        |
        Rb1      [Q1: Q2N2222]
        30 kΩ     |  Ic = 1.70 mA
         |        |  Vb = 4.13 V  →  Vbe = 0.70 V  →  Ib = 17.0 μA
Vin ----+----C1---B
(via Rg=220Ω)
         |        E              Ve = 3.43 V
        Rb2      Re = 2 kΩ  ‖  Ce = 22 μF
        12 kΩ     |
         |       GND
        GND

         Q-point:  VCE = 8.17 V,  IC = 1.70 mA  (active region ✓)
```

---

### 4.2 Frequency Response Simulation

**Setup:** AC sweep, RC = 2 kΩ, 3 kΩ, 5 kΩ — three curves on one plot.

![Fig. 5 — CE frequency response for RC = 2k, 3k, 5kΩ](assets/fig5_ce_freq_response.png)  
*Figure 5: Simulated Bode magnitude plot of the CE amplifier voltage gain $|A_V|$ for three values of $R_C$. Each curve shows a mid-band plateau, a lower cutoff $f_{L}$ dominated by coupling/bypass capacitors, and an upper cutoff $f_{H}$ dominated by transistor parasitic capacitances. The mid-band gain increases with $R_C$ while the upper $-3\,\text{dB}$ frequency decreases.*

**Expected mid-band gain** (with $C_e$ bypassing $R_e$, no $R_6$ loading):
$$
A_{V,\text{mid}} = -g_m \cdot R_C = -65.4\,\text{mA/V} \times R_C
$$
| $R_C$ | $\|A_V\|$ (predicted) |
|---------|------------------------|
| 2 kΩ | 131 |
| 3 kΩ | 196 |
| 5 kΩ | 327 |

**Bandwidth and gain values to be extracted from simulation:**

| $R_C$ | Mid-band gain $[\text{dB}]$ | $f_L$ [Hz] | $f_H$ [Hz] | BW [Hz] |
|---------|------------------------------|-------------|-------------|---------|
| 2 kΩ | [from sim] | [from sim] | [from sim] | [from sim] |
| 3 kΩ | [from sim] | [from sim] | [from sim] | [from sim] |
| 5 kΩ | [from sim] | [from sim] | [from sim] | [from sim] |

**Discussion:** Increasing $R_C$ raises the mid-band gain but lowers $f_H$ because the Miller-multiplied $C_{\mu}$ (C-B capacitance) becomes more significant: $C_{Miller} = C_\mu(1 + g_m R_C)$. The gain–bandwidth product $|A_V| \times f_H$ is therefore approximately constant for a given transistor.

---

### 4.3 Input Resistance

**Setup:** $R_g = 1\,\text{k}\Omega$, $R_C = 2\,\text{k}\Omega$, transient simulation, sinusoidal input $20\,\text{mV}_{P\text{-}P}$ at $1\,\text{kHz}$.

![Fig. 6 — CE transient simulation for Rin measurement (Rg=1kΩ)](assets/fig6_ce_transient_rin.png)  
*Figure 6: Transient simulation showing voltage at the input of $R_g$ (before) and at the base of Q1 (after $R_g$). The voltage divider formed by $R_g$ and $R_{in}$ attenuates the signal at the base.*

**Derivation of $R_{in}$:**

The voltage divider gives:
$$
\frac{V_{base}}{V_{in}} = \frac{R_{in}}{R_g + R_{in}} \quad \Rightarrow \quad R_{in} = R_g \cdot \frac{V_{base}}{V_{in} - V_{base}}
$$
**Theoretical prediction:**
$$
R_{in} = R_{b1} \| R_{b2} \| r_\pi = 30\,\text{k} \| 12\,\text{k} \| 1.53\,\text{k} = 8.57\,\text{k} \| 1.53\,\text{k} \approx 1.29\,\text{k}\Omega
$$
**Measured from simulation:**

| $V_{in}$ $[\text{mV}_{PP}]$ | $V_{base}$ $[\text{mV}_{PP}]$ | $R_{in}$ $[\Omega]$ |
|-------------------------------|----------------------------------|------------------------|
| [from sim] | [from sim] | [from sim] |

**Effect of $R_{b1} \to \infty$:** If $R_{b1}$ were removed, the Thevenin bias equivalent would change: $V_{TH}$ would no longer hold the base at a defined potential, likely driving the transistor into saturation or cut-off. Additionally, $R_{in}$ would increase to $R_{b2} \| r_\pi$, but the bias point would be lost — the amplifier would fail to operate linearly.

---

### 4.4 Output Resistance

**Setup 1 (unloaded):** $R_6 = 100\,\text{M}\Omega$, transient, $20\,\text{mV}_{P\text{-}P}$ / 1 kHz.  
**Setup 2 (loaded):** $R_6 = 20\,\text{k}\Omega$ (original value).

![Fig. 7 — CE transient: unloaded output](assets/fig7_ce_transient_rout_unloaded.png)  
*Figure 7: Transient simulation of the CE amplifier with a $100\,\text{M}\Omega$ (effectively open-circuit) load. The output voltage corresponds to the Thevenin open-circuit voltage $V_{OC}$.*

![Fig. 8 — CE transient: loaded output (R6 = 20kΩ)](assets/fig8_ce_transient_rout_loaded.png)  
*Figure 8: Transient simulation with the nominal load $R_6 = 20\,\text{k}\Omega$. The voltage reduction due to loading allows extraction of $R_{out}$.*

**Derivation of $R_{out}$:**

Using the loaded/unloaded voltage divider:
$$
V_{loaded} = V_{OC} \cdot \frac{R_6}{R_{out} + R_6} \quad \Rightarrow \quad R_{out} = R_6\left(\frac{V_{OC}}{V_{loaded}} - 1\right)
$$
**Theoretical prediction:**
$$
R_{out} = R_C \| r_o \approx R_C = 2\,\text{k}\Omega \quad (r_o \gg R_C)
$$
**Measured from simulation:**

| $V_{OC}$ $[\text{mV}_{PP}]$ | $V_{loaded}$ $[\text{mV}_{PP}]$ | $R_{out}$ $[\Omega]$ |
|-------------------------------|-------------------------------------|-------------------------|
| [from sim] | [from sim] | [from sim] |

**Effect of $R_e \to \infty$:** Without the emitter bypass capacitor $C_e$, $R_e$ is not shorted at AC. The voltage gain reduces to $A_V \approx -R_C/R_e = -1$. The output resistance increases to $R_{out} \approx R_C \| r_o(1 + g_m R_e)$, which for large $g_m R_e$ approaches $R_C$ from above — effectively unchanged since $R_C$ dominates. However, the gain drops drastically. If $R_e \to \infty$ as stated (not just removing Ce), there is no emitter return path and the transistor cannot operate.

---

## 5. Common-Collector (CC) Amplifier with Bootstrap

**Circuit (Fig. 6):** $V_{CC} = 15\,\text{V}$, $R_1 = 10\,\text{k}\Omega$, $R_b = 10\,\text{k}\Omega$, $R_2 = 12\,\text{k}\Omega$ (personalized), $C_{bs} = C_1 = C_2 = 22\,\mu\text{F}$, $R_e = 2\,\text{k}\Omega$, $R_L = 10\,\text{k}\Omega$, $R_g = 6.8\,\text{k}\Omega$, Q1 = Q2N2222A.

---

### 5.1 Bootstrapping — Qualitative Description

In a standard emitter follower, the bias resistors $R_1$ and $R_2$ are directly in parallel with the input and severely limit the input impedance:
$$
R_{in,\text{no bootstrap}} = R_1 \| R_2 \| [\,r_\pi + (\beta+1)R_e\,]
$$
Since $R_1 \| R_2 \approx 5.45\,\text{k}\Omega$ dominates, $R_{in}$ is drastically reduced.

**Bootstrap principle:** Capacitor $C_{bs}$ feeds the emitter signal (which follows the base at gain $\approx +1$) back to the top of the bias divider — the junction between $R_1$ and $R_b$. Since both ends of $R_1$ carry nearly identical AC voltages, the AC voltage across $R_1$ is approximately zero, and virtually no AC current flows through it. $R_1$ therefore presents an extremely high **effective AC impedance**, leaving only $R_b$ and the transistor's own $R_{in}$ to load the source:
$$
R_{in,\text{bootstrap}} \approx R_b \| [\,r_\pi + (\beta+1)R_e\,] \gg R_{in,\text{no bootstrap}}
$$
The DC bias is unaffected because $C_{bs}$ blocks DC.

---

### 5.2 CC Bootstrap Bias Point

**Note:** The formula $R_2 = 100 + 10Y_m + X_n$ uses personalized digit indices from Exp. 1, Q 2.3. The calculation below uses $R_2 = 12\,\text{k}\Omega$ as shown in the figure — substitute the personalized value once confirmed.

**DC analysis** ($C_{bs}$, $C_1$, $C_2$ all open at DC):

**KCL at Node A** (junction of R1, Rb, R2):
$$
\frac{V_{CC} - V_A}{R_1} = \frac{V_A}{R_2} + \frac{V_A - V_B}{R_b}
$$
**Base loop:**
$$
V_B = V_{BE} + (\beta+1)\,I_B \cdot R_e, \qquad I_B = \frac{V_A - V_B}{R_b}
$$
Solving simultaneously with $\beta = 100$, $V_{BE} = 0.7\,\text{V}$, $R_1 = R_b = 10\,\text{k}$, $R_2 = 12\,\text{k}$, $R_e = 2\,\text{k}$:
$$
V_B = 7.65\,\text{V}, \qquad V_A = 7.99\,\text{V}
$$
$$
I_B = \frac{V_A - V_B}{R_b} = \frac{0.34}{10\,\text{k}} = 34\,\mu\text{A}
$$
$$
I_C = \beta\,I_B = 3.40\,\text{mA}, \qquad I_E = (\beta+1)\,I_B = 3.43\,\text{mA}
$$
$$
V_E = I_E \cdot R_e = 3.43\,\text{mA} \times 2\,\text{k} = 6.86\,\text{V}
$$
$$
V_C = V_{CC} = 15\,\text{V} \quad (\text{collector tied to Vcc})
$$
$$
\boxed{V_{CE} = 15 - 6.86 = 8.14\,\text{V}, \qquad I_C = 3.40\,\text{mA}}
$$
**Active region verified:** $V_{CE} = 8.14\,\text{V} \gg V_{CE,sat} = 0.2\,\text{V}$ ✓

**Small-signal parameters:**
$$
g_m = \frac{I_C}{V_T} = \frac{3.40\,\text{mA}}{26\,\text{mV}} = 130.8\,\text{mA/V}, \qquad r_\pi = \frac{\beta}{g_m} = 765\,\Omega
$$
| Parameter | Value |
|-----------|-------|
| $V_B$ | 7.65 V |
| $V_E$ | 6.86 V |
| $V_C$ | 15.00 V |
| $V_{CE}$ | 8.14 V |
| $I_C$ | 3.40 mA |
| $I_B$ | 34 μA |

---

### 5.3–5.5 Bootstrap Circuit: DC Bias & Frequency Response Simulation

**DC simulation — bias point verification:**

![Fig. 9 — CC Bootstrap DC bias point (PSpice operating point)](assets/fig9_bootstrap_dc_bias.png)  
*Figure 9: PSpice DC operating point simulation of the CC amplifier with bootstrap. Node voltages and branch currents confirm (or correct) the analytically computed bias point: $V_B \approx 7.65\,\text{V}$, $V_E \approx 6.86\,\text{V}$, $I_C \approx 3.40\,\text{mA}$.*

**Frequency response (with $C_{bs}$):**

![Fig. 10 — CC Bootstrap Bode plot (with Cbs)](assets/fig10_bootstrap_bode_with_cbs.png)  
*Figure 10: Bode magnitude plot of the CC amplifier **with** bootstrap capacitor $C_{bs} = 22\,\mu\text{F}$. The mid-band gain is near unity ($\approx 0\,\text{dB}$), and the $-3\,\text{dB}$ bandwidth is significantly wider than the emitter follower without bootstrap, due to the increased effective input resistance.*

**Bandwidth and gain (with $C_{bs}$) — to be filled from simulation:**

| Parameter | Value |
|-----------|-------|
| Mid-band gain $V_o/V_g$ | [from sim] |
| $f_{-3\text{dB}}$ | [from sim] |
| Bandwidth | [from sim] |

---

### 5.6 Emitter Follower Without Bootstrap (Cbs Disconnected)

![Fig. 11 — Emitter Follower Bode plot (without Cbs)](assets/fig11_emitter_follower_bode_no_cbs.png)  
*Figure 11: Bode magnitude plot of the same circuit with $C_{bs}$ disconnected (emitter follower only). Without bootstrapping, $R_1$ directly loads the input, reducing $R_{in}$ and narrowing the bandwidth significantly. The mid-band gain remains near unity but the $-3\,\text{dB}$ frequency shifts substantially.*

**Bandwidth and gain (without $C_{bs}$) — to be filled from simulation:**

| Parameter | Value |
|-----------|-------|
| Mid-band gain $V_o/V_g$ | [from sim] |
| $f_{-3\text{dB}}$ | [from sim] |
| Bandwidth | [from sim] |

---

### 5.7 Comparison Table

| Amplifier | $V_o/V_g$ | Loss of $V_o$ [%] | $f_{-3\text{dB}}$ |
|-----------|-------------|---------------------|---------------------|
| Bootstrap (with $C_{bs}$) | [from sim] | [from sim] | [from sim] |
| Emitter Follower (without $C_{bs}$) | [from sim] | [from sim] | [from sim] |

**Discussion:** Bootstrapping increases $R_{in}$ effectively, which together with $R_g$ forms a less severe voltage divider, preserving more of $V_g$ at the base. The bandwidth improvement arises from the same mechanism: a higher $R_{in}$ means less capacitive loading effect at the input node, extending the high-frequency response.

---

## References

1. A. S. Sedra and K. C. Smith, *Microelectronic Circuits*, 7th ed., Oxford University Press, 2016.
2. P. R. Gray, P. J. Hurst, S. H. Lewis and R. G. Meyer, *Analysis and Design of Analog Integrated Circuits*, 5th ed., Wiley, 2009.
3. TAU Faculty of Engineering, *Experiment No. 4 Procedure: Bipolar Junction Transistors*, Lab A Electronics, Semester B 2025-2026.8605
8605