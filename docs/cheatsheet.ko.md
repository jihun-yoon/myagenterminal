# WezTerm · Herdr · Neovim 치트시트

이 문서는 이 저장소의 현재 설정을 기준으로 한 빠른 참고표입니다.

## 1. 계층 이해하기

```text
WezTerm 창
└── Herdr 세션
    └── workspace: 프로젝트/작업
        ├── tab: 레이아웃
        └── pane: 셸·에이전트·편집기·테스트
```

- **WezTerm**: macOS 터미널 창과 최상위 탭을 관리합니다.
- **Herdr**: 오래 실행되는 에이전트 작업, workspace, tab, pane을 관리합니다.
- **Neovim**: 파일 편집과 Git 변경 검토에 사용합니다.

## 2. WezTerm

### 창과 탭

| 동작 | 단축키 |
| --- | --- |
| 새 창 | `⌘N` |
| 새 탭 | `⌘T` |
| 현재 탭 닫기 | `⌘W` |
| 이전/다음 탭 | `⌘⇧[` / `⌘⇧]` |
| 탭 1–9 선택 | `⌘1` … `⌘9` |
| 이전/다음 창 | `⌘\`` / `⌘⇧\`` |
| 창 1–9 선택 | `⌘⌥1` … `⌘⌥9` |
| 이전/다음 페이지 스크롤 | `⌘↑` / `⌘↓` |
| 작은 단위 스크롤(3줄) | `⌘⇧↑` / `⌘⇧↓` |
| 글꼴 크게/작게 | `⌘+` / `⌘-` |
| 글꼴 크기 초기화 | `⌘0` |
| 설정 다시 읽기 | `⌘R` |
| 활성 pane을 새 창으로 이동 | `⌘⇧M` |

마우스 휠이나 트랙패드 두 손가락 스크롤도 사용할 수 있습니다.

각 창의 제목 표시줄에는 `[1]`, `[2]`처럼 창 번호가 표시됩니다. 번호는
`⌘⌥1`–`⌘⌥9`의 창 선택 순서와 같습니다.

`ll`과 `tree`는 파일 경로를 hyperlink로 출력합니다. `⌘`-클릭하면 URL은
브라우저로, `file://` 경로는 macOS 기본 앱으로 열립니다. Codex나 Neovim이
마우스를 가로채는 경우에도 `⌘`-클릭은 WezTerm이 우선 처리합니다.

### 복사와 검색

| 동작 | 단축키 |
| --- | --- |
| 복사 | `⌘C` |
| 붙여넣기 | `⌘V` |
| 터미널 출력 검색 | `⌘F` |

## 3. Herdr

셸에서 프로젝트로 이동한 뒤 시작합니다.

```bash
cd ~/path/to/project
h
```

`h`는 `herdr`를 시작하거나 기존 세션에 다시 연결하는 alias입니다.

### Prefix 사용법

Herdr 단축키는 `Ctrl-b`를 먼저 누르고, 손을 뗀 다음 명령 키를 누릅니다.

예: `Ctrl-b`, `v`는 오른쪽 pane 분할입니다.

### Pane

| 동작 | 키 순서 |
| --- | --- |
| 도움말 | `Ctrl-b`, `?` |
| 오른쪽으로 분할 | `Ctrl-b`, `v` |
| 아래로 분할 | `Ctrl-b`, `-` |
| 왼쪽/아래/위/오른쪽 이동 | `Ctrl-b`, `h/j/k/l` |
| 다음 pane | `Ctrl-b`, `Tab` |
| pane 확대/복원 | `Ctrl-b`, `z` |
| pane 닫기 | `Ctrl-b`, `x` |
| 크기 조절 모드 | `Ctrl-b`, `r` |
| 사이드바 표시/숨김 | `Ctrl-b`, `b` |
| 분리(detach) | `Ctrl-b`, `q` |

### Tab과 Workspace

| 동작 | 키 순서 |
| --- | --- |
| 새 tab | `Ctrl-b`, `c` |
| 이전/다음 tab | `Ctrl-b`, `p/n` |
| tab 1–9 선택 | `Ctrl-b`, `1` … `9` |
| tab 이름 변경 | `Ctrl-b`, `Shift-t` |
| workspace 선택기 | `Ctrl-b`, `w` |
| 새 workspace | `Ctrl-b`, `Shift-n` |
| workspace 이름 변경 | `Ctrl-b`, `Shift-w` |
| Git worktree workspace | `Ctrl-b`, `Shift-g` |

### 자주 쓰는 명령

```bash
herdr status
herdr workspace list
herdr session list
herdr agent list
herdr integration status
herdr server reload-config
```

분리한 뒤 나중에 다시 연결할 때:

```bash
h
```

`herdr server stop`은 실제로 서버와 실행 환경을 종료하므로, 단순히 나갈 때는 사용하지 않습니다.

## 4. Neovim

### 모드

| 모드 | 용도 | 진입 | 종료 |
| --- | --- | --- | --- |
| Normal | 이동·명령 | 시작 상태 | — |
| Insert | 입력 | `i`, `a`, `o` | `Esc` |
| Visual | 선택 | `v`, `V` | `Esc` |
| Command | 저장·종료 | `:` | `Enter` / `Esc` |

모드가 헷갈리면 `Esc`를 누르고 Normal 모드로 돌아옵니다.

### 파일과 Git

```bash
v .
```

| 동작 | 키 |
| --- | --- |
| 파일 찾기 | `Space`, `Space` |
| 텍스트 검색 | `Space`, `/` |
| Neogit 열기 | `Space`, `g`, `g` |
| 다음/이전 변경 hunk | `]h` / `[h` |
| hunk 미리보기 | `Space`, `h`, `p` |
| hunk stage | `Space`, `h`, `s` |
| hunk reset | `Space`, `h`, `r` |
| 저장 | `Space`, `w` |

### 저장과 종료

Normal 모드에서:

```text
:w      저장
:q      종료
:wq     저장 후 종료
:q!     저장하지 않고 종료
```

## 5. 추천 실전 흐름

```text
1. WezTerm에서 프로젝트 디렉터리로 이동
2. h                         Herdr 시작/재연결
3. claude 또는 codex          에이전트 pane
4. Ctrl-b, v                  오른쪽 pane 생성
5. v .                        Neovim으로 프로젝트 열기
6. Ctrl-b, -                  아래 pane 생성
7. 테스트·서버·로그 실행
8. Ctrl-b, z                  현재 pane 확대/복원
9. Ctrl-b, q                  Herdr 분리
10. h                         나중에 다시 연결
```

## 6. 문제가 생겼을 때

```bash
echo "$HERDR_ENV"       # 1이면 이미 Herdr 안에 있음
herdr status             # 서버 상태
herdr agent list         # 에이전트 감지 상태
```

- Herdr 단축키가 안 되면 `Ctrl-b`, `?`로 현재 키맵을 확인합니다.
- Neovim이 이상하면 `Esc`를 누른 뒤 명령을 입력합니다.
- WezTerm 설정을 바꾼 뒤 `⌘R`로 다시 읽습니다.
- 단순히 Herdr를 나갈 때는 `Ctrl-b`, `q`; 서버를 중지할 때만 `herdr server stop`을 사용합니다.
