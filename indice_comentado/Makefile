PDF_ENGINE=pdflatex
MAIN=main

all: extract pdf

extract:
	python3 extract_index.py

pdf: extract
	$(PDF_ENGINE) $(MAIN).tex
	$(PDF_ENGINE) $(MAIN).tex

clean:
	rm -f *.aux *.log *.toc *.out $(MAIN).pdf

.PHONY: all pdf clean
