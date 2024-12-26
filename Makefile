LATEXMK=latexmk
LATEXMK_OPTS=-interaction=nonstopmode -quiet
ALGO_DIR=tla-specifications
JAR=tla2tools.jar
TLA_TOOLS_JAR_URL=https://github.com/tlaplus/tlaplus/releases/download/v1.8.0/$(JAR)
LATEX_FILES := main.tex

all: main.pdf

# Download the JAR if it does not exist
$(JAR):
	wget -O $@ $(TLA_TOOLS_JAR_URL)

tlatex.sty: $(JAR)
	jar xf $(JAR) tla2tex/tlatex.sty
	mv tla2tex/tlatex.sty .
	rm -r tla2tex

# Don't redownload stuff every time
.PRECIOUS: $(JAR) tlatex.sty

%.pdf: %_uncropped.pdf
	pdfcrop $< $@

%_uncropped.pdf: %_preprocessed.tex tlatex.sty
	$(LATEXMK) $(LATEXMK_OPTS) -pdf $<
	cp $(basename $<).pdf $(basename $@).pdf
	$(LATEXMK) $(LATEXMK_OPTS) -C $(basename $<)
	$(LATEXMK) $(LATEXMK_OPTS) -C tlatex
	rm tlatex.tex

%_preprocessed.tex: $(ALGO_DIR)/%.tex $(JAR)
	java -cp $(JAR) tla2tex.TeX -out $@ $<

main.pdf: main.tex Snapshot.pdf WeakAgreement-1.pdf WeakAgreement-2.pdf
	$(LATEXMK) $(LATEXMK_OPTS) -pdf $<
	cp main.pdf main_.pdf
	latexmk -C main.tex
	mv main_.pdf main.pdf

clean:
	rm main.pdf Snapshot.pdf WeakAgreement-1.pdf WeakAgreement-2.pdf

