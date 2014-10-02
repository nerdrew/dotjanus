if exists("b:lazarus_ruby")
  finish
endif
let b:lazarus_ruby = 1

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

  let cmd = ':Dispatch ' . rspec . ' -f p ' . s:spec_file

  if a:single
    let cmd.= ':'. s:spec_line
  endif
  exe cmd
endfunction
command! -complete=command -nargs=? RunRubyTest call RunRubyTest(<q-args>)
noremap <buffer> <silent> <unique> <leader>r :RunRubyTest<CR>
noremap <buffer> <silent> <unique> <leader>R :RunRubyTest 1<CR>
