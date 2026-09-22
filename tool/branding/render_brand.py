#!/usr/bin/env python3
"""Rasterises tool/branding/logo.svg into the NekoDex brand PNGs with headless Chrome."""
import math
import os
import re
import subprocess

REPO = '/Users/luisisturiz/Personal/cat-test'
LOGO = os.path.join(REPO, 'tool', 'branding', 'logo.svg')
OUT = os.path.join(REPO, 'tool', 'branding', 'out')
WORK = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'brand_work')
CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'

# Art anchor: centre of the smallest circle enclosing the head + whiskers (512 space)
ART_C = (256.0, 259.4)
ART_R = 203.0   # enclosing radius at the vertices (without stroke)

# Monochrome (Android 13 themed icon): flat white, no glow. Inner ears are dropped
# (at line-art weight they merge with the ear edges) and the eyes are solid with the
# canonical slit pupils cut out as real transparency.
MONO_CSS = """
.mono .nk-tubes { filter: none; }
.mono .nk-cores, .mono .nk-ears, .mono .nk-pupils { display: none; }
.mono .nk-tubes > * { stroke: #FFFFFF; }
.mono .nk-outline { stroke-width: 15px; }
.mono .nk-chevron { stroke-width: 12px; }
.mono .nk-eyes { stroke-width: 14px; fill: #FFFFFF; fill-opacity: 1; mask: url(#pupil-cut); }
.mono .nk-whiskers, .mono .nk-mouth { stroke-width: 9px; }
.mono .nk-nose { fill: #FFFFFF; stroke-width: 8px; }
"""
PUPIL_MASK = """<defs><mask id="pupil-cut" maskUnits="userSpaceOnUse" x="0" y="0" width="512" height="512">
  <rect width="512" height="512" fill="#fff"/>
  <path fill="#000" d="M203,248 L209,266 L203,284 L197,266 Z M309,248 L315,266 L309,284 L303,266 Z"/>
</mask></defs>"""


def logo_markup(center, scale, cls=''):
    svg = open(LOGO).read()
    svg = re.sub(r'<\?xml.*?\?>', '', svg)
    svg = re.sub(r'<!--.*?-->', '', svg, flags=re.S)
    x = center[0] - ART_C[0] * scale
    y = center[1] - ART_C[1] * scale
    size = 512 * scale
    svg = svg.replace('width="512" height="512"',
                      'x="%.2f" y="%.2f" width="%.2f" height="%.2f" class="%s"' % (x, y, size, size, cls), 1)
    return svg.strip()


def grid(size, horizon, color='#FF2E88'):
    """Faint perspective floor grid under the head, fading out towards the horizon."""
    vp = size / 2
    lines = []
    for i in range(-12, 13):
        lines.append('<line x1="%.1f" y1="%.1f" x2="%.1f" y2="%d"/>' % (vp, horizon, vp + i * 150, size))
    for z in (1.0, 1.32, 1.75, 2.35, 3.15, 4.3, 6.0):
        y = horizon + (size - horizon) / z
        lines.append('<line x1="0" y1="%.1f" x2="%d" y2="%.1f"/>' % (y, size, y))
    return """
  <defs>
    <linearGradient id="gridFade" x1="0" y1="%(h)d" x2="0" y2="%(s)d" gradientUnits="userSpaceOnUse">
      <stop offset="0" stop-color="#fff" stop-opacity="0"/>
      <stop offset="0.35" stop-color="#fff" stop-opacity="0.35"/>
      <stop offset="1" stop-color="#fff" stop-opacity="1"/>
    </linearGradient>
    <mask id="gridMask"><rect x="0" y="%(h)d" width="%(s)d" height="%(r)d" fill="url(#gridFade)"/></mask>
  </defs>
  <g mask="url(#gridMask)" stroke="%(c)s" stroke-opacity="0.30" stroke-width="2" fill="none">%(l)s</g>
""" % {'h': horizon, 's': size, 'r': size - horizon, 'c': color, 'l': ''.join(lines)}


def page(size, body, background='transparent', css=''):
    return """<!doctype html><html><head><meta charset="utf-8"><style>
html,body{margin:0;padding:0;background:%s;overflow:hidden}
svg.root{display:block}
%s
</style></head><body>
<svg class="root" xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" viewBox="0 0 %d %d">
%s
</svg></body></html>""" % (background, css, size, size, size, size, body)


def shoot(name, size, html, transparent=True):
    os.makedirs(WORK, exist_ok=True)
    os.makedirs(OUT, exist_ok=True)
    src = os.path.join(WORK, name + '.html')
    png = os.path.join(WORK if not transparent else OUT, name + ('_rgba.png' if not transparent else '.png'))
    with open(src, 'w') as fh:
        fh.write(html)
    args = [CHROME, '--headless=new', '--disable-gpu', '--hide-scrollbars', '--force-device-scale-factor=1',
            '--window-size=%d,%d' % (size, size), '--screenshot=' + png]
    if transparent:
        args.append('--default-background-color=00000000')
    subprocess.run(args + ['file://' + src], check=True, capture_output=True)
    if not transparent:  # icono iOS: sin canal alfa
        final = os.path.join(OUT, name + '.png')
        subprocess.run(['ffmpeg', '-v', 'error', '-y', '-i', png, '-pix_fmt', 'rgb24', final], check=True)
        png = final
    return png


def alpha_stats(png, size):
    raw = subprocess.run(['ffmpeg', '-v', 'error', '-i', png, '-vf', 'alphaextract', '-f', 'rawvideo',
                          '-pix_fmt', 'gray', '-'], check=True, capture_output=True).stdout
    c = (size - 1) / 2
    res = {}
    for thr in (0, 8, 64):
        rmax, box = 0.0, [size, size, -1, -1]
        for y in range(size):
            row = raw[y * size:(y + 1) * size]
            xs = [x for x in range(size) if row[x] > thr]
            if not xs:
                continue
            box = [min(box[0], xs[0]), min(box[1], y), max(box[2], xs[-1]), max(box[3], y)]
            for x in (xs[0], xs[-1]):
                rmax = max(rmax, math.hypot(x - c, y - c))
        res[thr] = (round(rmax, 1), box)
    return res


def build():
    results = {}
    # 1) App icon 1024, opaco: fondo, halo radial, rejilla en perspectiva y la cabeza al ~70% de ancho
    s_icon = 2.0
    body = """
  <defs>
    <radialGradient id="halo" cx="512" cy="492" r="560" gradientUnits="userSpaceOnUse">
      <stop offset="0" stop-color="#9D4EDD" stop-opacity="0.26"/>
      <stop offset="0.45" stop-color="#FF2E88" stop-opacity="0.07"/>
      <stop offset="1" stop-color="#07060F" stop-opacity="0"/>
    </radialGradient>
    <radialGradient id="vignette" cx="512" cy="512" r="760" gradientUnits="userSpaceOnUse">
      <stop offset="0.55" stop-color="#000" stop-opacity="0"/>
      <stop offset="1" stop-color="#000" stop-opacity="0.6"/>
    </radialGradient>
  </defs>
  <rect width="1024" height="1024" fill="#07060F"/>
  <rect width="1024" height="1024" fill="url(#halo)"/>
  %s
  <rect width="1024" height="1024" fill="url(#vignette)"/>
  %s""" % (grid(1024, 690), logo_markup((512, 512), s_icon))
    results['app_icon'] = shoot('app_icon', 1024, page(1024, body, '#07060F'), transparent=False)

    # 2) Adaptive foreground 1024: solo la cabeza con brillo dentro del 60% central
    s_fg = 1.3
    clip = '<defs><clipPath id="c"><circle cx="512" cy="512" r="307"/></clipPath></defs>'
    body = clip + '<g clip-path="url(#c)">%s</g>' % logo_markup((512, 512), s_fg)
    results['app_icon_foreground'] = shoot('app_icon_foreground', 1024, page(1024, body))

    # 3) Monochrome 1024: linea blanca plana, mismo encaje que el foreground
    body = PUPIL_MASK + logo_markup((512, 512), s_fg, cls='mono')
    results['app_icon_monochrome'] = shoot('app_icon_monochrome', 1024, page(1024, body, css=MONO_CSS))

    # 4) Splash Android 12: 1152, todo dentro del circulo central de 768 px de diametro
    s_sp = 1.55
    clip = '<defs><clipPath id="c"><circle cx="576" cy="576" r="383"/></clipPath></defs>'
    body = clip + '<g clip-path="url(#c)">%s</g>' % logo_markup((576, 576), s_sp)
    results['splash_logo'] = shoot('splash_logo', 1152, page(1152, body))
    return results


if __name__ == '__main__':
    res = build()
    for name, png in res.items():
        info = subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'stream=width,height,pix_fmt',
                               '-of', 'csv=p=0', png], capture_output=True, text=True).stdout.strip()
        line = '%-22s %s  %d bytes' % (name, info, os.path.getsize(png))
        if 'rgba' in info:
            size = int(info.split(',')[0])
            st = alpha_stats(png, size)
            line += '\n    alpha>0 r=%s box=%s | alpha>8 r=%s | alpha>64 r=%s' % (
                st[0][0], st[0][1], st[8][0], st[64][0])
        print(line)
