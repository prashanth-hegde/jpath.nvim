if exists('g:loaded_jpath') | finish | endif        " prevent loading file twice

let s:save_cpo = &cpo                               " save user coptions
set cpo&vim                                         " reset them to defaults

command! JPath lua require'jpath'.filter()
command! JPFormat lua require'jpath'.format()

let &cpo = s:save_cpo                               " and restore after
unlet s:save_cpo

" set default configurations
"let g:jpath_switch_to_output_window = 'false'        " switch to output window after request completes
"let g:jpath_split = 'horizontal'                     " specifies whether to split output window vertically or horizontally
"let g:jpath_flags = '-u'                             " the default environment to get http configuration from

let g:loaded_nhttp = 1
