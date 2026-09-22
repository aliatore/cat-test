#!/usr/bin/env python3
"""Genera los efectos de sonido de NekoDex: boot, tap, meow, glitch, success, notify.

    python3 tool/assets/sfx_gen.py

Se sintetizan en WAV mono de 16 bit a 44.1 kHz y los efectos de la app se
guardan como MP3 en assets/sfx/ (con ffmpeg; en WAV pesaban 10 veces mas).
notify solo va como WAV nativo de notificacion (android res/raw e ios/Runner),
que es el formato que acepta iOS.
Sintesis con la biblioteca estandar y semilla fija: la salida es reproducible.
"""

import math
import os
import random
import shutil
import struct
import subprocess
import tempfile
import wave

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
SFX_DIR = os.path.join(ROOT, 'assets', 'sfx')
NOTIFY_COPIES = [
    os.path.join(ROOT, 'android', 'app', 'src', 'main', 'res', 'raw', 'nekodex_notify.wav'),
    os.path.join(ROOT, 'ios', 'Runner', 'nekodex_notify.wav'),
]
SR = 44100
TAU = 2 * math.pi
rng = random.Random(2077)


# ------------------------------------------------------------------ utilidades
def ns(sec):
    return int(round(sec * SR))


def zeros(sec):
    return [0.0] * ns(sec)


def mix_into(dst, src, at=0.0, gain=1.0):
    off = ns(at)
    for i in range(min(len(src), len(dst) - off)):
        dst[off + i] += src[i] * gain


def curve(points, t, log=False):
    """Interpolacion suave (coseno) entre puntos (t, v); log=True la hace en octavas."""
    if t <= points[0][0]:
        return points[0][1]
    for (t0, v0), (t1, v1) in zip(points, points[1:]):
        if t <= t1:
            u = 0.5 - 0.5 * math.cos(math.pi * (t - t0) / (t1 - t0))
            return v0 * (v1 / v0) ** u if log else v0 + (v1 - v0) * u
    return points[-1][1]


def smoothstep(a, b, t):
    u = min(1.0, max(0.0, (t - a) / (b - a)))
    return u * u * (3 - 2 * u)


def envelope(buf, fn):
    return [v * fn(i / SR) for i, v in enumerate(buf)]


def pluck(attack, tau, length, release=0.008):
    """Ataque rapido + caida exponencial que llega a 0 justo al final del buffer
    (cortar una nota a medio decaer produce un click)."""
    return lambda t: ((1 - math.exp(-t / attack)) * math.exp(-t / tau)
                      * (1 - smoothstep(length - release, length, t)))


def noise(sec):
    return [rng.uniform(-1.0, 1.0) for _ in range(ns(sec))]


# ---------------------------------------------------------------- osciladores
def _blep(t, dt):
    """Correccion PolyBLEP: quita el aliasing de los saltos de sierra/cuadrada."""
    if t < dt:
        t /= dt
        return t + t - t * t - 1.0
    if t > 1.0 - dt:
        t = (t - 1.0) / dt
        return t * t + t + t + 1.0
    return 0.0


def osc(kind, freq, sec, phase=0.0):
    """Oscilador 'sine' | 'saw' | 'square' con frecuencia fija o funcion t -> Hz."""
    fn = freq if callable(freq) else (lambda _t: freq)
    out = [0.0] * ns(sec)
    for i in range(len(out)):
        dt = fn(i / SR) / SR
        if kind == 'sine':
            v = math.sin(TAU * phase)
        elif kind == 'saw':
            v = 2.0 * phase - 1.0 - _blep(phase, dt)
        else:
            v = (1.0 if phase < 0.5 else -1.0) + _blep(phase, dt) - _blep((phase + 0.5) % 1.0, dt)
        out[i] = v
        phase = (phase + dt) % 1.0
    return out


def additive_saw(freq_fn, sec, max_hz=8000.0, tilt=1.3):
    """Sierra de banda limitada por sintesis aditiva (armonicos 1/k^tilt).
    Los armonicos se desvanecen suavemente al acercarse a max_hz: sin chasquidos."""
    out = [0.0] * ns(sec)
    phase = 0.0
    for i in range(len(out)):
        f = freq_fn(i / SR)
        phase = (phase + f / SR) % 1.0
        th = TAU * phase
        c2 = 2.0 * math.cos(th)
        s_prev, s_cur = 0.0, math.sin(th)
        acc, k = 0.0, 1
        while k * f < max_hz:
            fade = min(1.0, (max_hz - k * f) / (0.25 * max_hz))
            acc += s_cur * fade / k ** tilt
            s_prev, s_cur = s_cur, c2 * s_cur - s_prev  # sin(k*th) por recurrencia
            k += 1
        out[i] = acc
    return out


# ------------------------------------------------------------------- filtros
def _coefs(kind, f, q):
    """Biquad RBJ: 'lp', 'hp' o 'bp' (ganancia de pico 0 dB)."""
    f = min(max(f, 10.0), SR * 0.45)
    w0 = TAU * f / SR
    cw, alpha = math.cos(w0), math.sin(w0) / (2 * q)
    if kind == 'lp':
        b0, b1, b2 = (1 - cw) / 2, 1 - cw, (1 - cw) / 2
    elif kind == 'hp':
        b0, b1, b2 = (1 + cw) / 2, -(1 + cw), (1 + cw) / 2
    else:
        b0, b1, b2 = alpha, 0.0, -alpha
    a0 = 1 + alpha
    return b0 / a0, b1 / a0, b2 / a0, -2 * cw / a0, (1 - alpha) / a0


def filt(buf, kind, freq, q=0.707, block=32):
    """Filtra con un biquad; freq puede ser una funcion t -> Hz (se actualiza por bloques)."""
    fn = freq if callable(freq) else (lambda _t: freq)
    out = [0.0] * len(buf)
    x1 = x2 = y1 = y2 = 0.0
    for start in range(0, len(buf), block):
        b0, b1, b2, a1, a2 = _coefs(kind, fn(start / SR), q)
        for i in range(start, min(start + block, len(buf))):
            x = buf[i]
            y = b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2
            x2, x1, y2, y1 = x1, x, y1, y
            out[i] = y
    return out


def crush(buf, hold=3, bits=7, mix=0.5):
    """Reduccion de frecuencia de muestreo (sample & hold) y de bits, mezclada con la senal."""
    peak = max(abs(v) for v in buf) or 1.0
    q = 2 ** (bits - 1)
    out, held = [], 0.0
    for i, v in enumerate(buf):
        if i % hold == 0:
            held = round(v / peak * q) / q * peak
        out.append(v * (1 - mix) + held * mix)
    return out


def echo(buf, delay, gains, tail):
    """Eco simple: repeticiones a multiplos de `delay` con las ganancias dadas."""
    out = buf + [0.0] * ns(tail)
    d = ns(delay)
    for n, g in enumerate(gains, 1):
        for i in range(len(buf)):
            j = i + n * d
            if j < len(out):
                out[j] += buf[i] * g
    return out


def finish(buf, peak_db, fade_in=0.003, fade_out=0.02):
    """Quita DC, aplica fundidos (coseno) y normaliza al pico pedido en dBFS."""
    out, x1, y1 = [], 0.0, 0.0
    for x in buf:  # bloqueador de DC (paso alto de un polo, ~10 Hz)
        y1 = x - x1 + 0.99857 * y1
        x1 = x
        out.append(y1)
    fi, fo, n = ns(fade_in), ns(fade_out), len(out)
    for i in range(fi):
        out[i] *= 0.5 - 0.5 * math.cos(math.pi * i / fi)
    for i in range(fo):
        out[n - 1 - i] *= 0.5 - 0.5 * math.cos(math.pi * i / fo)
    gain = 10 ** (peak_db / 20) / max(abs(v) for v in out)
    return [v * gain for v in out]


# ------------------------------------------------------------------- sonidos
def meow_voice(sec, pitch_points, crush_mix=0.45):
    """Maullido robotico: sierra aditiva con vibrato -> formantes 'ii' -> 'ou'
    -> filtro de 'labios' (m... w) -> envolvente -> bit-crush suave."""
    def f0(t):
        vib = 1 + 0.012 * smoothstep(0.06, 0.2, t) * math.sin(TAU * 5.6 * t)
        return curve(pitch_points, t, log=True) * vib

    src = additive_saw(f0, sec)
    formants = (  # (trayectoria Hz sobre u = t/sec, Q, ganancia)
        ([(0, 300), (0.35, 820), (1, 480)], 2.8, 1.0),
        ([(0, 2300), (0.35, 1650), (1, 850)], 4.5, 0.75),
        ([(0, 3000), (0.35, 2700), (1, 2400)], 6.0, 0.35),
    )
    voiced = [0.12 * v for v in src]  # un poco de senal directa para dar cuerpo
    for points, q, gain in formants:
        band = filt(src, 'bp', lambda t, p=points: curve(p, t / sec, log=True), q)
        for i, v in enumerate(band):
            voiced[i] += gain * v
    lips = [(0, 600), (0.06, 6500), (sec - 0.18, 6500), (sec, 1400)]
    voiced = filt(voiced, 'lp', lambda t: curve(lips, t, log=True))
    amp = [(0, 0.0), (0.05, 0.75), (0.16, 1.0), (sec * 0.75, 0.72), (sec, 0.0)]
    voiced = envelope(voiced, lambda t: curve(amp, t))
    crushed = crush(voiced, hold=3, bits=7, mix=crush_mix)
    return filt(filt(crushed, 'lp', 8000), 'lp', 8000)  # limpia las imagenes del sample & hold


def meow():
    # 480 -> 760 Hz en 0.15 s y luego baja (~550 Hz a 0.42 s) hasta 380 Hz
    return finish(meow_voice(0.7, [(0, 480), (0.15, 760), (0.7, 380)]), -4, 0.004, 0.03)


def tap():
    sec = 0.045
    body = osc('sine', lambda t: 1900 + 900 * math.exp(-t / 0.012), sec)
    edge = filt(osc('square', lambda t: 1900 + 900 * math.exp(-t / 0.012), sec), 'lp', 7000)
    out = [b + 0.07 * e for b, e in zip(body, edge)]
    out = envelope(out, lambda t: (1 - math.exp(-t / 0.0006)) * math.exp(-t / 0.010))
    mix_into(out, filt(noise(0.002), 'hp', 3500), 0, 0.25)  # micro-click de ataque
    return finish(out, -10, 0.0005, 0.006)


def bell(freq, sec, tau, partials=((1.0, 1.0), (2.0, 0.25), (2.76, 0.12))):
    out = zeros(sec)
    for ratio, amp in partials:
        mix_into(out, osc('sine', freq * ratio, sec), 0, amp)
    return envelope(out, pluck(0.004, tau, sec, release=0.03))


def boot():
    sec = 1.4
    out = zeros(sec)

    # 1) Barrido de sierras desafinadas + sub, por un paso bajo resonante que se abre
    def sweep_f(t):
        return 55 * 8 ** min(1.0, (t / 0.9) ** 1.3)  # 55 Hz -> 440 Hz
    s1, s2 = osc('saw', sweep_f, 1.05), osc('saw', lambda t: sweep_f(t) * 1.007, 1.05, 0.3)
    sub = osc('sine', lambda t: sweep_f(t) / 2, 1.05)
    sweep = [a + b + 0.6 * c for a, b, c in zip(s1, s2, sub)]
    sweep = filt(sweep, 'lp', lambda t: 180 * (6000 / 180) ** min(1.0, t / 0.9), q=5)
    sweep = envelope(sweep, lambda t: smoothstep(0, 0.35, t) * (1 - smoothstep(0.68, 1.0, t)))
    mix_into(out, sweep, 0, 0.34)

    # 2) Capa FM metalica que sube con el barrido
    fm, ph_c, ph_m = [], 0.0, 0.0
    for i in range(ns(1.0)):
        t = i / SR
        fc = sweep_f(t) * 2
        ph_m += fc * 1.5 / SR
        ph_c += fc / SR
        fm.append(math.sin(TAU * ph_c + 2.5 * smoothstep(0, 0.9, t) * math.sin(TAU * ph_m)))
    fm = envelope(fm, lambda t: 0.5 * smoothstep(0.2, 0.7, t) * (1 - smoothstep(0.75, 1.0, t)))
    mix_into(out, fm, 0, 0.18)

    # 3) Arpegio rapido La mayor (A5 C#6 E6 A6) mientras el barrido se apaga
    for n, freq in enumerate((880.0, 1108.73, 1318.51, 1760.0)):
        note = [a + 0.35 * b for a, b in zip(osc('sine', freq, 0.2), osc('square', freq, 0.2))]
        note = envelope(filt(note, 'lp', 5000), pluck(0.002, 0.07, 0.2))
        mix_into(out, note, 0.70 + 0.065 * n, 0.6)

    # 4) Brillo de ruido agudo con tremolo
    shimmer = filt(filt(noise(1.2), 'hp', 6000), 'lp', 12000)
    shimmer = envelope(shimmer, lambda t: smoothstep(0.15, 0.9, t) * (1 - smoothstep(0.95, 1.2, t))
                       * (0.6 + 0.4 * math.sin(TAU * 24 * t)))
    mix_into(out, shimmer, 0, 0.1)

    # 5) Chirp final brillante con un eco corto
    chirp = osc('sine', lambda t: 2000 * 3 ** min(1.0, t / 0.06), 0.14)  # 2 -> 6 kHz
    chirp = envelope(chirp, pluck(0.002, 0.035, 0.14))
    mix_into(out, echo(chirp, 0.07, (0.3, 0.12), 0.16), 1.04, 0.45)
    return finish(out, -4, 0.004, 0.05)


def glitch():
    sec = 0.35
    fall = osc('square', lambda t: 520 * (110 / 520) ** (t / sec), sec)  # 520 -> 110 Hz
    gates = ((0.000, 0.028), (0.040, 0.066), (0.074, 0.120), (0.150, 0.168),
             (0.182, 0.214), (0.236, 0.330))

    def gate(t):  # tartamudeo con rampas de 1.5 ms
        return max(smoothstep(a, a + 0.0015, t) * (1 - smoothstep(b - 0.0015, b, t)) for a, b in gates)
    out = envelope(fall, gate)

    # Rafagas de ruido sample & hold (valores aleatorios sostenidos N muestras)
    for a, b in ((0.026, 0.046), (0.118, 0.152), (0.210, 0.240)):
        burst, held, left = [], 0.0, 0
        for _ in range(ns(b - a)):
            if left <= 0:
                held, left = rng.uniform(-1, 1), rng.randint(12, 90)
            burst.append(held)
            left -= 1
        burst = envelope(burst, lambda t, d=b - a: smoothstep(0, 0.002, t) * (1 - smoothstep(d - 0.002, d, t)))
        mix_into(out, burst, a, 0.6)
    out = filt(crush(out, hold=2, bits=5, mix=0.6), 'lp', 7000)
    return finish(out, -8, 0.002, 0.02)


def success():
    sec = 0.35
    out = zeros(sec)

    def note(freq, length, tau):
        tone = [a + 0.12 * b for a, b in zip(osc('sine', freq, length),
                                             filt(osc('square', freq, length), 'lp', 6000))]
        return envelope(tone, pluck(0.003, tau, length))

    mix_into(out, note(1318.51, 0.14, 0.06), 0.0)    # E6
    mix_into(out, note(1975.53, 0.265, 0.09), 0.085)  # B6
    out = echo(out, 0.07, (0.28, 0.12), 0.0)[:ns(sec)]
    return finish(out, -8, 0.002, 0.025)


def notify():
    sec = 0.9
    out = zeros(sec)
    mix_into(out, meow_voice(0.42, [(0, 480), (0.09, 760), (0.42, 400)]), 0.0)
    peak = max(abs(v) for v in out)
    mix_into(out, bell(1046.5, 0.44, 0.16), 0.46, 0.45 * peak)  # C6
    mix_into(out, bell(1568.0, 0.32, 0.14), 0.58, 0.40 * peak)  # G6
    return finish(out, -3, 0.004, 0.06)


# ---------------------------------------------------------------------- main
def write_wav(path, buf):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    ints = [int(round(max(-1.0, min(1.0, v)) * 32767)) for v in buf]
    with wave.open(path, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(struct.pack('<%dh' % len(ints), *ints))


def write_mp3(path, buf):
    with tempfile.TemporaryDirectory() as tmp:
        wav = os.path.join(tmp, 'sfx.wav')
        write_wav(wav, buf)
        subprocess.run(['ffmpeg', '-y', '-loglevel', 'error', '-i', wav,
                        '-codec:a', 'libmp3lame', '-b:a', '96k', path], check=True)


def main():
    if shutil.which('ffmpeg') is None:
        raise SystemExit('hace falta ffmpeg (con libmp3lame) para los MP3')
    os.makedirs(SFX_DIR, exist_ok=True)
    sounds = (('boot', boot), ('tap', tap), ('meow', meow), ('glitch', glitch),
              ('success', success), ('notify', notify))
    for name, build in sounds:
        buf = build()
        if name == 'notify':
            for target in NOTIFY_COPIES:
                write_wav(target, buf)
        else:
            write_mp3(os.path.join(SFX_DIR, name + '.mp3'), buf)
        peak = max(abs(v) for v in buf)
        rms = math.sqrt(sum(v * v for v in buf) / len(buf))
        print('%-8s %.3f s  pico %6.2f dBFS  rms %6.2f dBFS  dc %+.5f' % (
            name, len(buf) / SR, 20 * math.log10(peak), 20 * math.log10(rms), sum(buf) / len(buf)))


if __name__ == '__main__':
    main()
