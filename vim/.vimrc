""" 기본 설정 """
set nocompatible              " Vi 호환성 모드를 비활성화
filetype on                   " 파일 유형 감지 활성화
filetype plugin on            " 파일 유형에 따른 플러그인 로드
filetype indent on            " 파일 유형에 따른 들여쓰기 로드

""" 기본 인터페이스 설정 """
syntax on                     " 문법 강조 활성화
set number                    " 줄 번호 표시
set relativenumber            " 상대적 줄 번호 표시
set cursorline                " 현재 줄 강조
set showmatch                 " 괄호 짝 표시
set incsearch                 " 증분 검색
set hlsearch                  " 검색 결과 강조
set ignorecase                " 검색 시 대소문자 무시
set smartcase                 " 대문자 포함 시 대소문자 구분
set wildmenu                  " 명령행 자동 완성 향상
set wildmode=list:longest     " 명령행 자동 완성 방식
set mouse=a                   " 모든 모드에서 마우스 지원
set clipboard=unnamed         " 시스템 클립보드 사용 (가능한 경우)
set backspace=indent,eol,start " 백스페이스 동작 개선
set ruler                     " 커서 위치 표시
set laststatus=2              " 상태 줄 항상 표시
set colorcolumn=80            " 80자 표시선
set nowrap                    " 자동 줄 바꿈 비활성화
set sidescroll=5              " 가로 스크롤 설정
set listchars=tab:>-,trail:~,extends:>,precedes:<  " 공백 문자 표시
set list                      " 공백 문자 표시 활성화
set encoding=utf-8            " UTF-8 인코딩
set termencoding=utf-8        " 터미널 인코딩
set showcmd                   " 입력 중인 명령 표시
set history=1000              " 명령 기록 저장 수 증가
set title                     " 창 제목 설정
set scrolloff=3               " 커서 주변에 최소 3줄 표시
set sidescrolloff=5           " 커서 주변에 최소 5열 표시

""" 컬러 스킴 설정 """
" 터미널이 지원하는 경우 256색 활성화
if &term =~# '256color' || has('gui_running')
  set t_Co=256
endif

" 기본 컬러 스킴 (대부분의 Vim 설치에서 기본으로 제공)
set background=dark
silent! colorscheme desert    " desert는 기본 내장 컬러 스킴

""" 인덴트 설정 """
set autoindent                " 자동 들여쓰기
set smartindent               " 스마트 들여쓰기
set cindent                   " C 스타일 들여쓰기
set tabstop=4                 " 탭 너비
set shiftwidth=4              " 들여쓰기 너비
set expandtab                 " 탭을 스페이스로 변환
set softtabstop=4             " 편집 시 탭 너비

""" C 언어 특화 설정 """
augroup c_settings
    autocmd!
    " .c 및 .h 파일에 대한 설정
    autocmd FileType c,cpp setlocal commentstring=//\ %s
    " Linux 커널 스타일 (커널 개발 시 활성화)
    " autocmd FileType c setlocal noexpandtab tabstop=8 shiftwidth=8
    " 자동으로 구문 검사 실행
    autocmd FileType c setlocal makeprg=gcc\ -Wall\ -Wextra\ -std=c11\ %\ -o\ %<
    " 태그 검색 경로
    autocmd FileType c setlocal tags=./tags,tags;$HOME
    " C 파일에서 헤더 파일 검색 경로
    autocmd FileType c setlocal path+=.,/usr/include,/usr/local/include
augroup END

""" 내장 자동 완성 설정 """
" Ctrl+n과 Ctrl+p를 통한 단어 완성
set complete+=i                     " 포함 파일에서 단어 완성
set completeopt=menuone,longest     " 자동 완성 옵션

""" 헤더/소스 파일 전환 (내장 기능만 사용) """
function! SwitchSourceHeader()
  if (expand("%:e") == "c")
    find %:t:r.h
  else
    find %:t:r.c
  endif
endfunction
nnoremap <F4> :call SwitchSourceHeader()<CR>


""" 키 매핑 """
" 리더 키 설정
let mapleader = ","

" 컴파일 및 실행 바로가기
nnoremap <F5> :w<CR>:!gcc -Wall -Wextra -std=c11 % -o %< && ./%<<CR>
nnoremap <F6> :w<CR>:!make<CR>
nnoremap <F7> :w<CR>:make<CR>:copen<CR>

" 내장 파일 탐색기 열기
nnoremap <F3> :Explore<CR>

" 버퍼 이동
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bd :bd<CR>

" 검색 강조 임시 비활성화
nnoremap <leader><space> :nohlsearch<CR>

" 에러 탐색
nnoremap <leader>cn :cn<CR>
nnoremap <leader>cp :cp<CR>

" 태그 점프 (ctags 있는 경우)
nnoremap <C-]> g<C-]>
nnoremap <leader>t :tag<space>

" 자동 완성 수동 트리거
inoremap <C-space> <C-x><C-o>

" 파일 저장
nnoremap <leader>w :w<CR>

" 터미널 열기 (Vim 8 이상)
if v:version >= 800
    nnoremap <leader>t :term<CR>
endif

" 중괄호 자동 들여쓰기
inoremap {<CR> {<CR>}<Esc>O

" 내장 맞춤법 검사 켜기/끄기
nnoremap <leader>s :setlocal spell!<CR>

""" 유용한 자동 명령 """
" 이전 위치 기억
augroup remember_position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" 비활성 상태에서 상대 줄 번호 비활성화
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" make 출력에서 컴파일 에러 감지
set errorformat=%f:%l:%c:\ %m,%f:%l:\ %m

" 커서가 있는 줄 하이라이트 (삽입 모드에서는 비활성화)
augroup cursor_highlight
    autocmd!
    autocmd InsertLeave * set cursorline
    autocmd InsertEnter * set nocursorline
augroup END

""" Sessions """
" 세션 옵션
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
" 세션 저장 및 복원
nnoremap <leader>ss :mksession! ~/.vim/session/
nnoremap <leader>sr :source ~/.vim/session/

""" 성능 최적화 """
set lazyredraw                 " 매크로 실행 중 화면 갱신 안 함
set ttyfast                    " 터미널 연결 속도가 빠르다고 Vim에 알림
set updatetime=300             " 스왑 파일 쓰기 및 CursorHold 이벤트 사이의 시간(ms)

""" 자동 명령 그룹을 사용하여 vimrc 재로드 시 중복 방지 """
augroup vimrc
    autocmd!
    " vimrc 편집 시 자동 다시 로드
    autocmd BufWritePost .vimrc source %
augroup END

""" modeline 지원 (파일 상단/하단에 vim: 설정 허용) """
set modeline
set modelines=5

""" 내장 태그 탐색 설정 """
" 태그 파일이 있으면 활성화
if filereadable("tags")
    set tagrelative
    set tags=./tags,tags;
endif

""" 상태 줄 개선 """
" 기본 상태 줄 사용자 정의 (플러그인 없음)
set statusline=
set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ REPLACE\ ':''}
set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=\ %n                                " 버퍼 번호
set statusline+=%#Visual#                           " 색상 전환
set statusline+=%{&paste?'\ PASTE\ ':''}           " 붙여넣기 모드 표시
set statusline+=%{&spell?'\ SPELL\ ':''}           " 맞춤법 모드 표시
set statusline+=%#CursorIM#                         " 색상 전환
set statusline+=%R                                  " 읽기 전용 플래그
set statusline+=%M                                  " 수정된 플래그
set statusline+=%#Cursor#                           " 색상 전환
set statusline+=%#CursorLine#                       " 색상 전환
set statusline+=\ %t\                               " 파일 이름
set statusline+=%=                                  " 오른쪽 정렬
set statusline+=%#CursorLine#                       " 색상 전환
set statusline+=\ %Y\                               " 파일 유형
set statusline+=%#CursorIM#                         " 색상 전환
set statusline+=\ %3l:%-2c\                         " 줄 번호 : 열 번호
set statusline+=%#Cursor#                           " 색상 전환
set statusline+=\ %3p%%\                            " 백분율

""" 커서 모양 (모드에 따라 변경) """
if &term =~ "xterm\\|rxvt"
    " 삽입 모드: 수직 막대
    let &t_SI = "\<Esc>[6 q"
    " 교체 모드: 밑줄
    let &t_SR = "\<Esc>[4 q"
    " 일반 모드: 블록
    let &t_EI = "\<Esc>[2 q"
endif

""" C 주석 매크로 """
" 블록 주석 추가
map <leader>cb O/*<Esc>j$a*/<Esc>k$i<space>

""" 접기 설정 """
set foldmethod=syntax          " 문법 기반 접기
set foldlevelstart=99          " 시작 시 모든 접기를 열어둠
" 간편한 접기 토글
nnoremap <space> za

""" 들여쓰기 가이드(indent guides) - 플러그인 없이 """
" 비주얼 모드에서 선택한 부분 들여쓰기 유지
vnoremap < <gv
vnoremap > >gv

""" 내장 터미널 설정 (Vim 8 이상) """
if v:version >= 800
    " 터미널 모드에서 일반 모드로 전환
    tnoremap <Esc> <C-\><C-n>
    " 터미널 모드에서 창 전환 
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
    " 터미널 모드로 입력하기 위한 매핑
    augroup terminal_settings
        autocmd!
        autocmd BufWinEnter,WinEnter term://* startinsert
        autocmd BufLeave term://* stopinsert
    augroup END
endif

""" man 페이지 내장 뷰어 """
" K를 눌러 현재 단어의 man 페이지 열기
runtime ftplugin/man.vim
set keywordprg=:Man

""" C 특화 매핑 """
" 함수 선언 생성 (함수 정의에서 실행)
function! GenFuncProto()
    let l:proto = getline(".")
    let l:proto = substitute(l:proto, "{.*$", ";", "")
    let @" = l:proto
    echo "Function prototype copied to clipboard"
endfunction
nnoremap <leader>fp :call GenFuncProto()<CR>

" 현재 함수 선택 (마우스 없이 함수 내용 선택)
function! SelectCurrentFunction()
    normal! [{V%
endfunction
nnoremap <leader>vf :call SelectCurrentFunction()<CR>

" 자주 사용하는 C 코드 조각 매핑
" 표준 포함 파일
inoremap <leader>si #include <stdio.h><CR>#include <stdlib.h><CR>#include <string.h><CR><CR>
" 메인 함수
inoremap <leader>mi int main(int argc, char *argv[])<CR>{<CR>    <CR>    return 0;<CR>}<Esc>2ki
" printf
inoremap <leader>pr printf("");<Esc>2hi
" fprintf
inoremap <leader>fr fprintf(stderr, "");<Esc>3hi
" 조건문
inoremap <leader>if if () {<CR>}<Esc>k$2hi
" 반복문
inoremap <leader>fo for (int i = 0; i < ; i++) {<CR>}<Esc>k$6hi
" 함수 선언
inoremap <leader>fu void func()<CR>{<CR>}<Esc>2k$i

""" C 메모리 관련 도우미 매핑 """
" malloc 추가
inoremap <leader>ma type *var = (type *)malloc(sizeof(type) * n);<Esc>0/:type<CR>cw
" free 추가
inoremap <leader>fr free(ptr);<Esc>0/:ptr<CR>cw

" 현재 파일을 sudo로 저장
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!
