GRAPHVIZ ?= dot

all: png-abstract

png-%:
	$(GRAPHVIZ) -Tpng -o $(*).png $(*).dot \
	&& open $(*).png || true