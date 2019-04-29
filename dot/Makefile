GRAPHVIZ ?= dot

all: mainboard.png

mainboard.png: mainboard.dot
	$(GRAPHVIZ) -Tpng -o mainboard.png mainboard.dot \
	&& open mainboard.png || true