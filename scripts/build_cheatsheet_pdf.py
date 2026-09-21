from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    KeepTogether,
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "output" / "pdf" / "cheatsheet.ko.pdf"
FONT = "/System/Library/Fonts/Supplemental/AppleGothic.ttf"

pdfmetrics.registerFont(TTFont("AppleGothic", FONT))

styles = getSampleStyleSheet()
styles.add(
    ParagraphStyle(
        name="KTitle",
        parent=styles["Title"],
        fontName="AppleGothic",
        fontSize=21,
        leading=26,
        alignment=TA_CENTER,
        textColor=colors.HexColor("#14191f"),
        spaceAfter=5 * mm,
    )
)
styles.add(
    ParagraphStyle(
        name="KSubTitle",
        parent=styles["Normal"],
        fontName="AppleGothic",
        fontSize=9,
        leading=13,
        alignment=TA_CENTER,
        textColor=colors.HexColor("#58616d"),
        spaceAfter=7 * mm,
    )
)
styles.add(
    ParagraphStyle(
        name="KH1",
        parent=styles["Heading1"],
        fontName="AppleGothic",
        fontSize=14,
        leading=18,
        textColor=colors.HexColor("#14191f"),
        spaceBefore=4 * mm,
        spaceAfter=2 * mm,
    )
)
styles.add(
    ParagraphStyle(
        name="KH2",
        parent=styles["Heading2"],
        fontName="AppleGothic",
        fontSize=10.5,
        leading=14,
        textColor=colors.HexColor("#34404c"),
        spaceBefore=2 * mm,
        spaceAfter=1.5 * mm,
    )
)
styles.add(
    ParagraphStyle(
        name="KBody",
        parent=styles["BodyText"],
        fontName="AppleGothic",
        fontSize=8.7,
        leading=12.5,
        textColor=colors.HexColor("#242a31"),
        spaceAfter=1.5 * mm,
    )
)
styles.add(
    ParagraphStyle(
        name="KSmall",
        parent=styles["BodyText"],
        fontName="AppleGothic",
        fontSize=7.4,
        leading=10,
        textColor=colors.HexColor("#4b5560"),
    )
)
styles.add(
    ParagraphStyle(
        name="KCode",
        parent=styles["BodyText"],
        fontName="AppleGothic",
        fontSize=8,
        leading=11,
        textColor=colors.HexColor("#dce3ea"),
    )
)
styles.add(
    ParagraphStyle(
        name="KTable",
        parent=styles["BodyText"],
        fontName="AppleGothic",
        fontSize=7.8,
        leading=10.5,
        textColor=colors.HexColor("#242a31"),
    )
)


def p(text, style="KBody"):
    return Paragraph(text, styles[style])


def code(text):
    return Table(
        [[Paragraph(text.replace("\n", "<br/>"), styles["KCode"])]],
        colWidths=[170 * mm],
        style=TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#202831")),
                ("BOX", (0, 0), (-1, -1), 0.4, colors.HexColor("#3b4652")),
                ("LEFTPADDING", (0, 0), (-1, -1), 4 * mm),
                ("RIGHTPADDING", (0, 0), (-1, -1), 4 * mm),
                ("TOPPADDING", (0, 0), (-1, -1), 2.5 * mm),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 2.5 * mm),
            ]
        ),
    )


def key_table(rows):
    table = Table(
        [[p("<b>동작</b>", "KTable"), p("<b>키</b>", "KTable")]]
        + [[p(a, "KTable"), p(b, "KTable")] for a, b in rows],
        colWidths=[72 * mm, 98 * mm],
        repeatRows=1,
    )
    table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#dce3ea")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.HexColor("#14191f")),
                ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#b8c1ca")),
                ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#f5f7f9")]),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("LEFTPADDING", (0, 0), (-1, -1), 2.5 * mm),
                ("RIGHTPADDING", (0, 0), (-1, -1), 2.5 * mm),
                ("TOPPADDING", (0, 0), (-1, -1), 1.5 * mm),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 1.5 * mm),
            ]
        )
    )
    return table


def footer(canvas, doc):
    canvas.saveState()
    canvas.setFont("AppleGothic", 7)
    canvas.setFillColor(colors.HexColor("#68727d"))
    canvas.drawString(18 * mm, 10 * mm, "myagenterminal · WezTerm · Herdr · Neovim")
    canvas.drawRightString(192 * mm, 10 * mm, f"{doc.page}")
    canvas.restoreState()


story = [
    p("WezTerm · Herdr · Neovim", "KTitle"),
    p("myagenterminal 현재 설정 기준 한국어 빠른 참고표", "KSubTitle"),
    p("1. 계층 이해하기", "KH1"),
    code("WezTerm 창\n└── Herdr 세션\n    └── workspace: 프로젝트/작업\n        ├── tab: 레이아웃\n        └── pane: 셸·에이전트·편집기·테스트"),
    p("WezTerm은 창과 최상위 탭, Herdr는 프로젝트와 pane, Neovim은 파일 편집과 Git 검토를 담당합니다."),
    p("2. WezTerm", "KH1"),
    key_table(
        [
            ("새 창 / 새 탭", "⌘N / ⌘T"),
            ("현재 탭 닫기", "⌘W"),
            ("이전/다음 탭", "⌘⇧[ / ⌘⇧]"),
            ("탭 1–9 선택", "⌘1 … ⌘9"),
            ("이전/다음 창", "⌘` / ⌘⇧`"),
            ("창 1–9 선택", "⌘⌥1 … ⌘⌥9"),
            ("페이지 스크롤", "⌘↑ / ⌘↓"),
            ("작은 단위 스크롤 (3줄)", "⌘⇧↑ / ⌘⇧↓"),
            ("글꼴 크게/작게/초기화", "⌘+ / ⌘- / ⌘0"),
            ("설정 다시 읽기", "⌘R"),
            ("활성 pane을 새 창으로 이동", "⌘⇧M"),
            ("복사 / 붙여넣기 / 검색", "⌘C / ⌘V / ⌘F"),
        ]
    ),
    p("각 창 제목 표시줄에는 [1], [2]처럼 창 번호가 표시됩니다. ll과 tree는 파일 경로를 hyperlink로 출력하며, ⌘-클릭하면 URL은 브라우저로, file:// 경로는 macOS 기본 앱으로 열립니다."),
    p("3. Herdr", "KH1"),
    p("프로젝트에서 <b>h</b>를 실행하면 Herdr를 시작하거나 기존 세션에 다시 연결합니다."),
    code("cd ~/path/to/project\nh"),
    p("Prefix는 <b>Ctrl-b</b>입니다. Ctrl-b를 누르고 손을 뗀 뒤 다음 키를 누릅니다."),
    key_table(
        [
            ("도움말", "Ctrl-b, ?"),
            ("오른쪽/아래 분할", "Ctrl-b, v / Ctrl-b, -"),
            ("pane 이동", "Ctrl-b, h/j/k/l"),
            ("다음 pane", "Ctrl-b, Tab"),
            ("pane 확대/복원", "Ctrl-b, z"),
            ("pane 닫기 / 크기 조절", "Ctrl-b, x / Ctrl-b, r"),
            ("스크롤백 copy mode / 편집기", "Ctrl-b, [ / Ctrl-b, e"),
            ("사이드바 표시/숨김", "Ctrl-b, b"),
            ("분리(detach)", "Ctrl-b, q"),
            ("새 tab", "Ctrl-b, c"),
            ("workspace 선택기", "Ctrl-b, w"),
            ("새 workspace", "Ctrl-b, Shift-n"),
            ("workspace 이름 변경", "Ctrl-b, Shift-w"),
            ("workspace 닫기", "Ctrl-b, Shift-d"),
        ]
    ),
    p("Copy mode: <b>Ctrl-u/d</b> 반 페이지, <b>k/j</b> 한 줄, <b>/</b> 검색, <b>q</b> 종료. 긴 기록은 <b>Ctrl-b, e</b>로 편집기에서 엽니다.", "KSmall"),
    p("자주 쓰는 명령: <b>herdr status</b>, <b>herdr workspace list</b>, <b>herdr agent list</b>, <b>herdr server reload-config</b>"),
    p("4. Neovim", "KH1"),
    key_table(
        [
            ("Insert 모드", "i / a / o"),
            ("Normal 모드로 복귀", "Esc"),
            ("Visual 선택", "v / V"),
            ("파일 찾기 / 텍스트 검색", "Space Space / Space /"),
            ("Neogit", "Space g g"),
            ("다음/이전 변경 hunk", "]h / [h"),
            ("hunk 미리보기/Stage/Reset", "Space h p / Space h s / Space h r"),
            ("저장", "Space w"),
        ]
    ),
    p("Normal 모드 명령: <b>:w</b> 저장, <b>:q</b> 종료, <b>:wq</b> 저장 후 종료, <b>:q!</b> 저장하지 않고 종료"),
    p("5. 추천 실전 흐름", "KH1"),
    code("cd ~/path/to/project\nh\nclaude  # 또는 codex\nCtrl-b, v\nv .\nCtrl-b, -\n# 아래 pane에서 테스트·서버·로그 실행\nCtrl-b, z  # 확대/복원\nCtrl-b, q  # 분리\nh           # 다시 연결"),
    p("문제가 생기면 Herdr 안인지 <b>echo $HERDR_ENV</b>로 확인하고, 단축키는 <b>Ctrl-b, ?</b>로 현재 키맵을 확인합니다."),
]

OUTPUT.parent.mkdir(parents=True, exist_ok=True)
doc = SimpleDocTemplate(
    str(OUTPUT),
    pagesize=A4,
    rightMargin=20 * mm,
    leftMargin=20 * mm,
    topMargin=16 * mm,
    bottomMargin=16 * mm,
    title="WezTerm · Herdr · Neovim 치트시트",
    author="myagenterminal",
)
doc.build(story, onFirstPage=footer, onLaterPages=footer)
print(OUTPUT)
