#!/usr/bin/env python3
"""Exporta los manuales de docs/ a PDF con Chrome sin interfaz.

    python3 tool/docs/build_manuals.py

El Markdown se renderiza con marked y los diagramas con mermaid, los dos desde
jsDelivr (hace falta red), así el PDF sale igual que la vista de GitHub. Deja
docs/manual-de-usuario.pdf y docs/manual-tecnico.pdf. La variable CHROME
permite usar otro binario.
"""

import base64
import json
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DOCS = ROOT / "docs"
FONTS = ROOT / "assets" / "fonts"
LOGO = ROOT / "tool" / "branding" / "out" / "splash_logo.png"
CHROME = os.environ.get(
    "CHROME", "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
)

MANUALS = [
    ("manual-de-usuario.md", "Manual de usuario"),
    ("manual-tecnico.md", "Manual técnico"),
]

AUTHOR = "Luis Isturiz"
CONTEXT = "Prueba técnica Mobile · Nextep Innovation"


def repo_url() -> str:
    """URL del repo en GitHub, para que los links relativos funcionen en el PDF."""
    url = subprocess.run(
        ["git", "remote", "get-url", "origin"],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=True,
    ).stdout.strip()
    url = re.sub(r"^git@github\.com:", "https://github.com/", url)
    return re.sub(r"\.git$", "", url)


def data_uri(path: Path, mime: str) -> str:
    return f"data:{mime};base64,{base64.b64encode(path.read_bytes()).decode()}"


def font_faces() -> str:
    # Embebidas: Chrome no carga fuentes locales desde una página file://.
    faces = [
        ("Chakra Petch", "ChakraPetch-Regular.ttf", "400"),
        ("Chakra Petch", "ChakraPetch-Medium.ttf", "500"),
        ("Chakra Petch", "ChakraPetch-SemiBold.ttf", "600"),
        ("Chakra Petch", "ChakraPetch-Bold.ttf", "700"),
        ("Orbitron", "Orbitron-Variable.ttf", "400 900"),
        ("Share Tech Mono", "ShareTechMono-Regular.ttf", "400"),
    ]
    return "\n".join(
        f"@font-face {{ font-family: '{family}'; font-weight: {weight}; "
        f"src: url('{data_uri(FONTS / file, 'font/ttf')}'); }}"
        for family, file, weight in faces
    )


CSS = """
:root {
  --ink: #1b1830; --muted: #5d5a78; --line: #ddd8ee; --soft: #f4f2fb;
  --cyan: #007a8c; --magenta: #c2185b; --purple: #6a34c2;
}
@page {
  size: A4;
  margin: 20mm 18mm 22mm;
  @bottom-left {
    content: "NekoDex · __SUBTITLE__";
    font: 8pt 'Share Tech Mono', monospace; color: #8a86a8;
  }
  @bottom-right {
    content: counter(page) " / " counter(pages);
    font: 8pt 'Share Tech Mono', monospace; color: #8a86a8;
  }
}
@page :first {
  margin: 0;
  @bottom-left { content: none; }
  @bottom-right { content: none; }
}
* { box-sizing: border-box; }
html { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
body {
  margin: 0; color: var(--ink);
  font: 400 10.2pt/1.5 'Chakra Petch', 'Helvetica Neue', sans-serif;
}

/* Portada */
.cover {
  position: relative; width: 210mm; height: 297mm; overflow: hidden;
  break-after: page; color: #ecebfb; text-align: center;
  background:
    radial-gradient(ellipse 70% 45% at 50% 32%, rgba(179,136,255,.28), transparent 70%),
    radial-gradient(ellipse 60% 30% at 50% 100%, rgba(255,46,136,.22), transparent 70%),
    #07060f;
}
.cover .grid {
  position: absolute; left: -20%; right: -20%; bottom: 0; height: 36%;
  background:
    repeating-linear-gradient(0deg, rgba(107,63,217,.55) 0 1px, transparent 1px 34px),
    repeating-linear-gradient(90deg, rgba(107,63,217,.55) 0 1px, transparent 1px 58px);
  transform: perspective(260px) rotateX(58deg); transform-origin: bottom;
  -webkit-mask-image: linear-gradient(transparent, #000 60%);
          mask-image: linear-gradient(transparent, #000 60%);
}
.cover .logo { width: 88mm; margin-top: 42mm; }
.cover .brand {
  margin: 4mm 0 0; font: 900 34pt 'Orbitron', sans-serif; letter-spacing: 2pt;
  color: #fff; text-shadow: 0 0 8px rgba(0,240,255,.55), 0 0 18px rgba(255,46,136,.45);
}
.cover .tagline {
  margin: 3mm 0 0; font: 10pt 'Share Tech Mono', monospace; letter-spacing: 5pt;
  color: #00f0ff; text-transform: uppercase;
}
.cover .kind {
  display: inline-block; margin-top: 16mm; padding: 3mm 8mm;
  border: 1.2pt solid #ff2e88; font: 600 17pt 'Chakra Petch', sans-serif;
  letter-spacing: 1pt; color: #fff;
  clip-path: polygon(4mm 0, 100% 0, 100% calc(100% - 4mm), calc(100% - 4mm) 100%, 0 100%, 0 4mm);
}
.cover .meta { margin-top: 6mm; font: 10pt 'Share Tech Mono', monospace; color: #a7a3cc; }
.cover .foot {
  position: absolute; left: 0; right: 0; bottom: 16mm;
  font: 9.5pt 'Share Tech Mono', monospace; color: #cfcbea; line-height: 1.6;
}

/* Índice */
.toc { break-after: page; }
.toc h2 { margin-top: 0; }
.toc ol { list-style: none; padding: 0; margin: 0; columns: 1; }
.toc li { border-bottom: 1px dotted var(--line); padding: 2.2mm 0; font-size: 10.5pt; }
.toc a { color: var(--ink); text-decoration: none; }

/* Contenido */
h1, h2, h3, h4 { font-family: 'Chakra Petch', sans-serif; break-after: avoid; }
h2 {
  font-size: 15pt; font-weight: 700; color: var(--ink);
  margin: 9mm 0 3mm; padding-bottom: 1.6mm; border-bottom: 1.4pt solid var(--cyan);
}
h3 { font-size: 12pt; font-weight: 700; color: var(--purple); margin: 6mm 0 2mm; }
h4 { font-size: 10.5pt; font-weight: 700; margin: 4mm 0 1.5mm; }
p { margin: 0 0 2.6mm; }
ul, ol { margin: 0 0 3mm; padding-left: 6mm; }
li { margin: .8mm 0; }
a { color: var(--cyan); text-decoration: none; }
strong { font-weight: 700; }
code {
  font: 8.6pt 'Menlo', 'SF Mono', monospace; background: var(--soft);
  border: 1px solid var(--line); border-radius: 3px; padding: 0 1.2mm;
}
pre {
  background: var(--soft); border: 1px solid var(--line); border-left: 2.4pt solid var(--purple);
  border-radius: 4px; padding: 3mm 4mm; margin: 0 0 3.5mm;
  white-space: pre-wrap; word-break: break-word; break-inside: avoid;
}
pre code { background: none; border: 0; padding: 0; font-size: 8.4pt; line-height: 1.45; }
table {
  width: 100%; border-collapse: collapse; margin: 1mm 0 4mm; font-size: 9.2pt;
  line-height: 1.4;
}
thead { display: table-header-group; }
tr { break-inside: avoid; }
th {
  background: #efeafc; color: var(--ink); font-weight: 700; text-align: left;
}
th, td { border: 1px solid var(--line); padding: 1.6mm 2.2mm; vertical-align: top; }
tbody tr:nth-child(even) td { background: #faf9fe; }
p[align="center"] { text-align: center; break-inside: avoid; margin: 3mm 0 4mm; }
p[align="center"] img {
  margin: 0 2mm; border-radius: 3mm; border: 1px solid var(--line);
  box-shadow: 0 1mm 3mm rgba(27,24,48,.12); vertical-align: top;
  width: auto; max-height: 100mm;
}
/* Una sola captura de teléfono: a la derecha de su texto y en el mismo bloque,
   para que un salto de página no las separe. */
.figure-row { display: flex; gap: 7mm; align-items: flex-start; break-inside: avoid; }
.figure-row > .figure-text { flex: 1; min-width: 0; }
.figure-row > p[align="center"] { flex: 0 0 46mm; margin: 1mm 0 4mm; }
.figure-row > p[align="center"] img { width: 100%; max-height: none; margin: 0; }
img { max-width: 100%; }
.mermaid { text-align: center; margin: 2mm 0 5mm; break-inside: avoid; }
.mermaid svg { max-width: 100%; height: auto; }
.lead-meta { display: none; }
"""

HTML = """<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<title>NekoDex · __SUBTITLE__</title>
<style>__FONTS__</style>
<style>__CSS__</style>
</head>
<body>
<section class="cover">
  <div class="grid"></div>
  <img class="logo" src="__LOGO__" alt="">
  <h1 class="brand">NEKO//DEX</h1>
  <p class="tagline">Directorio felino</p>
  <p class="kind">__SUBTITLE__</p>
  <p class="meta">__VERSION__</p>
  <p class="foot">__CONTEXT__<br>__AUTHOR__</p>
</section>
<section class="toc"><h2>Contenido</h2><ol id="toc"></ol></section>
<main id="content"></main>
<script type="module">
import { marked } from 'https://cdn.jsdelivr.net/npm/marked@15/lib/marked.esm.js';
import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';

const markdown = __MARKDOWN__;
const repo = __REPO__;
const content = document.getElementById('content');
content.innerHTML = marked.parse(markdown);

// Los links relativos del Markdown apuntan a archivos del repo: en el PDF
// se llevan a GitHub.
for (const a of content.querySelectorAll('a[href]')) {
  const href = a.getAttribute('href');
  if (/^(https?:|mailto:|#)/.test(href)) continue;
  a.href = new URL(href, repo + '/blob/main/docs/').href;
}

// Una captura suelta va en fila con el texto que la sigue, hasta el próximo
// título.
for (const figure of content.querySelectorAll('p[align="center"]')) {
  const images = figure.querySelectorAll('img');
  if (images.length !== 1 || images[0].getAttribute('width') !== '240') continue;
  const row = document.createElement('div');
  row.className = 'figure-row';
  const text = document.createElement('div');
  text.className = 'figure-text';
  figure.replaceWith(row);
  while (row.nextSibling && !/^H[1-3]$/.test(row.nextSibling.nodeName)) {
    text.append(row.nextSibling);
  }
  row.append(text, figure);
}

// Índice con las secciones de segundo nivel.
const toc = document.getElementById('toc');
content.querySelectorAll('h2').forEach((h, i) => {
  h.id = 'sec-' + (i + 1);
  const li = document.createElement('li');
  li.innerHTML = `<a href="#${h.id}">${h.textContent}</a>`;
  toc.append(li);
});

// Diagramas.
for (const code of content.querySelectorAll('pre > code.language-mermaid')) {
  const div = document.createElement('div');
  div.className = 'mermaid';
  div.textContent = code.textContent;
  code.parentElement.replaceWith(div);
}
mermaid.initialize({
  startOnLoad: false,
  theme: 'base',
  themeVariables: {
    fontFamily: 'Chakra Petch, sans-serif',
    fontSize: '14px',
    primaryColor: '#f1eefb',
    primaryBorderColor: '#6a34c2',
    primaryTextColor: '#1b1830',
    lineColor: '#5d5a78',
    actorBkg: '#f1eefb',
    actorBorder: '#6a34c2',
    signalColor: '#1b1830',
    noteBkgColor: '#fff4d6',
  },
});
await mermaid.run({ querySelector: '.mermaid' });
document.body.dataset.ready = 'true';
</script>
</body>
</html>
"""


def split_header(markdown: str) -> tuple[str, str]:
    """Separa el título y la línea de versión (van en la portada) del cuerpo."""
    lines = markdown.splitlines()
    assert lines[0].startswith("# "), "el manual tiene que empezar con un título"
    version = ""
    body_start = 1
    for i, line in enumerate(lines[1:], start=1):
        if not line.strip():
            continue
        if line.startswith("**") and line.endswith("**"):
            version = line.strip("*")
            body_start = i + 1
        break
    return version, "\n".join(lines[body_start:]).lstrip()


def build(md_name: str, subtitle: str, repo: str) -> Path:
    source = DOCS / md_name
    version, body = split_header(source.read_text(encoding="utf-8"))
    html = (
        HTML.replace("__FONTS__", font_faces())
        .replace("__CSS__", CSS)
        .replace("__LOGO__", data_uri(LOGO, "image/png"))
        .replace("__SUBTITLE__", subtitle)
        .replace("__VERSION__", version)
        .replace("__CONTEXT__", CONTEXT)
        .replace("__AUTHOR__", AUTHOR)
        .replace("__REPO__", json.dumps(repo))
        .replace("__MARKDOWN__", json.dumps(body, ensure_ascii=False))
    )
    # Junto al Markdown para que las imágenes relativas se resuelvan igual.
    page = DOCS / f".{source.stem}.html"
    output = DOCS / f"{source.stem}.pdf"
    page.write_text(html, encoding="utf-8")
    try:
        subprocess.run(
            [
                CHROME,
                "--headless",
                "--disable-gpu",
                "--no-pdf-header-footer",
                "--virtual-time-budget=30000",
                f"--print-to-pdf={output}",
                page.as_uri(),
            ],
            check=True,
            capture_output=True,
        )
    finally:
        page.unlink(missing_ok=True)
    return output


def main() -> int:
    repo = repo_url()
    for md_name, subtitle in MANUALS:
        output = build(md_name, subtitle, repo)
        size = output.stat().st_size // 1024
        print(f"✓ {output.relative_to(ROOT)} ({size} KB)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
