project('glkterm', 'c', version : '@@_VERSION_@@')

pkg = import('pkgconfig')

glk_dep = dependency('glk', version : '>=0.7.4')
glk_blorb_dep = dependency('glk_blorb', version : glk_dep.version())
glk_dispatch_dep = dependency('glk_dispatch', version : glk_dep.version())
ncurses_dep = dependency('ncurses')

glksources = ['main.c',
	'gtevent.c',
	'gtfref.c',
	'gtgestal.c',
	'gtinput.c',
	'gtmessag.c',
	'gtmessin.c',
	'gtmisc.c',
	'gtstream.c',
	'gtstyle.c',
	'gtw_blnk.c',
	'gtw_buf.c',
	'gtw_grid.c',
	'gtw_pair.c',
	'gtwindow.c',
	'gtschan.c',
	'gtblorb.c',
	'cgunicod.c',
	'cgdate.c']

glkterm_lib = static_library('glkterm', sources : glksources, dependencies : [ncurses_dep, glk_dep, glk_blorb_dep, glk_dispatch_dep], install : true, install_dir : get_option('libdir') + '/glkterm')
install_headers('glkstart.h', subdir : 'glkterm')

pkg.generate(
	description : '@@_DESCRIPTION_@@',
	name : 'glkterm',
	libraries : glkterm_lib,
	subdirs : 'glkterm',
	requires : ['ncurses >= ' + ncurses_dep.version(), 'glk = ' + glk_dep.version(), 'glk_blorb = ' + glk_dep.version(), 'glk_dispatch = ' + glk_dep.version()],
	version : '@@_VERSION_@@')

