GRAPHVIZ ?= dot

all: png-abstract

png-%:
	$(GRAPHVIZ) -Tpng -o $(*).png $(*).dot

showpng-%: png-%
	open $(*).png || true