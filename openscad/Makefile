SHELL=/bin/bash
.PHONY: all
SCAD ?= /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD

SCAD_FILE = chain_drive.scad

.PHONY: chain_drive
.PRECIOUS: *.stl *.gcode

all: chain_drive

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


module-%:
	export fname="$(shell echo $(*) | cut -d'.' -f1)" \
	&& export module="$(shell echo $(*) | cut -d'.' -f2-)" \
	&& echo -e "use <$$PWD/$$fname.scad>\n$$module();" \
	&& $(SCAD) \
		-o $$fname.$$module.stl \
		--render <(echo -e "use <$$PWD/$$fname.scad>\n$$module();")
# mowerbot: gcode

# stl: $(ALL_WALLS:%=stl-%)

# stl-%: wall-%.stl
# 	echo "Rendered  wall-$(*).stl"

# wall-%.stl: $(SCAD_FILE)
# 	echo "Rendering wall-$(*).stl"
# 	$(SCAD) \
# 		-D render_wall=$(*) \
# 		-o wall-$(*).stl \
# 		--render \
# 		$(SCAD_FILE)

clean: clean-gcode clean-stl

clean-stl:
	rm -f *.stl

clean-gcode:
	rm -f *.gcode