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

# Convert files to absolute Windows paths to get Chrome to work in Cygwin.
# Also use the virtual time parameter to avoid FOIT issues (diagnosed by changing the font-display properties), since headless Chrome is deeming the page loaded before all the fonts have caught up.
# The parameter gives the page more time (ms) to load before it's considered ready and "in a consistent-ish state": <https://groups.google.com/a/chromium.org/forum/#!topic/headless-dev/honibIZeYz0>
# Waiting for page load is a [difficult problem](https://github.com/GoogleChrome/puppeteer/issues/338) and known issue in scripted/headless Chrome.
# In part, the difficulty arises from Chrome trying to [print as soon as the page is ready](https://github.com/chromium/chromium/blob/0fb6097de7a555a77a69f8e239f98f938c72c2f8/headless/app/headless_shell.cc).
# For more background, see also [headless Chrome documentation](https://developers.google.com/web/updates/2017/04/headless-chrome) and a [list of Chromium command line switches](https://peter.sh/experiments/chromium-command-line-switches/).
# TODO: The pdf make target will need to be rewritten/simplified if the HTML to PDF conversion can be automated within the rmarkdown rendering function for drposter.
poster.pdf: poster.html
	${WHICH_CHROME} --headless --disable-gpu --virtual-time-budget=10000 --print-to-pdf=$$(cygpath -w $$PWD/$@) $$(cygpath -w $$PWD/$^)

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

