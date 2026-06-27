#!/usr/bin/env python3
"""Qualitative output drawings for Lab 7, Q9.2.1 (f<<fp) and Q9.2.2 (f>>fp)."""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

plt.rcParams.update({
    "font.family": "serif",
    "font.serif": ["Times New Roman", "Nimbus Roman", "DejaVu Serif"],
    "mathtext.fontset": "stix",
    "font.size": 12,
    "axes.linewidth": 0.9,
})

ASSETS = "/Users/dan.masad/tau_workspace/LabA-electronics/labs/LAB-7/assets"
BLUE = "#0B5FB0"
TEAL = "#006b73"

T = 1.0
t = np.linspace(0, 2.5 * T, 4000)
sq = np.sign(np.sin(2 * np.pi * t / T))
sq[sq == 0] = 1.0

def style_time_axis(ax):
    ax.set_xlim(0, t[-1])
    ax.set_xticks([])
    ax.axhline(0, color="0.6", lw=0.8, zorder=1)
    ax.grid(True, axis="x", ls=":", lw=0.4, alpha=0.4)

# ---------------------------------------------------------------------------
# 9.2.1  f << fp : inverting amplifier, Vout = -(R/R1) Vin = -2 Vin
# ---------------------------------------------------------------------------
fig, (a1, a2) = plt.subplots(2, 1, figsize=(6.4, 3.7), sharex=True)
a1.plot(t, sq, color=BLUE, lw=2.2)
a1.set_ylim(-3.2, 3.2); a1.set_yticks([-1, 0, 1]); a1.set_yticklabels(["$-A$", "0", "$+A$"])
a1.set_ylabel("input  $V_{in}$")
a1.set_title(r"$f \ll f_p$:  inverting amplifier,  $V_{out}=-\frac{R}{R_1}V_{in}=-2V_{in}$",
             fontsize=11)

a2.plot(t, -2 * sq, color=TEAL, lw=2.2)
a2.set_ylim(-3.2, 3.2); a2.set_yticks([-2, 0, 2]); a2.set_yticklabels(["$-2A$", "0", "$+2A$"])
a2.set_ylabel("output  $V_{out}$")
a2.set_xlabel("time")
for ax in (a1, a2):
    style_time_axis(ax)
fig.tight_layout()
fig.savefig(f"{ASSETS}/q9_lowfreq.png", dpi=150)
plt.close(fig)

# ---------------------------------------------------------------------------
# 9.2.2  f >> fp : ideal integrator, Vout ~ -(1/R1 C) integral(Vin) -> triangle
# ---------------------------------------------------------------------------
dt = t[1] - t[0]
tri = np.cumsum(-sq) * dt          # inverting integrator
tri -= tri.mean()
tri /= np.max(np.abs(tri))         # normalise (amplitude is qualitative, ~1/f)

fig, (b1, b2) = plt.subplots(2, 1, figsize=(6.4, 3.7), sharex=True)
b1.plot(t, sq, color=BLUE, lw=2.2)
b1.set_ylim(-1.6, 1.6); b1.set_yticks([-1, 0, 1]); b1.set_yticklabels(["$-A$", "0", "$+A$"])
b1.set_ylabel("input  $V_{in}$")
b1.set_title(r"$f \gg f_p$:  circuit acts as an ideal integrator  (output $\propto \int V_{in}\,dt$)",
             fontsize=11)

b2.plot(t, tri, color=TEAL, lw=2.2)
b2.set_ylim(-1.6, 1.6); b2.set_yticks([0]); b2.set_yticklabels(["0"])
b2.set_ylabel("output  $V_{out}$")
b2.set_xlabel("time")
for ax in (b1, b2):
    style_time_axis(ax)
fig.tight_layout()
fig.savefig(f"{ASSETS}/q9_highfreq.png", dpi=150)
plt.close(fig)

print("wrote q9_lowfreq.png and q9_highfreq.png")
