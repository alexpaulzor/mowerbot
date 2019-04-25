SHELL=/bin/bash
.PHONY: all
SCAD ?= /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD

SCAD_FILE = chain_drive.scad

.PHONY: chain_drive
.PRECIOUS: *.stl *.gcode

all:

chain_drive: 40_idler_sprocket.stl 40_drive_sprocket.stl 40_idle_drive_sprocket.stl 40_double_link_clip.stl 

40_idler_sprocket.stl: chain_drive.scad
	$(SCAD) \
		-D plate_obj_id=1 \
		-o 40_idler_sprocket.stl \
		--render \
		$(SCAD_FILE)

40_drive_sprocket.stl: chain_drive.scad
	$(SCAD) \
		-D plate_obj_id=2 \
		-o 40_drive_sprocket.stl \
		--render \
		$(SCAD_FILE)

40_idle_drive_sprocket.stl: chain_drive.scad
	$(SCAD) \
		-D plate_obj_id=3 \
		-o 40_idle_drive_sprocket.stl \
		--render \
		$(SCAD_FILE)

40_double_link_clip.stl: chain_drive.scad
	$(SCAD) \
		-D plate_obj_id=4 \
		-o 40_double_link_clip.stl \
		--render \
		$(SCAD_FILE)

MODULE_CMD := cut -d'.' -f2- | cut -d'(' -f1
# Have to invoke with `make 'module-openbeam.beam(length~500)'`
# for named params, because make will not recognize wildcards contaning `=`
ARGS_CMD := cut -d'.' -f2- | grep -F '(' | cut -d'(' -f2- | sed -e 's/[)]$$//' | tr '~' '='

module-%:
	export     fname="$(shell echo '$(*)' | cut -d'.' -f1)" \
	&& export module="$(shell echo '$(*)' | $(MODULE_CMD))" \
	&& export   args="$(shell echo '$(*)' | $(ARGS_CMD))" \
	&& export tmpfile="$(shell mktemp)" \
	&& echo -e "use <$$PWD/$$fname.scad>\n$$module($$args);" > $$tmpfile \
	&& cat $$tmpfile \
	&& $(SCAD) \
		-o $$fname.$$module.stl \
		--render $$tmpfile \
	&& echo "Rendered $$fname.$$module.stl"
	rm -f $$tmpfile

clean: clean-gcode clean-stl

clean-stl:
	rm -f *.stl

clean-gcode:
	rm -f *.gcode