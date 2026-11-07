#!/usr/bin/env python3
"""Import the personal songbooks in ``song-sources/`` into the app catalogue.

The three PDFs use different layouts:

* ``impaginato_canti.pdf`` - two columns, grouped by moment of the Mass;
* ``SNPG-...pdf`` - one column, one song per page, author under the title;
* ``Canti-SANTUARIO.pdf`` - two columns, number and title on separate nodes.

Poppler's XML output keeps the coordinates and font attributes we need to
rebuild the reading order.  The generated JSON is loaded by the Flutter app at
startup (see ``lib/data/personal_songs_service.dart``).

Usage:
    python3 tool/import_songbook.py            # regenerate the asset
    python3 tool/import_songbook.py --report   # print a review report
"""

from __future__ import annotations

import argparse
import difflib
import json
import re
import subprocess
import unicodedata
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCES = ROOT / "song-sources"
WORK = Path("/tmp/opencode/song-extract")
OUT = ROOT / "assets" / "data" / "personal_songs.json"

SOURCES_META = {
    "impaginato_canti": {
        "label": "Canti per la Santa Messa",
        "two_columns": True,
        "threshold": 19.0,
    },
    "SNPG-CEI_Libretto-canti-pagine-singole": {
        "label": "Lodate e benedite - Canti per la liturgia e per la preghiera",
        "two_columns": False,
        "threshold": 17.0,
    },
    "Canti-SANTUARIO": {
        "label": "Canti - Santuario della Madonna delle Grazie",
        "two_columns": True,
        "threshold": 15.0,
    },
}

# Section headings in impaginato -> (celebration, extra tags).
HEADINGS: dict[str, tuple[str, ...]] = {
    "Ingresso": ("messa", "ingresso"),
    "Signore Pietà": ("messa", "atto-penitenziale"),
    "Gloria": ("messa", "gloria"),
    "Acclamazioni al vangelo": ("messa", "versetto-alleluia"),
    "Offertorio": ("messa", "offertorio"),
    "Santo": ("messa", "santo"),
    "Anamnesi": ("messa", "ringraziamento"),
    "Padre Nostro": ("messa",),
    "Agnello di Dio": ("messa", "comunione"),
    "Pace": ("messa", "pace"),
    "Comunione": ("messa", "comunione"),
    "Conclusione": ("messa", "congedo"),
    "Avvento": ("messa", "avvento"),
    "Natale": ("messa", "natale"),
    "Quaresima": ("messa", "quaresima"),
    "Pasqua": ("messa", "pasqua"),
    "Pentecoste": ("messa", "pentecoste"),
    "Eucaristici e di Adorazione": (
        "messa",
        "eucaristia",
        "adorazione-momento",
    ),
    "Mariani": ("messa", "mariano"),
    "Defunti": ("messa", "defunti"),
    "Canti Tradizionali": ("messa", "tradizionale"),
}

KEEP_IN_TITLE = {"VERBUM PANIS", "GREGORIANO", "ZAIRE", "LECCE"}

STOP_MARKERS = {"Indice", "INDICE TEMATICO", "Indice alfabetico"}

SKIP_EXACT = {
    "Canti per la Santa Messa",
    "SANTUARIO DELLA MADONNA DELLE GRAZIE",
    "CANTI PER LA LITURGIA",
    "lodate e benedite",
    "Canti per la liturgia e per la preghiera",
    "Indice",
}

# Common apostrophe-for-accent spellings found in the PDFs.
ACCENT_FIXES = {
    "PIETA": "PIETÀ",
    "GESU": "GESÙ",
    "TRINITA": "TRINITÀ",
    "ANDRO": "ANDRÒ",
    "PERCHE": "PERCHÉ",
    "COSI": "COSÌ",
    "PIU": "PIÙ",
    "VERRA": "VERRÀ",
    "SARA": "SARÀ",
    "UNITA": "UNITÀ",
    "CARITA": "CARITÀ",
    "FELICITA": "FELICITÀ",
    "UMILTA": "UMILTÀ",
    "SEMPLICITA": "SEMPLICITÀ",
    "BONTA": "BONTÀ",
    "LIBERTA": "LIBERTÀ",
    "E": "È",
    "LA": "LÀ",
    "LI": "LÌ",
    "NE": "NÉ",
    "SI": "SÌ",
}

TITLE_FIXES = {
    "NOME DOLCISSMO": "NOME DOLCISSIMO",
    "ALLELIUA": "ALLELUIA",
    "EVENU SHALOM ALEJEM": "EVENU SHALOM ALEJEM",
}

SMALL_WORDS = {
    "a",
    "ad",
    "al",
    "alla",
    "alle",
    "allo",
    "agli",
    "ai",
    "con",
    "coi",
    "da",
    "dal",
    "dalla",
    "dalle",
    "dallo",
    "dagli",
    "dai",
    "de",
    "dei",
    "del",
    "della",
    "delle",
    "dello",
    "degli",
    "di",
    "e",
    "ed",
    "fra",
    "il",
    "in",
    "la",
    "le",
    "lo",
    "i",
    "gli",
    "ma",
    "nel",
    "nella",
    "nelle",
    "nello",
    "negli",
    "nei",
    "o",
    "od",
    "per",
    "più",
    "su",
    "sul",
    "sulla",
    "sulle",
    "sullo",
    "sugli",
    "sui",
    "tra",
    "un",
    "una",
    "uno",
    "che",
    "chi",
    "ci",
    "come",
    "cui",
    "dove",
    "è",
    "li",
    "le",
    "lo",
    "mi",
    "miei",
    "mia",
    "mio",
    "ne",
    "nei",
    "non",
    "nostra",
    "nostri",
    "nostro",
    "quale",
    "quando",
    "quel",
    "quella",
    "quelle",
    "quelli",
    "quello",
    "questa",
    "queste",
    "questi",
    "questo",
    "si",
    "sua",
    "sue",
    "sugli",
    "sui",
    "suo",
    "suoi",
    "ti",
    "tuo",
    "tuoi",
    "tua",
    "tue",
    "vi",
    "vostra",
    "vostre",
    "vostri",
    "vostro",
}

KEYWORD_TAGS: list[tuple[tuple[str, ...], tuple[str, ...]]] = [
    (("maria", "madonna", "vergine", "ave ", "salve regina", "madre"), ("mariano",)),
    (("spirito", "pentecoste"), ("spirito-santo",)),
    (("pane", "vino", "eucarist", "corpus", "cibo", "mensa", "altare", "comunione"), ("eucaristia",)),
    (("pace", "shalom"), ("pace",)),
    (("gioia", "esult", "festa", "alleluia"), ("gioia",)),
    (("luce", "splend", "aurora"), ("luce",)),
    (("croce", "passione", "calvario"), ("croce",)),
    (("pietà", "perdon", "misericord", "peniten"), ("penitenza",)),
    (("speranza", "attend", "avvento", "emmanuel", "maranath"), ("speranza",)),
    (("confido", "affid", "pastore", "rifugio"), ("fiducia",)),
    (("fratell", "insieme", "uniti", "popolo", "comunità", "comunita"), ("comunita",)),
    (("avvento", "emmanuel", "maranath", "vieni signore"), ("avvento",)),
    (("natale", "bambino", "betlemme", "presepe"), ("natale",)),
    (("quaresima", "digiuno", "conversione"), ("quaresima",)),
    (("pasqua", "risort", "risurrez"), ("pasqua",)),
    (("defunt", "eterno riposo", "memoria"), ("defunti",)),
]

MOMENT_HINTS = [
    (("agnello", "pane di vita", "cibo", "comunione"), "comunione"),
    (("gloria",), "gloria"),
    (("santo", "osanna"), "santo"),
    (("alleluia",), "versetto-alleluia"),
    (("offert", "frutto della nostra terra", "presentiamo"), "offertorio"),
    (("salmo", "pastore", "signore è mio"), "salmo"),
    (("magnificat", "anima mia", "ringrazi"), "ringraziamento"),
    (("eccomi", "venite", "cantate al signore", "alzo gli occhi"), "ingresso"),
    (("andate", "congedo", "finale"), "congedo"),
    (("adorazione", "adoriamo", "ss. sacramento", "santissimo"), "adorazione-momento"),
]


@dataclass
class Element:
    page: int
    x: float
    y: float
    w: float
    text: str
    size: float
    bold: bool
    italic: bool


@dataclass
class Line:
    page: int
    x: float
    y: float
    w: float
    text: str
    size: float
    bold: bool
    italic: bool


@dataclass
class Candidate:
    source: str
    page: int
    section: str | None
    title: str
    author: str | None
    sections: list[dict]
    tags: list[str] = field(default_factory=list)
    origins: list[tuple[str, int]] = field(default_factory=list)

    @property
    def text_length(self) -> int:
        return sum(len(section["text"]) for section in self.sections)


def text_of(element: ET.Element) -> str:
    return re.sub(r"\s+", " ", "".join(element.itertext())).strip()


def ensure_xml(name: str) -> Path:
    WORK.mkdir(parents=True, exist_ok=True)
    target = WORK / f"{name}.xml"
    if target.exists():
        return target
    pdf = SOURCES / f"{name}.pdf"
    if not pdf.exists():
        raise SystemExit(f"missing source PDF: {pdf}")
    subprocess.run(
        [
            "pdftohtml",
            "-xml",
            "-hidden",
            "-enc",
            "UTF-8",
            str(pdf),
            str(target),
        ],
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return target


def load(name: str) -> tuple[list[Element], dict[int, float]]:
    path = ensure_xml(name)
    root = ET.parse(path).getroot()
    fonts: dict[str, ET.Element] = {}
    widths: dict[int, float] = {}
    for page in root.findall("page"):
        pno = int(page.get("number"))
        widths[pno] = float(page.get("width", 595))
        for font in page.findall("fontspec"):
            fonts[font.get("id")] = font

    elements: list[Element] = []
    for page in root.findall("page"):
        pno = int(page.get("number"))
        for text in page.findall("text"):
            content = text_of(text)
            if not content:
                continue
            font = fonts.get(text.get("font"))
            elements.append(
                Element(
                    page=pno,
                    x=float(text.get("left", 0)),
                    y=float(text.get("top", 0)),
                    w=float(text.get("width", 0)),
                    text=content,
                    size=float(font.get("size", 0)) if font is not None else 0.0,
                    bold=text.find("b") is not None,
                    italic=text.find("i") is not None,
                )
            )

    # Join nodes that sit on the same baseline inside the same column: title
    # numbers split from their text, or a word split into two nodes.
    grouped: list[Element] = []
    for element in sorted(elements, key=lambda e: (e.page, e.y, e.x)):
        if grouped:
            previous = grouped[-1]
            gap = element.x - (previous.x + previous.w)
            mid = widths.get(element.page, 595) / 2
            same_column = (previous.x < mid) == (element.x < mid)
            if (
                previous.page == element.page
                and abs(previous.y - element.y) <= 3
                and -1 <= gap <= 60
                and same_column
            ):
                previous.text = f"{previous.text} {element.text}".strip()
                previous.w = max(previous.w, element.x + element.w - previous.x)
                previous.bold = previous.bold or element.bold
                previous.italic = previous.italic or element.italic
                previous.size = max(previous.size, element.size)
                continue
        grouped.append(
            Element(
                page=element.page,
                x=element.x,
                y=element.y,
                w=element.w,
                text=element.text,
                size=element.size,
                bold=element.bold,
                italic=element.italic,
            )
        )
    return grouped, widths


def is_noise(text: str) -> bool:
    if text in SKIP_EXACT:
        return True
    if re.fullmatch(r"\d{1,4}", text):
        return True
    if text in {"“", "”"}:
        return True
    return False


def looks_like_title(text: str) -> bool:
    """Songbook titles are set in capitals; lyrics and choruses are not."""
    letters = [c for c in text if c.isalpha()]
    if not letters:
        return False
    return sum(1 for c in letters if c.isupper()) / len(letters) >= 0.75


def title_match(line: Line, threshold: float) -> bool:
    if not (
        line.bold
        and line.size >= threshold
        and re.match(r"^\d{1,3}\.\s*[A-ZÀ-Ù]", line.text) is not None
    ):
        return False
    bare = re.sub(r"\([^)]*\)", "", re.sub(r"^\d{1,3}\.\s*", "", line.text))
    return looks_like_title(bare)


def ordered_lines(name: str, elements: list[Element], widths: dict[int, float],
                  threshold: float, two_columns: bool) -> list[Line]:
    pages = sorted({e.page for e in elements})
    # The Mass songbook ends with several index pages.  Drop everything from
    # the first page that is mostly dot-leader entries.
    if name == "impaginato_canti":
        by_page: dict[int, list[Element]] = {}
        for element in elements:
            by_page.setdefault(element.page, []).append(element)
        index_pages = [
            page
            for page, items in by_page.items()
            if any(item.text in STOP_MARKERS for item in items)
            or sum(
                1
                for item in items
                if re.search(r"\.{3,}\s*\d+\s*$", item.text)
            )
            >= 3
        ]
        if index_pages:
            cutoff = min(index_pages)
            elements = [element for element in elements if element.page < cutoff]
            pages = [page for page in pages if page < cutoff]

    ordered: list[Line] = []
    for page in pages:
        lines = [
            Line(
                page=e.page,
                x=e.x,
                y=e.y,
                w=e.w,
                text=e.text,
                size=e.size,
                bold=e.bold,
                italic=e.italic,
            )
            for e in elements
            if e.page == page and not is_noise(e.text)
        ]
        if not two_columns:
            ordered.extend(sorted(lines, key=lambda line: line.y))
            continue

        mid = widths.get(page, 595) / 2
        body = [line for line in lines if line.size < threshold and line.text not in HEADINGS]
        body_min = min((line.y for line in body), default=0)
        prelude = [
            line
            for line in lines
            if line.text in HEADINGS
            and line.y < body_min - 2
            and not title_match(line, threshold)
        ]
        rest = [line for line in lines if line not in prelude]
        left = sorted([line for line in rest if line.x + line.w / 2 < mid], key=lambda line: line.y)
        right = sorted([line for line in rest if line.x + line.w / 2 >= mid], key=lambda line: line.y)
        ordered.extend(prelude)
        ordered.extend(left)
        ordered.extend(right)
    return ordered


def parse_source(name: str) -> list[Candidate]:
    meta = SOURCES_META[name]
    elements, widths = load(name)
    lines = ordered_lines(
        name,
        elements,
        widths,
        threshold=meta["threshold"],
        two_columns=meta["two_columns"],
    )

    songs: list[Candidate] = []
    current: dict | None = None
    current_section: str | None = None
    pending_title = False
    title_x = 0.0
    title_y = 0.0

    for line in lines:
        text = line.text
        if name == "impaginato_canti" and text in STOP_MARKERS:
            break
        if text in HEADINGS:
            current_section = text if name == "impaginato_canti" else None
            pending_title = False
            continue
        if line.size >= meta["threshold"] + 2 and not title_match(line, meta["threshold"]):
            pending_title = False
            continue
        if title_match(line, meta["threshold"]):
            if current is not None and current["lines"]:
                songs.append(_candidate(current))
            current = {
                "source": name,
                "page": line.page,
                "title": re.sub(r"^\d{1,3}\.\s*", "", text).strip(),
                "author": None,
                "section": current_section if name == "impaginato_canti" else None,
                "lines": [],
            }
            pending_title = True
            title_x = line.x
            title_y = line.y
            continue
        if current is None:
            continue
        if (
            pending_title
            and line.bold
            and line.size >= meta["threshold"] - 0.5
            and line.page == current["page"]
            and abs(line.x - title_x) < 80
            and line.y - title_y <= 30
            and looks_like_title(text)
        ):
            current["title"] = f"{current['title']} {text}".strip()
            title_y = line.y
            continue
        pending_title = False
        # SNPG prints the author credit right under the title, e.g. "(RnS)".
        if (
            current.get("author") is None
            and not current["lines"]
            and re.fullmatch(r"\([^)]{1,80}\)", text)
        ):
            current["author"] = text.strip("()").strip()
            continue
        # Alternate settings listed under one heading are printed as
        # unnumbered capitals, e.g. "61 AGNELLO DI DIO (S.G.F.)": they are
        # sibling titles, not lyrics.
        if line.bold and line.size >= meta["threshold"] - 0.5 and looks_like_title(text):
            continue
        current["lines"].append(
            {
                "text": text,
                "y": line.y,
                "page": line.page,
                "bold": line.bold,
                "italic": line.italic,
                "size": line.size,
                "x": line.x,
                "w": line.w,
                "page_width": widths.get(line.page, 595),
            }
        )
    if current is not None and current["lines"]:
        songs.append(_candidate(current))
    return songs


def _candidate(raw: dict) -> Candidate:
    title, credit = split_author(clean_title(raw["title"]))
    author = credit or raw.get("author")
    sections = build_sections(
        raw.pop("lines"),
        raw["source"],
        title=title,
    )
    candidate = Candidate(
        source=raw["source"],
        page=raw["page"],
        section=raw["section"],
        title=title,
        author=author,
        sections=sections,
        origins=[(raw["source"], raw["page"])],
    )
    candidate.tags = infer_tags(candidate)
    return candidate


def split_author(title: str) -> tuple[str, str | None]:
    credits: list[str] = []

    def replace(match: re.Match[str]) -> str:
        content = match.group(1).strip()
        if content.upper() in KEEP_IN_TITLE:
            return match.group(0)
        credits.append(content)
        return ""

    cleaned = re.sub(r"\(([^)]*)\)", replace, title)
    cleaned = re.sub(r"\s+", " ", cleaned).strip(" ,.-")
    return cleaned, "; ".join(credits) if credits else None


def clean_title(title: str) -> str:
    title = re.sub(r"\s+", " ", title).strip(" .-")
    title = re.sub(r"\s*([’'])\s*", r"\1", title)
    title = re.sub(r"([A-ZÀ-Ù])-\s+([A-ZÀ-Ù])", r"\1\2", title)
    for wrong, right in TITLE_FIXES.items():
        title = title.replace(wrong, right)
    return fix_accents(title)


def _accent_word(word: str) -> str | None:
    plain = unicodedata.normalize("NFKD", word).encode("ascii", "ignore").decode()
    return ACCENT_FIXES.get(plain.upper())


def fix_accents(text: str) -> str:
    """Repair the PDF habit of writing final accents as apostrophes.

    The typography is inconsistent: ``GESU’``, ``ANDRO’A``, ``E’NATALE`` and
    ``L’UMANITA’`` all occur.  We only rewrite a word when it is in the known
    list; other apostrophes are true elisions (``L’ORA``, ``D’AMORE``).
    """
    text = text.replace("'", "’")

    def attached(match: re.Match[str]) -> str:
        fixed = _accent_word(match.group(1))
        if fixed is None:
            return match.group(0)
        return f"{fixed} "

    def final(match: re.Match[str]) -> str:
        word = match.group(1)
        fixed = _accent_word(word)
        if fixed is None:
            # Generic final accent: DI’ -> DÌ, UMANITA’ -> UMANITÀ.
            plain = (
                unicodedata.normalize("NFKD", word)
                .encode("ascii", "ignore")
                .decode()
                .upper()
            )
            if len(plain) > 1 and plain[-1] in "AEIOU":
                vowel = {"A": "À", "E": "È", "I": "Ì", "O": "Ò", "U": "Ù"}[plain[-1]]
                return plain[:-1] + vowel
            return match.group(0)
        return fixed

    # Accented word glued to the next word: ANDRO’A, GESU’SALVATORE, E’NATALE.
    text = re.sub(r"\b([A-ZÀ-Ù]+)[’'](?=[A-ZÀ-Ù])", attached, text)
    # Accented word at the end of a word: PIETA’, UMANITA’, ADORERO’.
    text = re.sub(r"\b([A-ZÀ-Ù]+)[’'](?=\s|$|[,.;:!?])", final, text)
    # "È" glued to the following word (E’NATALE after the pass above).
    text = re.sub(r"\bÈ(?=[A-ZÀ-Ù])", "È ", text)
    return text


def clean_lyric_line(text: str) -> str:
    text = re.sub(r"\s+", " ", text).strip()
    text = re.sub(r"\s*([’'])\s*", r"\1", text)
    text = re.sub(r"\bRit\.?\s*$", "", text).strip()
    text = re.sub(r"\bRit\.?\s+", "", text)
    text = re.sub(r"\s*\((?:2v\.?|3v\.?|4v\.?|bis)\)\s*$", "", text, flags=re.I)
    text = re.sub(r"^\d{1,2}\.\s*", "", text)
    return text.strip(" ,;-")


def join_lines(lines: list[dict]) -> list[str]:
    """Join physical PDF lines into lyric lines.

    Hyphenated words are easy.  The PDFs also break a word without a hyphen
    when it reaches the column margin (``Seba`` / ``ste``, ``giu`` /
    ``stizia``); detect those using the line geometry.
    """
    # Right/left edge of each column, used to recognise a broken word.
    edges: dict[tuple[int, int], tuple[float, float]] = {}
    for item in lines:
        mid = item.get("page_width", 595) / 2
        column = 0 if item["x"] < mid else 1
        right = item["x"] + item["w"]
        key = (item["page"], column)
        min_x, max_right = edges.get(key, (item["x"], right))
        edges[key] = (min(min_x, item["x"]), max(max_right, right))

    out: list[str] = []
    previous: dict | None = None
    for item in lines:
        text = clean_lyric_line(item["text"])
        if not text:
            continue
        if out and previous is not None:
            mid = item.get("page_width", 595) / 2
            column = 0 if item["x"] < mid else 1
            min_x, max_right = edges[(item["page"], column)]
            at_margin = (
                previous.get("page") == item["page"]
                and previous["x"] + previous["w"] >= max_right - 22
                and item["x"] <= min_x + 22
            )
            short_fragment = (
                len(text) <= 7
                and " " not in text
                and re.fullmatch(r"[a-zàèéìòù]+", text) is not None
            )
            if re.search(r"[A-Za-zÀ-ù]-$", out[-1]) and re.match(
                r"^[A-Za-zÀ-ù]", text
            ):
                out[-1] = out[-1][:-1] + text
                previous = item
                continue
            if at_margin and short_fragment and re.search(
                r"[A-Za-zÀ-ù]$", out[-1]
            ):
                out[-1] = out[-1] + text
                previous = item
                continue
        out.append(text)
        previous = item
    return out


def build_sections(lines: list[dict], source: str, title: str) -> list[dict]:
    clean = [line for line in lines if not is_noise(line["text"])]
    if source.startswith("SNPG") and clean and re.fullmatch(r"\([^)]*\)", clean[0]["text"].strip()):
        clean = clean[1:]

    blocks: list[list[dict]] = []
    block: list[dict] = []
    last = None
    for item in clean:
        new_block = last is not None and (
            item["page"] != last["page"]
            or item["y"] - last["y"] > 27
            or item["y"] < last["y"] - 3
        )
        if new_block:
            if block:
                blocks.append(block)
                block = []
        block.append(item)
        last = item
    if block:
        blocks.append(block)

    result: list[dict] = []
    for index, block in enumerate(blocks):
        texts = join_lines(block)
        if not texts:
            continue
        chorus = False
        if source.startswith("SNPG"):
            chorus = all(item["italic"] for item in block)
        elif source == "Canti-SANTUARIO":
            chorus = all(item["bold"] for item in block)
        elif source == "impaginato_canti":
            # Many songs print the refrain first, marked by "Rit." on each
            # verse, others only by layout. A short first block is a good
            # signal, but avoid turning a lone verse into a chorus.
            first = "\n".join(texts)
            chorus = index == 0 and (
                "Rit" in "\n".join(item["text"] for item in block)
                or (len(texts) <= 3 and len(first) < 180)
            )
        result.append(
            {
                "kind": "chorus" if chorus else "verse",
                "text": "\n".join(texts),
            }
        )
    return result


def infer_tags(candidate: Candidate) -> list[str]:
    tags: set[str] = set()
    if candidate.section and candidate.section in HEADINGS:
        tags.update(HEADINGS[candidate.section])
    elif candidate.source != "impaginato_canti":
        tags.add("messa")

    haystack = " ".join(
        [candidate.title, candidate.author or ""]
        + [section["text"] for section in candidate.sections[:2]]
    ).lower()
    for keys, tag_ids in KEYWORD_TAGS:
        if any(key in haystack for key in keys):
            tags.update(tag_ids)
    if candidate.source != "impaginato_canti":
        for keys, moment in MOMENT_HINTS:
            if any(key in haystack for key in keys):
                tags.add(moment)
                break
    return sorted(tags)


def titlecase_title(title: str) -> str:
    # Normalise apostrophes first; keep the apostrophe attached.
    title = re.sub(r"\s*([’'])\s*", r"\1", title)
    title = fix_accents(title)
    words = title.split(" ")
    result: list[str] = []
    for index, word in enumerate(words):
        if not word:
            continue
        parts = re.split(r"([’'])", word)
        rendered: list[str] = []
        for part_index, part in enumerate(parts):
            if part in {"’", "'"}:
                rendered.append("’" if part in {"’", "'"} else part)
                continue
            lower = part.lower()
            if (
                0 < index < len(words) - 1
                and lower in SMALL_WORDS
                and part_index == 0
            ):
                rendered.append(lower)
                continue
            # Capitalise the first letter of every apostrophe segment,
            # except common elisions (dell'universo, com'è, ...).
            if part_index > 0 and lower not in {"antonio", "maria", "gesù", "cristo", "dio", "signore"}:
                rendered.append(lower)
            else:
                rendered.append(lower[:1].upper() + lower[1:])
        result.append("".join(rendered))
    if result:
        result[0] = result[0][:1].upper() + result[0][1:]
    return " ".join(result)


def slugify(title: str) -> str:
    value = unicodedata.normalize("NFKD", title).encode("ascii", "ignore").decode()
    value = value.lower()
    value = re.sub(r"[^a-z0-9]+", "-", value).strip("-")
    return value[:60]


def dedup_key(title: str) -> str:
    value = unicodedata.normalize("NFKD", title).encode("ascii", "ignore").decode()
    value = re.sub(r"\([^)]*\)", "", value).lower()
    value = re.sub(r"[^a-z0-9]+", "", value)
    return value


def merge_candidates(group: list[Candidate]) -> Candidate:
    base = max(group, key=lambda c: (c.text_length, len(c.sections)))
    base.title = titlecase_title(base.title)
    base.tags = sorted({tag for candidate in group for tag in candidate.tags})
    base.origins = sorted({origin for candidate in group for origin in candidate.origins})
    if base.author is None:
        authors = [c.author for c in group if c.author]
        if authors:
            base.author = "; ".join(dict.fromkeys(authors))
    return base


def build_final(candidates: list[Candidate]) -> list[dict]:
    groups: dict[str, list[Candidate]] = {}
    for candidate in candidates:
        groups.setdefault(dedup_key(candidate.title), []).append(candidate)

    final: list[Candidate] = []
    for group in groups.values():
        sources = {c.source for c in group}
        if len(sources) > 1:
            final.append(merge_candidates(group))
            continue
        # Same source: merge only when the entries are clearly the same song
        # (same author or no author at all and an overlapping page). Songs
        # that share a generic title but have different authors stay apart.
        by_author: dict[str | None, list[Candidate]] = {}
        for candidate in group:
            by_author.setdefault(candidate.author, []).append(candidate)
        if len(by_author) == 1:
            # One group per source. If several entries have no author and the
            # text is identical, keep the longest one; otherwise keep all.
            if len(group) == 1:
                final.append(group[0])
            else:
                clusters: list[list[Candidate]] = []
                for candidate in group:
                    text = "\n".join(s["text"] for s in candidate.sections)
                    for cluster in clusters:
                        other = "\n".join(
                            s["text"] for s in cluster[0].sections
                        )
                        if difflib.SequenceMatcher(None, text, other).ratio() >= 0.85:
                            cluster.append(candidate)
                            break
                    else:
                        clusters.append([candidate])
                for cluster in clusters:
                    kept = max(cluster, key=lambda c: c.text_length)
                    kept.origins = sorted(
                        {origin for candidate in cluster for origin in candidate.origins}
                    )
                    final.append(kept)
        else:
            final.extend(group)

    final.sort(key=lambda c: titlecase_title(c.title))
    used: dict[str, int] = {}
    output: list[dict] = []
    for candidate in final:
        title = titlecase_title(candidate.title)
        slug = slugify(title) or "canto"
        used[slug] = used.get(slug, 0) + 1
        song_id = f"ps_{slug}"
        if used[slug] > 1:
            song_id = f"{song_id}-{used[slug]}"
        source_parts = [
            f"{SOURCES_META[source]['label']}, p. {page}"
            for source, page in (candidate.origins or [(candidate.source, candidate.page)])
        ]
        note = "; ".join(source_parts)
        if candidate.author:
            note = f"{note} — {candidate.author}"
        output.append(
            {
                "id": song_id,
                "titles": {"it": title},
                "author": candidate.author,
                "tagIds": candidate.tags,
                "sections": candidate.sections,
                "license": "personalUse",
                "sourceNote": note,
            }
        )
    return output


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", action="store_true", help="print a review report")
    args = parser.parse_args()

    candidates: list[Candidate] = []
    for name in SOURCES_META:
        candidates.extend(parse_source(name))

    songs = build_final(candidates)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(
        json.dumps({"songs": songs}, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print(f"candidates: {len(candidates)}")
    by_source: dict[str, int] = {}
    for candidate in candidates:
        by_source[candidate.source] = by_source.get(candidate.source, 0) + 1
    print("by source:", by_source)
    print(f"catalogued songs: {len(songs)}")
    print(f"written: {OUT}")

    if args.report:
        for song in songs:
            print(
                f"{song['id']:<55} | {song['author'] or '-':<28} | "
                f"{','.join(song['tagIds'])}"
            )


if __name__ == "__main__":
    main()
