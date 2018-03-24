.PHONY: publish github

RUN_R = export R_LIBS_USER="C:/Users/$(shell whoami)/Documents/R/win-library/3.4" && Rscript --vanilla
#WHICH_CHROME := "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"

# Automatically compile example poster and other templates
# A few things need to be set up first:
# 1. Verify that R can find the path to the user library, e.g. the R_LIBS_USER line above.
# 2. Installing the drposter library
# 3. Downloading the appropriate CSL file, e.g. ACS
# 4. Setting a path to Google Chrome, as $WHICH_CHROME

#publish: github poster.pdf
publish:
	echo "Not yet implemented"
github: ../../README.md

drposter_files/drposter.css: ../rmarkdown/templates/drposter/skeleton/drposter_files/drposter.css
	${RUN_R} -e 'drposter::drposter_update()'

# Haven't gotten this automated yet.  At least manually converting from HTML to PDF is quick.
# This crashes without writing the output file.
#poster.pdf: poster.html
#	${WHICH_CHROME} --headless --print-to-pdf=$@ $^

poster.html: poster.Rmd drposter_files/drposter.css
	${RUN_R} -e 'rmarkdown::render("$<")'

../../README.md: poster.Rmd
	${RUN_R} -e 'rmarkdown::render("$<", "github_document", output_file="github.md")'; \
	rm github.html; \
	rm -r github_files; \
	mv github.md $@

# In theory, we could also convert the poster to a presentation in one line of code.
# Though the content size and organization will not likely fit well with the presentation,
# so at least some tweaking would be necessary. (See also blank section title slides if
# the h1 dividers aren't labeled)
reveal.html: poster.Rmd
	${RUN_R} -e 'rmarkdown::render("$<", "revealjs::revealjs_presentation", output_file="$@")'

