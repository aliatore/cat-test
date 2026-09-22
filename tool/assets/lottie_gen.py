#!/usr/bin/env python3
"""Genera las animaciones Lottie de NekoDex: splash, loader, offline y empty.

    python3 tool/assets/lottie_gen.py

Escribe assets/lottie/*.json (JSON minificado, formato bodymovin 5.7.4).
Solo usa la biblioteca estandar de Python.

Compatibilidad (lottie-flutter 3.x, port de lottie-android): solo capas de forma
(ty 4) con gr/sh/el/rc/fl/st/tm/tr. Nada de texto, imagenes, efectos, mascaras,
mattes, capas null ni expresiones. El brillo neon se simula apilando trazos del
mismo path: halo ancho y tenue, trazo medio y nucleo fino (el primero de la
lista se pinta encima).
"""

import json
import math
import os

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
OUT_DIR = os.path.join(ROOT, 'assets', 'lottie')
FPS = 60

# Paleta de la app
MAGENTA, CYAN, YELLOW = '#FF2E88', '#00F0FF', '#FCEE0A'
PURPLE, MINT = '#9D4EDD', '#3CFFB4'

# Geometria canonica de la cabeza, lienzo 512x512 (y crece hacia abajo).
# La app dibuja exactamente la misma forma en codigo: no modificar.
HEAD = [(136, 96), (206, 172), (256, 166), (306, 172), (376, 96), (390, 208),
        (414, 290), (358, 370), (256, 406), (154, 370), (98, 290), (122, 208)]
EAR_L = [(137, 186), (144, 124), (183, 166)]
EAR_R = [(375, 186), (368, 124), (329, 166)]
CHEVRON = [(238, 196), (256, 212), (274, 196)]
EYE_L = [(164, 262), (222, 244), (236, 270), (182, 288)]
EYE_R = [(348, 262), (290, 244), (276, 270), (330, 288)]
PUPIL_L = [(203, 248), (209, 266), (203, 284), (197, 266)]
PUPIL_R = [(309, 248), (315, 266), (309, 284), (303, 266)]
NOSE = [(242, 314), (270, 314), (256, 330)]
MOUTH = [[(256, 330), (256, 340)], [(256, 340), (240, 352)], [(256, 340), (272, 352)]]
WHISKERS = [  # siempre desde la cara hacia afuera (el recorte crece hacia fuera)
    [(196, 326), (84, 310)], [(198, 338), (78, 342)], [(200, 350), (90, 376)],
    [(316, 326), (428, 310)], [(314, 338), (434, 342)], [(312, 350), (422, 376)]]

# Grosores (nucleo, medio, halo) en unidades del lienzo de 512
GLOW = (3.5, 9, 18)
GLOW_THIN = (3, 8, 16)
GLOW_SMALL = (5, 12, 22)  # para los lienzos de 256, que se ven mas pequenos

# Curvas de easing (ox, oy, ix, iy) como un cubic-bezier de CSS
LINEAR = (0.167, 0.167, 0.833, 0.833)
EASE = (0.4, 0, 0.2, 1)
EASE_OUT = (0.1, 0.6, 0.2, 1)
EASE_IN = (0.5, 0, 0.9, 0.4)
IN_OUT = (0.45, 0, 0.55, 1)
HOLD = 'hold'


# ----------------------------------------------------------------- primitivas
def color(hex_code):
    h = hex_code.lstrip('#')
    return [int(h[i:i + 2], 16) / 255 for i in (0, 2, 4)] + [1]


def prop(v):
    """Valor estatico, o el dict ya animado que devuelve anim()."""
    if isinstance(v, dict):
        return v
    return {'a': 0, 'k': list(v) if isinstance(v, tuple) else v}


def anim(*keys):
    """Claves (t, valor[, easing]); el easing describe el tramo hacia la siguiente."""
    keys = list(keys)
    if len(keys) > 1 and len(keys[-2]) > 2 and keys[-2][2] == HOLD:
        # lottie-android/flutter descartan la ultima clave (solo aporta el frame
        # final del tramo anterior): tras un HOLD el valor final no llegaria nunca.
        # Se repite la ultima clave un frame despues con un tramo normal.
        t, v = keys[-1][0], keys[-1][1]
        keys[-1] = (t, v, LINEAR)
        keys.append((t + 1, v))
    out = []
    for n, key in enumerate(keys):
        t, v = key[0], key[1]
        ease = key[2] if len(key) > 2 else EASE
        k = {'t': t, 's': list(v) if isinstance(v, (list, tuple)) else [v]}
        if n < len(keys) - 1:
            if ease == HOLD:
                k['h'] = 1
            else:
                k['o'] = {'x': [ease[0]], 'y': [ease[1]]}
                k['i'] = {'x': [ease[2]], 'y': [ease[3]]}
        out.append(k)
    return {'a': 1, 'k': out}


def path(points, closed=True, ins=None, outs=None):
    n = len(points)
    return {'ty': 'sh', 'nm': 'path', 'ks': {'a': 0, 'k': {
        'i': ins or [[0, 0]] * n, 'o': outs or [[0, 0]] * n,
        'v': [list(p) for p in points], 'c': closed}}}


def curve(p0, c1, c2, p3):
    """Un tramo de bezier cubica abierto (puntos de control absolutos)."""
    return path([p0, p3], closed=False,
                outs=[[c1[0] - p0[0], c1[1] - p0[1]], [0, 0]],
                ins=[[0, 0], [c2[0] - p3[0], c2[1] - p3[1]]])


def ellipse(center, size):
    return {'ty': 'el', 'nm': 'ellipse', 'd': 1, 'p': prop(tuple(center)), 's': prop(tuple(size))}


def rect(center, size):
    return {'ty': 'rc', 'nm': 'rect', 'd': 1, 'p': prop(tuple(center)),
            's': prop(tuple(size)), 'r': prop(0)}


def stroke(hex_code, width, opacity=100):
    return {'ty': 'st', 'nm': 'stroke', 'c': prop(color(hex_code)), 'o': prop(opacity),
            'w': prop(width), 'lc': 2, 'lj': 2, 'ml': 4, 'bm': 0}


def fill(hex_code, opacity=100):
    return {'ty': 'fl', 'nm': 'fill', 'c': prop(color(hex_code)), 'o': prop(opacity), 'r': 1, 'bm': 0}


def trim(s=0, e=100, o=0):
    return {'ty': 'tm', 'nm': 'trim', 's': prop(s), 'e': prop(e), 'o': prop(o), 'm': 1}


def group(name, items, p=(0, 0), a=(0, 0), s=(100, 100), r=0, o=100):
    tr = {'ty': 'tr', 'p': prop(p), 'a': prop(a), 's': prop(s), 'r': prop(r), 'o': prop(o)}
    return {'ty': 'gr', 'nm': name, 'it': list(items) + [tr]}


def glow(hex_code, widths=GLOW, alpha=1.0):
    core, mid, wide = widths
    return [stroke(hex_code, core, 100 * alpha), stroke(hex_code, mid, 35 * alpha),
            stroke(hex_code, wide, 12 * alpha)]


def neon(name, shapes, hex_code, widths=GLOW, trim_args=None, fill_args=None, alpha=1.0, **tr):
    """Grupo neon: paths + recorte opcional + trazos apilados (+ relleno debajo)."""
    items = list(shapes)
    if trim_args:
        items.append(trim(**trim_args))
    items += glow(hex_code, widths, alpha)
    if fill_args:
        items.append(fill(*fill_args))
    return group(name, items, **tr)


def xyz(v, z):
    return [v[0], v[1], z]


def layer(name, shapes, p=(256, 256), a=(256, 256), s=(100, 100), o=100, r=0):
    """Capa de forma. p/a/s estaticos se pasan como tuplas 2D; animados ya en 3D."""
    if isinstance(o, dict):
        # La opacidad animada va en un grupo envolvente y no en la capa: se ve
        # igual en lottie-android/flutter y evita un fallo del renderer canvas
        # de lottie-web con la opacidad animada de capa.
        shapes, o = [group(name, shapes, o=o)], 100
    ks = {'o': prop(o), 'r': prop(r),
          'p': p if isinstance(p, dict) else prop(xyz(p, 0)),
          'a': a if isinstance(a, dict) else prop(xyz(a, 0)),
          's': s if isinstance(s, dict) else prop(xyz(s, 100))}
    return {'ddd': 0, 'ty': 4, 'nm': name, 'sr': 1, 'ks': ks, 'ao': 0,
            'shapes': shapes, 'ip': 0, 'st': 0, 'bm': 0}


def composition(name, size, op, layers):
    for ind, lay in enumerate(layers, 1):
        lay['ind'] = ind
        # Las capas duran un poco mas que la composicion: asi el ultimo frame
        # (progress = 1.0) sigue visible en lottie-android/flutter.
        lay['op'] = op + 10
    return {'v': '5.7.4', 'fr': FPS, 'ip': 0, 'op': op, 'w': size, 'h': size, 'nm': name,
            'ddd': 0, 'assets': [], 'layers': layers, 'markers': []}


def centroid(points):
    return (sum(p[0] for p in points) / len(points), sum(p[1] for p in points) / len(points))


def mirror(points):
    return [(512 - x, y) for x, y in points]


def draw_on(t0, t1, ease=EASE):
    """Recorte que dibuja el path de principio a fin (end 0 -> 100)."""
    return {'e': anim((t0, 0, ease), (t1, 100))}


def pop(t, peak=125):
    """Escala 0 -> sobrepaso -> 100 (y oculto hasta t) para 'encender' piezas pequenas."""
    return {'s': anim((t, [0, 0], EASE_OUT), (t + 6, [peak, peak], IN_OUT),
                      (t + 10, [92, 92], IN_OUT), (t + 14, [100, 100])),
            'o': anim((0, 0, HOLD), (t, 100))}


def life_anim(loop, offset, life, keys):
    """Anima un ciclo de vida (fraccion, valor) que empieza en `offset` y puede
    dar la vuelta al final del loop. Interpolacion lineal, asi el corte en el
    frame 0/loop coincide exactamente y el loop no salta."""
    def value_at(frac):
        for (f0, v0), (f1, v1) in zip(keys, keys[1:]):
            if f0 <= frac <= f1:
                u = (frac - f0) / (f1 - f0)
                if isinstance(v0, (list, tuple)):
                    return [a + (b - a) * u for a, b in zip(v0, v1)]
                return v0 + (v1 - v0) * u
        return keys[-1][1]

    pts = []  # (t, valor, easing hacia la siguiente)
    end = offset + life
    if end > loop:  # la vida cruza el final: empieza el loop a mitad de ciclo
        split = (loop - offset) / life
        pts.append((0, value_at(split), LINEAR))
        for f, v in keys:
            if f > split:
                pts.append((offset + f * life - loop, v, LINEAR))
        pts[-1] = (pts[-1][0], pts[-1][1], HOLD)
        for f, v in keys:
            if f < split:
                pts.append((offset + f * life, v, LINEAR))
        pts.append((loop, value_at(split), LINEAR))
    else:
        if offset > 0:
            pts.append((0, keys[0][1], HOLD))
        for f, v in keys:
            pts.append((offset + f * life, v, LINEAR))
        if end < loop:
            pts[-1] = (pts[-1][0], pts[-1][1], HOLD)
            pts.append((loop, keys[0][1], LINEAR))
    return anim(*pts)


# ----------------------------------------------------------- piezas de la cabeza
def outline(widths, trim_args=None, hex_code=MAGENTA, alpha=1.0):
    return neon('outline', [path(HEAD)], hex_code, widths, trim_args, alpha=alpha)


def ears(widths, trim_args=None):
    return neon('ears', [path(EAR_L, False), path(EAR_R, False)], PURPLE, widths, trim_args)


def chevron(widths, trim_args=None):
    return neon('chevron', [path(CHEVRON, False)], YELLOW, widths, trim_args)


def nose(widths, **tr):
    return neon('nose', [path(NOSE)], YELLOW, widths, fill_args=(YELLOW, 100), **tr)


def mouth(widths, trim_args=None):
    return neon('mouth', [path(seg, False) for seg in MOUTH], CYAN, widths, trim_args)


def whisker(i, widths, trim_args=None):
    return neon('whisker_%d' % i, [path(WHISKERS[i], False)], CYAN, widths, trim_args)


def eye(side, widths, **tr):
    """Ojo cian con relleno tenue y pupila rasgada amarilla encima."""
    shape, pupil = (EYE_L, PUPIL_L) if side == 'L' else (EYE_R, PUPIL_R)
    pupil_g = group('pupil', [path(pupil), stroke(YELLOW, 2), stroke(YELLOW, 7, 30), fill(YELLOW)])
    eye_g = neon('eye', [path(shape)], CYAN, widths, fill_args=(CYAN, 22))
    if 's' in tr:  # parpadeo/escala alrededor del centro del ojo
        c = centroid(shape)
        tr.setdefault('p', c)
        tr.setdefault('a', c)
    return group('eye_' + side, [pupil_g, eye_g], **tr)


def static_face(widths, eye_tr=None, eyes_opacity=100):
    """Cabeza completa sin animar (orden: lo primero queda encima)."""
    eye_tr = eye_tr or {}
    return [
        group('eyes', [eye('L', widths, **eye_tr), eye('R', widths, **eye_tr)], o=eyes_opacity),
        nose(widths), mouth(widths),
        group('whiskers', [whisker(i, widths) for i in range(6)]),
        chevron(widths), ears(widths), outline(widths),
    ]


# -------------------------------------------------------------------- splash
# Trazas de circuito (lado izquierdo; el derecho es su espejo): (puntos, t0, t1)
TRACES = [
    ([(122, 208), (92, 208), (60, 176), (60, 70)], 70, 94),
    ([(110, 249), (30, 249)], 76, 96),
]
CHIN_TRUNK = [(256, 406), (256, 436)]
CHIN_BRANCH = [(256, 436), (232, 460), (232, 486)]


def splash():
    op = 144
    face = [
        group('eyes', [eye('L', GLOW), eye('R', GLOW)],
              o=anim((0, 0, HOLD), (64, 100, HOLD), (68, 10, HOLD), (73, 100, HOLD),
                     (79, 40, HOLD), (85, 100))),
        nose(GLOW, p=centroid(NOSE), a=centroid(NOSE), **pop(46, 120)),
        mouth(GLOW_THIN, draw_on(52, 66)),
        group('whiskers', [whisker(i, GLOW_THIN, draw_on(50 + 4 * (i % 3), 72 + 4 * (i % 3)))
                           for i in range(6)]),
        chevron(GLOW_THIN, {'s': anim((36, 50, EASE), (66, 0)), 'e': anim((36, 50, EASE), (66, 100))}),
        ears(GLOW_THIN, draw_on(30, 62)),
        outline(GLOW, draw_on(6, 54, IN_OUT)),
    ]

    # Glitch 96-106: la cabeza tiembla 2-3 px (claves hold)
    def at(dx, dy):
        return [256 + dx, 256 + dy, 0]
    jitter = anim((0, at(0, 0), HOLD), (96, at(3, 0), HOLD), (98, at(-2, 1), HOLD),
                  (100, at(2, -1), HOLD), (102, at(-3, 0), HOLD), (104, at(1, 1), HOLD),
                  (106, at(0, 0)))
    head = layer('head', face, p=jitter)

    ghost = layer('glitch_ghost', [outline(GLOW_THIN, hex_code=CYAN, alpha=0.8)],
                  p=anim((0, at(0, 0), HOLD), (96, at(8, 0), HOLD), (99, at(-6, 0), HOLD),
                         (102, at(5, 0), HOLD), (104, at(-3, 0), HOLD), (106, at(0, 0))),
                  o=anim((0, 0, HOLD), (96, 80, HOLD), (101, 50, HOLD), (104, 70, HOLD), (106, 0)))

    # Trazas que crecen desde las sienes y la barbilla, con nodos que aparecen
    thin = (2, 7, 14)
    traces, nodes = [], []

    def add_trace(pts, t0, t1):
        traces.append(neon('trace', [path(pts, False)], PURPLE, thin, draw_on(t0, t1)))

    def add_node(center, t):
        nodes.append(group('node', [
            group('dot', [ellipse((0, 0), (8, 8)), fill(MINT)]),
            neon('ring', [ellipse((0, 0), (18, 18))], MINT, (2, 6, 12)),
        ], p=center, **pop(t)))

    for pts, t0, t1 in TRACES:
        for side in (pts, mirror(pts)):
            add_trace(side, t0, t1)
            add_node(side[-1], t1 - 2)
    add_trace(CHIN_TRUNK, 80, 88)
    for side in (CHIN_BRANCH, mirror(CHIN_BRANCH)):
        add_trace(side, 88, 102)
        add_node(side[-1], 100)

    ring = layer('pulse_ring', [neon('ring', [ellipse((256, 256), (380, 380))], CYAN, (2.5, 7, 14))],
                 s=anim((100, [85, 85, 100], EASE_OUT), (144, [125, 125, 100])),
                 o=anim((0, 0, HOLD), (100, 60, (0.3, 0, 0.6, 1)), (140, 0)))

    return composition('nekodex_splash', 512, op, [
        ghost, ring,
        layer('nodes', nodes), layer('traces', traces),
        head,
    ])


# -------------------------------------------------------------------- loader
def loader():
    op = 90  # 1.5 s
    fit = dict(a=(256, 251), p=(128, 128), s=(60, 60))
    blink = anim((0, [100, 100], HOLD), (52, [100, 100], EASE_IN), (57, [100, 6], EASE_OUT),
                 (65, [100, 100]))
    face = static_face(GLOW_SMALL, eye_tr={'s': blink})

    # Linea de escaneo: nucleo + halo, con una estela tenue por encima
    scan = group('scan', [
        neon('line', [path([(64, 0), (448, 0)], False)], CYAN, (3.5, 11, 22)),
        group('trail', [rect((256, -8), (384, 16)), fill(CYAN, 9)]),
        group('trail_far', [rect((256, -18), (384, 36)), fill(CYAN, 5)]),
    ], p=anim((0, [0, 92], IN_OUT), (84, [0, 414])),
       o=anim((0, 0, EASE), (10, 100, HOLD), (70, 100, EASE), (84, 0)))

    return composition('nekodex_loader', 256, op, [
        layer('scan', [scan], **fit),
        layer('head', face, **fit),
    ])


# ------------------------------------------------------------------- offline
WIFI_CENTER = (256, 110)  # entre las orejas, por encima de la frente
WIFI_RADII = (28, 54, 80)
SLASH = [(206, 24), (306, 124)]


def arc(center, radius, a0_deg=225, a1_deg=315):
    """Arco de circunferencia (<= 90 grados) como una sola bezier cubica."""
    cx, cy = center
    a0, a1 = math.radians(a0_deg), math.radians(a1_deg)
    k = 4 / 3 * math.tan((a1 - a0) / 4) * radius
    p0 = (cx + radius * math.cos(a0), cy + radius * math.sin(a0))
    p3 = (cx + radius * math.cos(a1), cy + radius * math.sin(a1))
    c1 = (p0[0] - k * math.sin(a0), p0[1] + k * math.cos(a0))
    c2 = (p3[0] + k * math.sin(a1), p3[1] - k * math.cos(a1))
    return curve(p0, c1, c2, p3)


def offline():
    op = 120  # 2 s
    # Encaje: desde la punta de la barra (con halo) hasta la barbilla (con halo)
    top, bottom = SLASH[0][1] - 13, 406 + 11
    scale = round(100 * 236 / (bottom - top), 1)
    fit = dict(a=(256, (top + bottom) / 2), p=(128, 128), s=(scale, scale))
    eyes_o = anim((0, 38, HOLD), (16, 12, HOLD), (19, 38, HOLD), (54, 60, HOLD), (57, 8, HOLD),
                  (61, 45, HOLD), (64, 18, HOLD), (68, 38, HOLD), (100, 14, HOLD), (103, 38, HOLD),
                  (120, 38))
    face = static_face(GLOW_SMALL, eyes_opacity=eyes_o)

    # Arcos que intentan "conectar" (se encienden en orden) y fallan parpadeando
    arc_keys = [
        ((0, 55, HOLD), (28, 100, HOLD), (50, 20, HOLD), (53, 70, HOLD), (56, 30, HOLD),
         (60, 55, HOLD), (86, 100, HOLD), (98, 25, HOLD), (101, 55, HOLD), (120, 55)),
        ((0, 30, HOLD), (33, 100, HOLD), (50, 10, HOLD), (54, 60, HOLD), (57, 15, HOLD),
         (61, 30, HOLD), (90, 90, HOLD), (98, 10, HOLD), (102, 30, HOLD), (120, 30)),
        ((0, 14, HOLD), (38, 100, HOLD), (50, 0, HOLD), (55, 45, HOLD), (58, 5, HOLD),
         (62, 14, HOLD), (94, 70, HOLD), (98, 0, HOLD), (103, 14, HOLD), (120, 14)),
    ]
    arcs = [neon('arc_%d' % i, [arc(WIFI_CENTER, r)], CYAN, GLOW_SMALL, o=anim(*arc_keys[i]))
            for i, r in enumerate(WIFI_RADII)]
    dot = group('dot', [ellipse(WIFI_CENTER, (18, 18)), fill(CYAN)] + glow(CYAN, (2, 10, 20)),
                o=anim((0, 90, HOLD), (50, 40, HOLD), (54, 90, HOLD), (120, 90)))
    slash = neon('slash', [path(SLASH, False)], MAGENTA, (6, 14, 26),
                 o=anim((0, 100, HOLD), (50, 45, HOLD), (52, 100, HOLD), (98, 60, HOLD),
                        (100, 100, HOLD), (120, 100)))

    return composition('nekodex_offline', 256, op, [
        layer('wifi', [slash, group('signal', arcs + [dot])], **fit),
        layer('head', face, **fit),
    ])


# --------------------------------------------------------------------- empty
CLOSED_L = ((166, 263), (184, 283), (216, 287), (234, 268))  # curva hacia abajo


def closed_eye(pts, widths):
    return neon('closed_eye', [curve(*pts)], CYAN, widths)


def empty():
    op = 180  # 3 s
    scale = 55
    face = static_face(GLOW_SMALL)
    face[0] = group('eyes', [closed_eye(CLOSED_L, GLOW_SMALL),
                             closed_eye(tuple(mirror(CLOSED_L)), GLOW_SMALL)])
    # Respiracion suave: escala desde la barbilla (loop sin costura)
    breathe = anim((0, [scale, scale, 100], IN_OUT), (90, [scale * 1.025, scale * 1.025, 100], IN_OUT),
                   (180, [scale, scale, 100]))
    # Cabeza algo a la izquierda y abajo: deja sitio a las Z arriba a la derecha
    head = layer('head', face, a=(256, 406), p=(118, 154 + (406 - 251) * scale / 100), s=breathe)

    # Tres "Z" dibujadas como paths que suben a la derecha, crecen y se apagan
    z_path = path([(-9, -9), (9, -9), (-9, 9), (9, 9)], closed=False)
    zs = []
    for n, (offset, hex_code) in enumerate(((0, CYAN), (60, PURPLE), (120, CYAN))):
        life = 110
        zs.append(layer('z_%d' % n, [neon('z', [z_path], hex_code, (2.6, 6.5, 12))],
                        a=(0, 0),
                        p=life_anim(op, offset, life, [(0, [204, 62, 0]), (1, [234, 22, 0])]),
                        s=life_anim(op, offset, life, [(0, [45, 45, 100]), (1, [112, 112, 100])]),
                        r=life_anim(op, offset, life, [(0, -14), (1, 8)]),
                        o=life_anim(op, offset, life, [(0, 0), (0.18, 100), (0.6, 100), (1, 0)])))
    return composition('nekodex_empty', 256, op, zs + [head])


# ---------------------------------------------------------------------- main
def _round(v):
    if isinstance(v, float):
        r = round(v, 3)
        return int(r) if r == int(r) else r
    if isinstance(v, list):
        return [_round(x) for x in v]
    if isinstance(v, dict):
        return {k: _round(x) for k, x in v.items()}
    return v


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    for name, build in (('splash', splash), ('loader', loader), ('offline', offline), ('empty', empty)):
        data = json.dumps(_round(build()), separators=(',', ':'))
        target = os.path.join(OUT_DIR, name + '.json')
        with open(target, 'w') as fh:
            fh.write(data)
        print('%-8s %6d bytes  %s' % (name, len(data), os.path.relpath(target, ROOT)))


if __name__ == '__main__':
    main()
