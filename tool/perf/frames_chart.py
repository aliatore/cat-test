"""Dibuja una grafica SVG de tiempos por frame a partir del resumen de la traza.

    python3 tool/perf/frames_chart.py <resumen.json> <salida.svg> "<titulo>"
"""
import json
import sys

path = sys.argv[1] if len(sys.argv) > 1 else 'docs/performance/scroll_timeline.timeline_summary.json'
target = sys.argv[2] if len(sys.argv) > 2 else 'docs/performance/scroll_frames.svg'
title = sys.argv[3] if len(sys.argv) > 3 else 'Scroll con 98 razas cargadas'
note = sys.argv[4] if len(sys.argv) > 4 else ''
data = json.load(open(path))
build = [v / 1000 for v in data['frame_build_times']]
raster = [v / 1000 for v in data['frame_rasterizer_times']]
n = max(len(build), len(raster))

W, H = 960, 360
left, right, top, bottom = 56, 20, 46, 50
plot_w, plot_h = W - left - right, H - top - bottom
max_ms = 20.0
budget = 1000 / 60


def x(i):
    return left + plot_w * i / max(n - 1, 1)


def y(ms):
    return top + plot_h * (1 - min(ms, max_ms) / max_ms)


out = [
    f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" font-family="ui-monospace, Menlo, monospace">',
    f'<rect width="{W}" height="{H}" fill="#07060F"/>',
    f'<text x="{left}" y="24" fill="#ECEAFB" font-size="15">{title} — {n} frames (profile, emulador Android 16)</text>',
]
for ms in (0, 5, 10, 15, 20):
    out.append(f'<line x1="{left}" x2="{W-right}" y1="{y(ms):.1f}" y2="{y(ms):.1f}" stroke="#2B2653" stroke-width="1"/>')
    out.append(f'<text x="{left-8}" y="{y(ms)+4:.1f}" fill="#A7A3CC" font-size="11" text-anchor="end">{ms} ms</text>')

bar_w = max(plot_w / n - 0.6, 1)
for i, v in enumerate(raster):
    out.append(f'<rect x="{x(i)-bar_w/2:.1f}" y="{y(v):.1f}" width="{bar_w:.1f}" height="{y(0)-y(v):.1f}" fill="#00F0FF" opacity="0.55"/>')
pts = ' '.join(f'{x(i):.1f},{y(v):.1f}' for i, v in enumerate(build))
out.append(f'<polyline points="{pts}" fill="none" stroke="#FF2E88" stroke-width="1.6"/>')
out.append(f'<line x1="{left}" x2="{W-right}" y1="{y(budget):.1f}" y2="{y(budget):.1f}" stroke="#FCEE0A" stroke-dasharray="6 4" stroke-width="1.4"/>')
out.append(f'<text x="{W-right}" y="{y(budget)-6:.1f}" fill="#FCEE0A" font-size="11" text-anchor="end">presupuesto 16.7 ms (60 Hz)</text>')

legend_y = H - 16
out.append(f'<rect x="{left}" y="{legend_y-9}" width="12" height="10" fill="#00F0FF" opacity="0.55"/>')
out.append(f'<text x="{left+18}" y="{legend_y}" fill="#ECEAFB" font-size="12">raster (GPU)</text>')
out.append(f'<line x1="{left+130}" x2="{left+150}" y1="{legend_y-4}" y2="{legend_y-4}" stroke="#FF2E88" stroke-width="2"/>')
out.append(f'<text x="{left+156}" y="{legend_y}" fill="#ECEAFB" font-size="12">build (UI)</text>')
if note:
    out.append(f'<text x="{W-right}" y="{legend_y}" fill="#A7A3CC" font-size="11" text-anchor="end">{note}</text>')
out.append('</svg>')

with open(target, 'w') as f:
    f.write('\n'.join(out))
print(target)
