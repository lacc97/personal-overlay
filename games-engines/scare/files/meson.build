project('scare', 'c', version : '@@_VERSION_@@')

zlibdep = dependency('zlib')

if get_option('use_glk')
	if get_option('glk_backend') == 'glkterm'
		glkdep = dependency('glkterm', static : true)
    elif get_option('glk_backend') == 'glktermw'
		glkdep = dependency('glktermw', static : true)
	else
		error('Glk backend not specified via \'glk_backend\' option')
	endif
	scaredeps = [zlibdep, glkdep]
	ossrc = 'source/os_glk.c'
else
	scaredeps = [zlibdep]
	ossrc = 'source/os_ansi.c'
endif

scaresrc = [
	'source/sctafpar.c',
	'source/sctaffil.c',
	'source/scprops.c',
	'source/scvars.c',
	'source/scexpr.c',
	'source/scprintf.c',
	'source/scinterf.c',
	'source/scparser.c',
	'source/sclibrar.c',
	'source/scrunner.c',
	'source/scevents.c',
	'source/scnpcs.c',
	'source/scobjcts.c',
	'source/sctasks.c',
	'source/screstrs.c',
	'source/scgamest.c',
	'source/scserial.c',
	'source/scresour.c',
	'source/scmemos.c',
	'source/scutils.c',
	'source/sclocale.c',
	'source/scdebug.c',
	ossrc
]

executable('scare', sources : scaresrc, dependencies : scaredeps, install : true)
