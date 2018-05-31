# -*- mode: Makefile -*-
SRC=main.tex
FILENAME=$(SRC:.tex=)
FMT=pdf
BUILDIR=out
#FMT=png
PDF=$(SRC:.tex=.pdf)
DEPEND=bibliography.bib
#DIAGS=img/gpu_paralell_serial.svg img/4_virtualization_tech.svg
TOOL=rubber --into $(BUILDIR) --pdf
TODOS=$(shell grep -i todo chapters/*.tex *.bib | grep -c -v newcommand)
DATETAG=$(shell date '+%Y_%m_%d_%H%M%S')


################################################################################


$(PDF):  $(SRC) $(DEPEND) TODOS
	@${TOOL} $(SRC) #%$(@:.pdf=.tex)
#	http://www.unix.com/shell-programming-and-scripting/55661-how-get-number-pages-pdf-file.html
	@echo
# This is specific for my thesis
	@echo "Output pdf created"
	@cp $(BUILDIR)/main.pdf ./Thesis.pdf
	###########################
	@echo "The current PDF has $$(pdftk $(BUILDIR)/$(FILENAME).pdf dump_data output | grep NumberOfPages | cut -d ' ' -f 2) pages"

camera: $(SRC) $(DEPEND) TODOS
	@rubber -p $(SRC)
#	http://www.unix.com/shell-programming-and-scripting/55661-how-get-number-pages-pdf-file.html
	@echo
	@pdftk $(BUILDIR)/$(FILENAME).pdf dump_data output | grep NumberOfPages | cut -d ' ' -f 2
# pdfinfo $(FILENAME).pdf | grep "Pages:" | cut -d ':' -f 2 | sed 's/ //g'

checkcamera:
	pdfinfo $(BUILDIR)/$(FILENAME).pdf
	pdffonts $(BUILDIR)/$(FILENAME).pdf

TODOS:
	@if [ $(TODOS) -eq "0" ]; then echo "++++ All TODOs fixed! ++++"; fi

	@echo "**** still $(TODOS) TODOs left to fix !!! ****"

clean:
	cd $(BUILDIR)/
	rm -f  *~ *.aux *.blg *.bbl *.log *.bin $PDF
	rm -f *.dvi *.ps *.aux *.log *.bbl *.blg *.bcf *~ *.out *.dia~ *.bak *.pdf *.nlo
	rm -f figures/*~
#	rm -f figures/*-eps-converted-to.pdf
#	rm -f paper_diff.* paper_old.*
# rm -f generate-*.tex


view:
	evince $(BUILDIR)/$(PDF) &

spellcheck:
	for file_tex in `ls *.tex`; do aspell check --lang=en_US $${file_tex}; done
