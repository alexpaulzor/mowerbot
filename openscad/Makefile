SHELL=/bin/bash
.PHONY: all
SCAD ?= /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
PYCAM_DATA_DIR ?= /usr/local/share/pycam

.PRECIOUS: *.stl *.gcode

MODULE_CMD := cut -d'.' -f2- | cut -d'(' -f1
# Have to invoke with `make 'stl-openbeam.beam(length~500)'`
# for named params, because make will not recognize wildcards contaning `=`
ARGS_CMD := cut -d'.' -f2- | grep -F '(' | cut -d'(' -f2- | sed -e 's/[)]$$//' | tr '~' '='

all: prep

prep:
	mkdir -p stl

stl-%: prep
	export     fname="$(shell echo '$(*)' | cut -d'.' -f1)" \
	&& export module="$(shell echo '$(*)' | $(MODULE_CMD))" \
	&& export   args="$(shell echo '$(*)' | $(ARGS_CMD))" \
	&& export tmpfile="$(shell mktemp)" \
	&& echo -e "use <$$PWD/$$fname.scad>\n$$module($$args);" > $$tmpfile \
	&& cat $$tmpfile \
	&& time $(SCAD) \
		-o stl/$$module.$$fname.stl \
		$$tmpfile \
	&& echo "Rendered stl/$$module.$$fname.stl" \
	&& say "Rendered $$module"
	rm -f $$tmpfile

clean: clean-gcode clean-stl

clean-stl:
	rm -f *.stl stl/*.stl

clean-gcode:
	rm -f *.gcode


lsmod-%:
	grep 'module ' $(*).scad \
		| sed -e 's/module //g'

lsmod:
	egrep '^module .*\(' *.scad lib/*.scad \
		| sed -e 's/\.scad:module /./' -e 's/[(].*//'

autostl-%:
	egrep '^module .*\(' a $(*).scad 2>/dev/null \
		| grep use_stl= \
		| sed -e 's/\.scad:module /./' -e 's/[(].*//' \
		| xargs -I{} make stl-{}

view:
	open stl


laser-%: prep
	export     fname="$(shell echo '$(*)' | cut -d'.' -f1)" \
	&& export module="$(shell echo '$(*)' | $(MODULE_CMD))" \
	&& export   args="$(shell echo '$(*)' | $(ARGS_CMD))" \
	&& export PYCAM_DATA_DIR="$(PYCAM_DATA_DIR)" \
	&& pycam stl/$$module.$$fname.stl

genmk-%:
	egrep -o '^module [^ (]+' $(*).scad \
		| grep -v ' _' \
		| sed -e "s~^module ~stl/~" \
		| sed -e "s~\([^/]*\)$$~\1.$(*).stl: $(*).scad stl-$(*).\1~"

# # match "module foobar() { // `make` me"
# TARGETS=$(shell sed '/^module [a-z0-9_-]*().*make..\?me.*$$/!d;s/module //;s/().*/.stl/' base.scad)

# all: ${TARGETS}

# # auto-generated .scad files with .deps make make re-build always. keeping the
# # scad files solves this problem. (explanations are welcome.)
# .SECONDARY: $(shell echo "${TARGETS}" | sed 's/\.stl/.scad/g')

# # explicit wildcard expansion suppresses errors when no files are found
# include $(wildcard *.deps)

# %.scad:
# 	echo -ne 'use <base.scad>\n$*();' > $@

# %.stl: %.scad
# 	openscad -m make -o $@ -d $@.deps $<

include *.mk