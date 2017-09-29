

安装树形目录插件
"*****************************************************************
1.解压nerdtree,将所有文件复制到:
C:\Program Files (x86)\Vim\vimfiles\

2.在_vimrc中添加如下配置脚本
" plugin - NERD_tree.vim 以树状方式浏览系统中的文件和目录  
" :ERDtree 打开NERD_tree :NERDtreeClose 关闭NERD_tree  
" o 打开关闭文件或者目录 t 在标签页中打开  
" T 在后台标签页中打开 ! 执行此文件  
" p 到上层目录 P 到根目录  
" K 到第一个节点 J 到最后一个节点  
" u 打开上层目录 m 显示文件系统菜单（添加、删除、移动操作）  
" r 递归刷新当前目录 R 递归刷新当前根目录  
"-----------------------------------------------------------------  
" F3 NERDTree 切换  
map <F3> :NERDTreeToggle<CR>  
imap <F3> <ESC>:NERDTreeToggle<CR>  
let g:NERDTreeWinPos="left"  
let g:NERDTreeWinSize=25  
let g:NERDTreeShowLineNumbers=1  
let g:neocomplcache_enable_at_startup = 1  
"*****************************************************************

gvim下打开当前文件所在目录
"*****************************************************************
"打开当前文件所在目录
function OpenFileLocation()
		if ( expand("%") != "" )
				execute "!start explorer /select, %"
		else
				execute "!start explorer /select, %:p:h"
		endif
endfunction
map <F7> <ESC>:call OpenFileLocation()<CR>
"*****************************************************************
