#!/usr/bin/env python3
"""Generate Bode-magnitude figures for Lab 7 report, sections 7.1 and 7.3/7.4."""
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
TEAL = "#006b73"
BLUE = "#0B5FB0"

def mag_db(f, A0, fp):
    return 20*np.log10(A0/np.sqrt(1.0+(f/fp)**2))

# ----------------------------------------------------------------------------
# Figure for 7.1 : qualitative single-pole open-loop magnitude (symbolic axes)
# ----------------------------------------------------------------------------
A0, fp = 1e5, 10.0          # shape only; axes are labelled symbolically
ft = A0*fp
A0db = 20*np.log10(A0)
f = np.logspace(np.log10(fp)-2.2, np.log10(ft)+1.2, 2000)

fig, ax = plt.subplots(figsize=(6.9, 4.3))
ax.semilogx(f, mag_db(f, A0, fp), color=BLUE, lw=2.4, zorder=4)

# light reference lines at the key levels and corner frequencies
for y in (A0db, 0.0):
    ax.axhline(y, color="0.72", ls=":", lw=0.9, zorder=1)
for x in (fp, ft):
    ax.axvline(x, color="0.72", ls=":", lw=0.9, zorder=1)

# corner (-3 dB) and unity-gain points
ax.scatter([fp], [A0db-3], color=TEAL, s=38, zorder=6)
ax.scatter([ft], [0.0],    color=TEAL, s=38, zorder=6)

# annotations kept in the empty regions (top-left flat, mid slope, bottom-left)
ax.annotate(r"flat at $A_0$", xy=(f[0]*2.0, A0db),
            xytext=(f[0]*2.0, A0db+7), color=BLUE)
ax.annotate(r"$-20\,$dB/decade",
            xy=(fp*30, mag_db(fp*30, A0, fp)),
            xytext=(fp*26, mag_db(fp*30, A0, fp)+19), rotation=-31, color="0.40")
ax.annotate("dominant pole\n(open-loop $-3\\,$dB)", xy=(fp, A0db-3),
            xytext=(f[0]*1.25, 0.36*A0db), color=TEAL, ha="left", va="center",
            arrowprops=dict(arrowstyle="->", color=TEAL, lw=1.1))
ax.annotate(r"unity gain, $|A|=1$", xy=(ft, 0.0),
            xytext=(ft*0.18, -10), color=TEAL, ha="center", va="center",
            arrowprops=dict(arrowstyle="->", color=TEAL, lw=1.1))

# meaningful ticks: only f_p, f_t on x ; 0 dB and A_0 on y
ax.minorticks_off()
ax.set_xticks([fp, ft]); ax.set_xticklabels([r"$f_p$", r"$f_t$"])
ax.set_yticks([0, A0db]); ax.set_yticklabels([r"$0\,$dB", r"$A_0$"])
ax.set_xlabel("Frequency  (log scale)")
ax.set_ylabel(r"$|A_{OL}|$")
ax.set_xlim(f[0], f[-1]); ax.set_ylim(-16, A0db+16)
fig.tight_layout()
fig.savefig(f"{ASSETS}/bode_single_pole.png", dpi=150)
plt.close(fig)

# ----------------------------------------------------------------------------
# Figure for 7.3 / 7.4 : numerical A0 = 25+AB = 46 dB, fp = 50+DE = 80 kHz
# (AB = 21, DE = 30)  ->  ft = A0*fp ~ 16 MHz
# ----------------------------------------------------------------------------
A0db = 46.0
A0 = 10**(A0db/20.0)                          # ~200 V/V
fp = 80e3                                     # 80 kHz
ft = A0*fp                                    # ~16 MHz
f = np.logspace(3, 8, 3000)                   # 1 kHz .. 100 MHz

f_g = 8e5                                     # 10*(50+DE) = 800 kHz
g_fg = A0db - 20*np.log10(f_g/fp)            # 26 dB
g_t = 4.6                                     # 0.1*(25+AB) dB
f_t46 = fp*10**((A0db - g_t)/20.0)           # ~9.4 MHz

fig, ax = plt.subplots(figsize=(6.9, 4.3))
ax.semilogx(f, mag_db(f, A0, fp), color=BLUE, lw=2.2, zorder=3)
ax.axhline(0, color="0.4", lw=0.8)

ax.scatter([fp], [A0db-3], color=TEAL, s=32, zorder=5)
ax.scatter([ft], [0],      color=TEAL, s=32, zorder=5)
ax.scatter([f_g],   [g_fg], color="#c0392b", s=38, zorder=6)   # Q7.4: 26 dB @ 800 kHz
ax.scatter([f_t46], [g_t],  color="#c0392b", s=38, zorder=6)   # Q7.4: 4.6 dB @ 9.4 MHz

ax.annotate(r"$A_0 = 46\,$dB", xy=(f[0]*1.5, A0db),
            xytext=(f[0]*1.5, A0db+4), color=BLUE)
ax.annotate(r"$f_p = 80\,$kHz", xy=(fp, A0db-3), xytext=(fp*0.45, 33),
            color=TEAL, ha="right",
            arrowprops=dict(arrowstyle="->", color=TEAL, lw=1))
ax.annotate(r"$f_t \approx 16\,$MHz", xy=(ft, 0), xytext=(ft*0.30, -12),
            color=TEAL, ha="center",
            arrowprops=dict(arrowstyle="->", color=TEAL, lw=1))
ax.annotate(r"$26\,$dB @ $800\,$kHz", xy=(f_g, g_fg), xytext=(f[0]*1.5, 21),
            color="#c0392b", arrowprops=dict(arrowstyle="->", color="#c0392b", lw=1))
ax.annotate(r"$4.6\,$dB @ $9.4\,$MHz", xy=(f_t46, g_t), xytext=(2.5e6, 33),
            color="#c0392b", ha="center",
            arrowprops=dict(arrowstyle="->", color="#c0392b", lw=1))
ax.annotate(r"$-20\,$dB/decade", xy=(fp*4, mag_db(fp*4, A0, fp)),
            xytext=(fp*4.5, mag_db(fp*4, A0, fp)+10), rotation=-26, color="0.4")

ax.set_xlabel("Frequency  (Hz)")
ax.set_ylabel(r"$|A_{OL}|$  (dB)")
ax.set_xlim(f[0], f[-1])
ax.set_ylim(-18, A0db+14)
ax.grid(True, which="both", ls=":", lw=0.5, alpha=0.6)
fig.tight_layout()
fig.savefig(f"{ASSETS}/bode_numeric.png", dpi=150)
plt.close(fig)

print("wrote bode_single_pole.png and bode_numeric.png")
