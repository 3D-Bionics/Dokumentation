source:= Markdown

output:= PDF

sources:=$(wildcard $(source)/*.md)

objects := $(patsubst %.md,%.pdf,$(subst $(source),$(output),$(sources)))

all: $(objects)

# Recipe for converting a Markdown file into PDF using Pandoc
$(output)/%.pdf: $(source)/%.md

	export MERMAID_FILTER_FORMAT=png
	export MERMAID_FILTER_WIDTH=1200
#   export MERMAID_FILTER_LOC=media/

	pandoc -f gfm -t html \
	--filter mermaid-filter \
	--css=Export-Settings/css/theme.css \
	--template=Export-Settings/template.html \
	--toc --toc-depth=2 --number-sections \
	--standalone --pdf-engine=weasyprint \
	-o $@ $<

.PHONY : clean

clean:
	rm -f $(output)/*.pdf