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

### 테마 전환

`mat` 전역 명령은 설치되지 않습니다. **myagenterminal 저장소에서**
`./scripts/theme.sh day|night|status`를 실행하세요. 다른 곳에서는 절대 경로를
사용합니다. 기본값은 night이며 `status`는 저장된 선택값을 보여 줍니다.
WezTerm은 다시 읽히고, 이미 열린 Neovim은 재시작해야 합니다. Herdr는
저장 파일 대신 실행 중인 터미널의 밝기를 따릅니다.

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

### Codex 출력을 Neovim에서 읽기 — 마우스 불필요

```text
Codex pane에 초점 → Ctrl-b, e → Neovim에서 검색·스크롤 → :q Enter
```

1. Codex pane에 초점을 맞춥니다. 필요하면 `Ctrl-b`, `h/j/k/l`로 이동합니다.
2. `Ctrl-b`를 누르고 손을 뗀 뒤 `e`를 누릅니다. **copy mode에 먼저 들어갈 필요는
   없습니다.** Herdr가 해당 pane의 스크롤백을 `$EDITOR`로 엽니다. 이 저장소는
   `EDITOR=nvim`으로 설정하므로 Neovim이 자동으로 열립니다.
3. `Esc`로 Normal 모드를 확인한 뒤 `gg` / `G`(처음 / 끝), `Ctrl-u` / `Ctrl-d`
   (반 페이지), `j` / `k`(한 줄), `/검색어` `Enter`와 `n` / `N`을 사용합니다.
4. `:q` `Enter`로 편집기를 닫고 Herdr로 돌아옵니다.

이 방법은 **Herdr에 남은 pane 출력**을 엽니다. Codex가 자체 전체 화면에만
보관한 오래된 답변이 보이지 않으면 Codex에 Markdown 파일로 저장해 달라고 하고,
셸 pane에서 `v path/to/file.md`로 엽니다.

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
| 스크롤백 copy mode | `Ctrl-b`, `[` |
| 스크롤백을 편집기로 열기 | `Ctrl-b`, `e` |
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
| workspace 닫기 | `Ctrl-b`, `Shift-d` |
| Git worktree workspace | `Ctrl-b`, `Shift-g` |

### 마우스·Page Up/Down 키 없이 스크롤백 탐색

Herdr 화면에서는 WezTerm의 `ScrollByPage`가 아니라 Herdr 자체 스크롤백을
사용합니다. `Ctrl-b`, `[`로 copy mode에 들어간 뒤 조작합니다.

| 동작 | 키 |
| --- | --- |
| 반 페이지 위/아래 | `Ctrl-u` / `Ctrl-d` |
| 한 줄 위/아래 | `k` / `j` |
| 이전/다음 문단 | `{` / `}` |
| 앞/뒤 검색 | `/` / `?` |
| 다음/이전 검색 결과 | `n` / `N` |
| copy mode 종료 | `q` / `Esc` |

copy mode 커서는 현재 출력의 맨 아래에서 시작하며, `Ctrl-u/d`로 이동한 뒤
`k/j`를 누르면 현재 커서 위치에서 한 줄씩 조정됩니다. 검색이나 정밀한 탐색에는
copy mode를 나와 위의 **Codex → Neovim** 절차(`Ctrl-b`, `e`)를 사용합니다.

`Ctrl-b`, `Shift-d`는 확인 후 현재 workspace와 pane을 닫지만 프로젝트
디렉터리나 연결된 Git branch/worktree를 삭제하지 않습니다.

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
| Oil 폴더 탐색 | `Space`, `e` |
| 텍스트 검색 | `Space`, `/` |
| Neogit 열기 | `Space`, `g`, `g` |
| 다음/이전 변경 hunk | `]h` / `[h` |
| hunk 미리보기 | `Space`, `h`, `p` |
| hunk stage | `Space`, `h`, `s` |
| hunk reset | `Space`, `h`, `r` |
| 저장 | `Space`, `w` |

Oil: `Enter`로 파일·폴더 열기, `-`로 상위 폴더, `g?`로 도움말.
이름 변경·삭제 등은 `:w` 때 파일시스템에 적용됩니다. Snacks 선택기는
`Space Space`(파일)·`Space /`(내용)처럼 빠른 검색에 사용합니다.

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
