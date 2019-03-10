.PHONY: publish gh css

RUN_R = export R_LIBS_USER="C:/Users/${USER}/Documents/R/win-library/3.5" && Rscript --vanilla

# Automatically compile example poster and other templates
# A few things need to be set up first:
# 1. Verify that R can find the path to the user library, e.g. the R_LIBS_USER line above.
# 2. Installing the drposter library

# The default publish target (`make`) will automatically take care of the PDF and Github dependencies
publish: gh poster.pdf

gh: ../../README.md ../../drposter.png

css:
	${RUN_R} -e 'devtools::install_local("../../../drposter")'; \
	${RUN_R} -e 'drposter::drposter_update()'

poster.pdf: poster.Rmd css drposter.png
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

