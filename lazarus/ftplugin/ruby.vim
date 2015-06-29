if exists("b:lazarus_ruby")
  finish
endif
let b:lazarus_ruby = 1

if !exists('g:rspec_runner')
  let g:rspec_runner = 'Neomake!'
endif

function! RunRubyTest(single)
  if exists('g:rspec')
    let rspec = g:rspec
  elseif glob('.zeus.sock') == '.zeus.sock'
    let rspec = 'zeus rspec'
  elseif glob('bin/rspec') == 'bin/rspec'
    let rspec = 'bin/rspec'
  else
    let rspec = 'bundle exec rspec'
  endif

  if match(expand('%'), '_spec\.rb$') > -1
    let s:spec_file = expand('%')
    let s:spec_line = line('.')
  endif

  if !exists('s:spec_file')
    let s:spec_file = '%'
  endif

  let cmd = rspec . ' -f p ' . s:spec_file

  if a:single
    let cmd.= ':'. s:spec_line
  endif
  let &l:makeprg = cmd
  " Match file:line message, ignore lines: ^\.|F$, ignore blank / whitespace
  " lines
  let &l:efm = 'rspec %f:%l %m, %-G%*[.F], %-G\\s%#'
  update | exe g:rspec_runner
endfunction
command! -complete=command -nargs=? RunRubyTest call RunRubyTest(<q-args>)
noremap <buffer> <silent> <unique> <leader>r :RunRubyTest<CR>
noremap <buffer> <silent> <unique> <leader>R :RunRubyTest 1<CR>
