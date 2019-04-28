SHELL=/bin/bash
.PHONY: all
SCAD ?= /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD

.PRECIOUS: *.stl *.gcode

MODULE_CMD := cut -d'.' -f2- | cut -d'(' -f1
# Have to invoke with `make 'module-openbeam.beam(length~500)'`
# for named params, because make will not recognize wildcards contaning `=`
ARGS_CMD := cut -d'.' -f2- | grep -F '(' | cut -d'(' -f2- | sed -e 's/[)]$$//' | tr '~' '='

prep:
	mkdir -p stl

module-%: prep
	export     fname="$(shell echo '$(*)' | cut -d'.' -f1)" \
	&& export module="$(shell echo '$(*)' | $(MODULE_CMD))" \
	&& export   args="$(shell echo '$(*)' | $(ARGS_CMD))" \
	&& export tmpfile="$(shell mktemp)" \
	&& echo -e "use <$$PWD/$$fname.scad>\n$$module($$args);" > $$tmpfile \
	&& cat $$tmpfile \
	&& $(SCAD) \
		-o stl/$$module.$$fname.stl \
		--render $$tmpfile \
	&& echo "Rendered stl/$$module.$$fname.stl"
	rm -f $$tmpfile

clean: clean-gcode clean-stl

clean-stl:
	rm -f *.stl stl/*.stl

clean-gcode:
	rm -f *.gcode