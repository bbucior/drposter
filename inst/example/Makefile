.PHONY: publish gh css

RUN_R = export R_LIBS_USER="C:/Users/${USER}/Documents/R/win-library/3.4" && Rscript --vanilla
WHICH_CHROME := "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"

# Automatically compile example poster and other templates
# A few things need to be set up first:
# 1. Verify that R can find the path to the user library, e.g. the R_LIBS_USER line above.
# 2. Installing the drposter library
# 3. Setting a path to Google Chrome, as $WHICH_CHROME
# Currently this Makefile is set up to run in Cygwin, especially the poster.pdf paths

publish: gh poster.pdf
gh: ../../README.md ../../drposter.png

css:
	${RUN_R} -e 'devtools::install_local("../../../drposter")'; \
	${RUN_R} -e 'drposter::drposter_update()'

# Converting files to absolute Windows paths to get Chrome to work in Cygwin
poster.pdf: poster.html
	echo "WARNING: Check that the fonts exported correctly in the PDF."; \
	echo "Sometimes the PDF export from headless Chrome is excluding the Roboto font."; \
	${WHICH_CHROME} --headless --disable-gpu --print-to-pdf=$$(cygpath -w $$PWD/$@) $$(cygpath -w $$PWD/$^)

poster.html: poster.Rmd css drposter.png
	${RUN_R} -e 'rmarkdown::render("$<")'

../../README.md: poster.Rmd
	${RUN_R} -e 'rmarkdown::render("$<", "github_document", output_file="github.md")'; \
	rm github.html; \
	rm -r github_files; \
	mv github.md $@

../../drposter.png: ../sticker/drposter.png
	cp $< $@

drposter.png: ../sticker/drposter.png
	cp $< $@

# In theory, we could also convert the poster to a presentation in one line of code.
# Though the content size and organization will not likely fit well with the presentation,
# so at least some tweaking would be necessary. (See also blank section title slides if
# the h1 dividers aren't labeled)
reveal.html: poster.Rmd
	${RUN_R} -e 'rmarkdown::render("$<", "revealjs::revealjs_presentation", output_file="$@")'

