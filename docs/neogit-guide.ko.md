# Neogit 화면 읽기: section, file, hunk부터 stage까지

이 문서는 Neovim에서 `Space g g`를 눌렀을 때 나타나는 Neogit 화면을
처음 읽는 사람을 위한 가이드입니다. Neogit은 별도의 버전 관리 시스템이 아니라
Git 저장소의 상태를 Neovim 안에서 보여 주고 조작하는 인터페이스입니다.
myagenterminal에서는 `Space`가 Neovim의 leader 키입니다.

## 먼저 Git의 세 위치를 구분한다

| 위치 | 뜻 | Neogit에서 주로 보이는 모습 |
| --- | --- | --- |
| `HEAD` | 마지막 commit이 가리키는 저장된 버전 | 변경을 비교하는 기준 |
| 작업 파일(working tree) | 지금 디스크에서 편집 중인 내용 | `Unstaged changes` |
| stage(index) | 다음 commit에 넣기로 선택한 내용 | `Staged changes` |

파일을 수정하면 작업 파일이 바뀝니다. `stage`는 선택한 변경을 index에 올리고,
`commit`은 index의 내용을 새 버전으로 기록합니다. 따라서 **수정했다고
자동으로 commit 대상이 되는 것은 아닙니다.** 한 파일의 일부만 stage하면
그 파일이 `Staged changes`와 `Unstaged changes` 양쪽에 나타날 수도 있습니다.

```text
HEAD의 버전 ──수정──▶ 작업 파일의 변경 ──stage──▶ index의 변경
                                                   │
                                                commit
                                                   ▼
                                                 새 HEAD
```

`git diff`는 보통 작업 파일과 index를, `git diff --staged`는 index와
`HEAD`를 비교합니다. Neogit의 두 변경 section도 이 차이에 대응합니다.

## Neogit 화면의 계층

Git 저장소 안에서 `v .`로 Neovim을 열고 `Space g g`를 누릅니다.
Neogit 상태 화면은 변경을 **section → file → hunk** 순서로 묶습니다.
아래는 실제 파일 상태를 가정한 구조 예시입니다.

```text
Untracked files             ← section: 아직 Git에 등록하지 않은 새 파일
  docs/new-note.md         ← file: 새로 만들었지만 stage하지 않음
Unstaged changes           ← section: 작업 파일과 stage(index)의 차이
  docs/guide.md            ← file: 이 파일에 아직 stage하지 않은 수정이 있음
    @@ -40,3 +40,4 @@      ← hunk: stage하지 않은 첫 변경 묶음
      ...
    @@ -180,3 +181,3 @@    ← 같은 section·파일 안의 다른 hunk
      ...
Staged changes             ← section: stage(index)와 HEAD의 차이
  docs/guide.md            ← 같은 실제 파일의 다른 수정은 이미 stage됨
    @@ -10,3 +10,3 @@      ← stage된 변경 묶음
      ...
```

**Section**은 문서의 장이나 코드의 함수가 아니라, Neogit이 변경의
Git 상태에 따라 파일 항목을 분류한 큰 구역입니다. 예를 들어 새로 만든
`new-note.md`는 아직 추적되지 않아 `Untracked files`에 놓입니다.
`guide.md`의 앞부분 수정만 stage하고 나머지 수정은 그대로 두었다면,
같은 파일 이름이 `Staged changes`와 `Unstaged changes`에 각각 나타납니다.
파일이 두 개 생긴 게 아니라 **같은 파일의 서로 다른 변경분**을 상태별로
나눠 보여 주는 것입니다. 나머지도 stage하면 그 변경분은 `Unstaged`에서
사라지고 `Staged`에 나타납니다.

**File**은 해당 section에 속한 파일 항목입니다. **Hunk**는 그 파일의
diff에서 서로 가까운 변경 줄을 묶은 블록입니다. 위 예시에서
`Unstaged changes` 안의 `guide.md`에는 hunk가 두 개 있습니다. Hunk는
함수나 문단 같은 의미 단위가 아니며, 주변에 표시하는 문맥 줄 수에 따라
합쳐지거나 나뉠 수 있습니다.

`Tab`은 커서가 있는 section이나 파일 항목을 펼치고 접습니다. 파일을
펼쳐야 안쪽의 `@@` hunk와 변경 줄을 볼 수 있습니다.

## `@@ -10,3 +10,4 @@`를 읽는 법

다음은 한 파일의 일부를 바꾼 예시 diff입니다. 읽기 쉽게 변경 앞뒤의
문맥을 1줄씩만 표시한 형태(`git diff -U1`)입니다.

```diff
diff --git a/docs/example.md b/docs/example.md
index abc1234..def5678 100644
--- a/docs/example.md
+++ b/docs/example.md
@@ -10,3 +10,4 @@
 제목
-예전 설명
+새 설명
+한 줄 추가
 끝
```

- `diff --git`은 한 파일의 diff 시작을 알립니다. `a/`는 비교 전,
  `b/`는 비교 후를 나타내는 Git의 기본 **표시용 접두어**입니다.
- `index` 줄의 짧은 문자열은 비교하는 Git 객체의 식별자이며, `100644`는
  파일 모드입니다. 변경된 본문 줄은 아닙니다.
- `---`와 `+++`는 각각 비교 전·후 파일을 가리키는 **파일 머리글**의
  일부입니다. 여기서는 줄 삭제·추가를 뜻하는 본문의 `-`·`+`와
  구별해야 합니다.
- `@@ ... @@`는 **hunk의 시작**입니다. `-10,3`은 이전 버전의 10번째
  줄부터 3줄, `+10,4`는 새 버전의 10번째 줄부터 4줄을 보여 준다는 뜻입니다.
  쉼표 뒤의 줄 수가 생략되면 1줄입니다. 끝의 `@@` 뒤에 함수 이름 등이
  붙기도 하는데, 변경 위치를 알아보기 위한 힌트입니다.
- 본문의 `-` 줄은 이전 버전에는 있었지만 새 버전에서 빠진 줄, `+` 줄은
  새 버전에 생긴 줄입니다. 앞에 공백 한 칸이 있는 줄은 변하지 않은
  **문맥(context)** 줄입니다.

위 예시는 `예전 설명`을 `새 설명`으로 바꾸고 한 줄을 더한 것입니다.
`@@`에 적힌 숫자는 변경 줄만이 아니라 함께 표시된 문맥 줄도 포함합니다.
파일의 먼 두 곳을 고치면 보통 `@@` 머리글이 두 개 생깁니다.

### 파일 머리글과 `a/`·`b/`는 실제 경로인가?

여기서 **파일 머리글**은 `example.md` 안에 적힌 제목이 아니라,
diff가 어떤 파일을 비교하는지 설명하는 부분입니다. 위 예시에서는
`diff --git`, `index`, `---`, `+++`가 hunk 앞에 놓인 파일 단위 정보이고,
`@@`부터 해당 파일의 변경 구간이 시작됩니다. 한 파일에 hunk가 여러 개여도
파일 머리글이 각 hunk마다 반복되지는 않습니다.

`a/docs/example.md`는 `a/`라는 실제 디렉터리에 파일이 있다는 뜻이
아닙니다. `a/`는 변경 전을 나타내는 접두어이고, 실제 파일 경로는
그 뒤의 `docs/example.md`입니다. `b/docs/example.md`도 같은 경로의
변경 후 모습입니다. 파일을 이동하거나 이름을 바꾼 diff라면 접두어 뒤의
이전·새 경로가 서로 다를 수 있습니다. `a/`·`b/`는 기본값이지
필수 형식은 아닙니다. `git diff --no-prefix`로 없애거나
`--src-prefix`·`--dst-prefix`로 바꿀 수 있습니다.

### `@@`는 어떤 기준으로 한 덩어리가 되는가?

Git의 일반적인 텍스트 diff는 이전·새 파일을 **줄 단위**로 비교합니다.
바뀐 줄의 연속 구간에 변경되지 않은 문맥 줄을 앞뒤로 붙여 보여 주는데,
이렇게 화면에 연속해서 표시되는 블록이 hunk입니다. 기본 문맥은 앞뒤
각 3줄이며, `git diff -U1`은 각 1줄, `git diff -U0`은 문맥 없이
표시합니다. 가까운 변경들의 문맥 범위가 이어지면 하나의 hunk에
여러 변경이 들어갈 수 있고, 범위가 떨어져 있으면 hunk가 나뉘어
`@@`가 여러 번 나옵니다.

즉 **`@@` 하나 = 변경 줄 하나**도, **함수 하나**도 아닙니다. 한 줄만
고쳐도 문맥 줄과 함께 hunk 하나가 될 수 있고, 한 hunk에 여러 곳의
변경이 들어갈 수도 있습니다. 문맥을 더 많이 표시하면 기존에 분리된
hunk가 합쳐질 수 있습니다. `--inter-hunk-context`로 가까운 hunk 사이의
문맥을 추가로 표시해 합칠 수도 있습니다. diff 알고리즘과 경계 조정
설정에 따라서도 정확한 hunk 경계는 달라질 수 있습니다.

## 화면을 탐색하고 원래 파일로 돌아가기

| 현재 화면 | 키 | 결과 |
| --- | --- | --- |
| 일반 파일의 Normal mode | `Space g g` | Neogit 상태 화면 열기 |
| 일반 파일의 Normal mode | `[h` / `]h` | 현재 파일의 이전/다음 변경 구간으로 이동(Gitsigns) |
| Neogit 상태 화면 | `j` / `k` | 항목 사이 이동 |
| Neogit 상태 화면 | `Tab` | 커서 위치의 section·파일 펼치기/접기 |
| Neogit 상태 화면 | `{` / `}` | 이전/다음 hunk의 `@@` 머리글로 이동 |
| Neogit 상태 화면 | `?` | 현재 화면의 키 도움말 |
| Neogit의 파일 항목 | `Enter` | 상태 화면을 닫고 파일 열기 |
| Neogit 상태 화면 | `q` | 상태 화면 닫기 |

`Enter`로 파일을 열었다면 Neogit의 상태 화면은 이미 닫혔습니다.
파일에서 다시 `Space g g`를 누르면 됩니다. 파일 화면에서 `q`만 누르는
것은 Neogit의 닫기 키가 아닙니다. Neovim Normal mode에서는 매크로 기록을
시작할 수 있습니다. Neovim 자체를 종료하려면 `:q`를 사용합니다. 두 키의
차이와 매크로는 [한국어 튜토리얼](tutorial.ko.md) 4장에서 설명합니다.

`[h`·`]h`와 `{`·`}`는 모두 변경 구간 사이를 이동하지만 **서로 다른
화면의 키**입니다. 전자는 편집 중인 파일 안에서 Gitsigns가 찾은 변경
위치로 이동하고, 후자는 Neogit 상태 화면에 표시된 diff의 hunk 시작 줄
(`@@` 머리글)로 이동합니다. "hunk 머리글로 이동"은 곧 그 hunk의
시작점으로 이동한다는 뜻이지, 머리글이라는 별도 묶음으로 이동한다는
뜻이 아닙니다. 일반 파일 화면에서 `{`·`}`는 기본 Vim 문단 이동 키이며,
Neogit의 hunk 이동으로 쓰이지 않습니다. 두 이동 키 모두 stage나
파일 수정은 하지 않습니다.

## Stage와 버리기는 다른 동작이다

Neogit 상태 화면에서 `s`는 stage, `u`는 unstage입니다. 두 동작은
변경을 commit 대상으로 올리거나 그 선택을 취소하는 것이며, 파일의
편집 내용을 삭제하는 뜻이 아닙니다. **커서 위치에 따라 범위가 달라집니다.**

| 커서 위치 | `s` 또는 `u`가 다루는 범위 |
| --- | --- |
| section 제목 | 그 section의 해당 변경 전체 |
| 파일 이름 | 그 파일의 해당 변경 전체 |
| 펼친 hunk 안 | 그 hunk의 변경 |

`s`는 주로 `Unstaged changes`에서, `u`는 `Staged changes`에서
사용합니다. `x`는 커서가 가리키는 변경을 **버리는(discard)** 동작입니다.
확인 단계가 있더라도 미커밋 작업을 잃을 수 있으니 단축키 연습에 사용하지
마세요. `c`는 commit 관련 메뉴를 엽니다. Commit은 그 시점에 stage된
내용으로 만들며, 작업 파일의 모든 변경을 자동으로 포함하지 않습니다.

myagenterminal에는 파일을 편집하는 화면의 **Gitsigns**도 있습니다.
파일 안에서 `]h`/`[h`는 다음/이전 hunk, `Space h p`는 hunk 미리보기,
`Space h s`는 현재 hunk stage입니다. `Space h r`은 현재 hunk의
미커밋 변경을 버립니다. 이 키들은 Neogit 상태 화면의 `s`·`u`·`x`와
서로 다른 화면에서 동작합니다.

## myagenterminal에서 안전하게 한 번 읽어 보기

현재 저장소에 이미 미커밋 변경이 있을 수 있습니다. 그 변경을 존중하며
다음 순서는 **읽기만** 합니다.

1. 저장소 디렉터리에서 `git status --short`로 변경 파일을 확인합니다.
2. `v .`로 Neovim을 열고 `Space g g`로 Neogit에 들어갑니다.
3. `Unstaged changes`에서 변경된 파일을 골라 `Tab`으로 펼칩니다.
4. `@@` 머리글을 찾고 `-`·`+`·공백 줄을 위 예시와 비교합니다.
5. 다른 `@@`가 있다면 `{`·`}`로 이동해 봅니다.
6. 파일 항목에서 `Enter`를 눌러 파일을 열고, 파일 안에서는
   `]h`·`[h`와 `Space h p`로 같은 변경을 확인합니다.
7. `Space g g`로 Neogit에 돌아와 `q`로 닫습니다.

이 연습에서는 `s`, `u`, `x`, `Space h s`, `Space h r`을 누르지
않습니다. Stage·unstage·commit을 직접 연습하려면 기존 작업과 분리된
일회용 Git 저장소를 사용하는 것이 안전합니다.

## 근거와 더 읽을 자료

- [Neogit 문서](https://github.com/NeogitOrg/neogit/blob/master/doc/neogit.txt):
  상태 화면, 기본 키, section·file·hunk 단위의 동작.
- [Git diff 형식](https://git-scm.com/docs/diff-format)과
  [GNU unified diff 설명](https://www.gnu.org/software/diffutils/manual/html_node/Detailed-Unified.html):
  파일 머리글, `@@` 범위, `+`·`-`·문맥 줄.
- [Git diff 옵션](https://git-scm.com/docs/git-diff):
  `a/`·`b/` 접두어, `-U` 문맥 줄 수, hunk 사이 문맥 설정.
- [Gitsigns 문서](https://github.com/lewis6991/gitsigns.nvim/blob/main/doc/gitsigns.txt):
  파일 안의 hunk 탐색·미리보기·stage.
- [myagenterminal Neovim 설정](../nvim/.config/nvim/lua/plugins/review.lua):
  이 저장소에서 실제로 쓰는 Neogit·Gitsigns 키.
