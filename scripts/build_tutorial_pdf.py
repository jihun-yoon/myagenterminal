import html
import re
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import PageBreak, Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs" / "tutorial.ko.md"
OUTPUT = ROOT / "output" / "pdf" / "tutorial.ko.pdf"
FONT = "/System/Library/Fonts/Supplemental/AppleGothic.ttf"

pdfmetrics.registerFont(TTFont("AppleGothic", FONT))
pdfmetrics.registerFont(TTFont("TutorialMono", "/System/Library/Fonts/Menlo.ttc", subfontIndex=0))

styles = getSampleStyleSheet()
styles.add(ParagraphStyle(
    name="TutorialTitle", parent=styles["Title"], fontName="AppleGothic",
    fontSize=20, leading=25, alignment=TA_CENTER, textColor=colors.HexColor("#14191f"),
    spaceAfter=4 * mm,
))
styles.add(ParagraphStyle(
    name="TutorialH2", parent=styles["Heading1"], fontName="AppleGothic",
    fontSize=14, leading=18, textColor=colors.HexColor("#14191f"),
    spaceBefore=4 * mm, spaceAfter=2 * mm,
))
styles.add(ParagraphStyle(
    name="TutorialH3", parent=styles["Heading2"], fontName="AppleGothic",
    fontSize=10.5, leading=14, textColor=colors.HexColor("#34404c"),
    spaceBefore=2.5 * mm, spaceAfter=1.2 * mm, keepWithNext=True,
))
styles.add(ParagraphStyle(
    name="TutorialBody", parent=styles["BodyText"], fontName="AppleGothic",
    fontSize=8.6, leading=11.8, textColor=colors.HexColor("#242a31"),
    spaceAfter=1.1 * mm,
))
styles.add(ParagraphStyle(
    name="TutorialSmall", parent=styles["BodyText"], fontName="AppleGothic",
    fontSize=7.6, leading=9.5, textColor=colors.HexColor("#4b5560"),
    leftIndent=4 * mm, spaceAfter=0.7 * mm,
))
styles.add(ParagraphStyle(
    name="TutorialCode", parent=styles["BodyText"], fontName="AppleGothic",
    fontSize=7.1, leading=9.5, textColor=colors.HexColor("#dce3ea"),
))
styles.add(ParagraphStyle(
    name="TutorialTable", parent=styles["BodyText"], fontName="AppleGothic",
    fontSize=7.3, leading=9.5, textColor=colors.HexColor("#242a31"),
))


def inline(text):
    text = text.replace("–", "-").replace("—", "-")
    escaped = html.escape(text, quote=False)
    escaped = re.sub(r"`([^`]+)`", r'<font name="TutorialMono">\1</font>', escaped)
    escaped = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", escaped)
    return escaped


def paragraph(text, style="TutorialBody"):
    return Paragraph(inline(text), styles[style])


def code_block(lines):
    body = "<br/>".join(html.escape(line, quote=False) for line in lines)
    return Table([[Paragraph(body, styles["TutorialCode"])]], colWidths=[170 * mm], style=TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#202831")),
        ("BOX", (0, 0), (-1, -1), 0.4, colors.HexColor("#3b4652")),
        ("LEFTPADDING", (0, 0), (-1, -1), 4 * mm),
        ("RIGHTPADDING", (0, 0), (-1, -1), 4 * mm),
        ("TOPPADDING", (0, 0), (-1, -1), 2.5 * mm),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 2.5 * mm),
    ]))


def markdown_table(rows):
    parsed = [[cell.strip() for cell in row.strip().strip("|").split("|")] for row in rows]
    if len(parsed) > 1 and all(set(cell) <= {"-", ":", " "} for cell in parsed[1]):
        parsed.pop(1)
    width = max(len(row) for row in parsed)
    parsed = [row + [""] * (width - len(row)) for row in parsed]
    data = [[Paragraph(inline(cell), styles["TutorialTable"]) for cell in row] for row in parsed]
    table = Table(data, colWidths=[170 * mm / width] * width, repeatRows=1)
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#dce3ea")),
        ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#b8c1ca")),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#f5f7f9")]),
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("LEFTPADDING", (0, 0), (-1, -1), 2.2 * mm),
        ("RIGHTPADDING", (0, 0), (-1, -1), 2.2 * mm),
        ("TOPPADDING", (0, 0), (-1, -1), 1.3 * mm),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 1.3 * mm),
    ]))
    return table


def build_story():
    lines = SOURCE.read_text(encoding="utf-8").splitlines()
    story = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if not line.strip():
            i += 1
            continue
        if line.startswith("```"):
            code = []
            i += 1
            while i < len(lines) and not lines[i].startswith("```"):
                code.append(lines[i])
                i += 1
            story.extend([code_block(code), Spacer(1, 1.5 * mm)])
            i += 1
            continue
        if line.startswith("|"):
            table = []
            while i < len(lines) and lines[i].startswith("|"):
                table.append(lines[i])
                i += 1
            story.extend([markdown_table(table), Spacer(1, 1.5 * mm)])
            continue
        if line.startswith("# "):
            story.append(Paragraph(inline(line[2:]), styles["TutorialTitle"]))
        elif line.startswith("## "):
            # Keep the final practice exercise and references off an orphan page.
            if line.startswith("## 13. "):
                story.append(PageBreak())
            story.append(Paragraph(inline(line[3:]), styles["TutorialH2"]))
        elif line.startswith("### "):
            story.append(Paragraph(inline(line[4:]), styles["TutorialH3"]))
        elif line.startswith("> "):
            story.append(paragraph(line[2:], "TutorialSmall"))
        elif re.match(r"^[-*] ", line):
            story.append(Paragraph("• " + inline(line[2:]), styles["TutorialSmall"]))
        elif re.match(r"^\d+\. ", line):
            story.append(paragraph(line, "TutorialSmall"))
        else:
            story.append(paragraph(line))
        i += 1
    return story


def footer(canvas, doc):
    canvas.saveState()
    canvas.setFont("AppleGothic", 7)
    canvas.setFillColor(colors.HexColor("#68727d"))
    canvas.drawString(18 * mm, 10 * mm, "myagenterminal · WezTerm · Herdr · Neovim 튜토리얼")
    canvas.drawRightString(192 * mm, 10 * mm, str(doc.page))
    canvas.restoreState()


OUTPUT.parent.mkdir(parents=True, exist_ok=True)
doc = SimpleDocTemplate(
    str(OUTPUT), pagesize=A4, rightMargin=20 * mm, leftMargin=20 * mm,
    topMargin=16 * mm, bottomMargin=16 * mm,
    title="WezTerm, Neovim, Herdr 한국어 튜토리얼", author="myagenterminal",
)
doc.build(build_story(), onFirstPage=footer, onLaterPages=footer)
print(OUTPUT)
