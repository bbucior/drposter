drposter: Generate Academic Posters in R Markdown and CSS
================
<span class="presenter">Ben Bucior<sup>1</sup></span>, &lt;Your name here&gt;<sup>2</sup>
<ol class="affiliations">
<li>
Northwestern University, Evanston, IL, USA
</li>
<li>
Earth
</li>
</ol>

Overview
--------

This template provides a framework to write posters in HTML/CSS using Rmarkdown. The code adapts the general markdown conventions of reveal.js slideshows,<sup>1–3</sup> allowing fast generation of posters that mostly separate content from presentation. The project README.md actually comes from the same Rmd as the poster, just set to the `rmarkdown::github_document` format. This documentation as a compiled poster is at <https://github.com/bbucior/drposter/tree/master/inst/example/poster.pdf>.

Ultimately, one of the main objectives of this project is to avoid manually tweaking the spacing, element-by-element, of content in PowerPoint or another program. Instead, define the desired layout, page size, and other parameters get the spacing details automatically. <span class="warning">(<strong>Note:</strong> Over the next couple of weeks I will be making many updates to the package (while working on a poster). CSS Grid support is now implemented, but some more reorganization is necessary.)</span>

Features
--------

Edit content in the \*.Rmd and poster.css files to write up your poster and style it. The poster output is best best viewed and "printed" in Chrome (limited testing has also been done in Firefox, but it doesn't yet apply the CSS rules for page size). The previewer built into standalone RStudio has difficulties with the layout CSS, so it is best to refresh the generated html file in a dedicated browser.

For now, the title section of the poster is automatically generated from the yaml header in the markdown file. Options for logos or other fields may be added later. By default, the poster is an A0 portrait size, but this is easily adapted at the top of the CSS file (and may gain user-friendly aliases later for size and orientation).

Currently, there are a few conventions to define the poster layout. Use level 1 sections (`#`) to denote main chunks of content, which are filled by row. Assigning a `{.col-x}` class, where `x` is 1--4, will set that chunk to use `1/x` of the width, using CSS Grid. The actual content goes inside of level 2 containers (`## Block title here`). There are also a few convenience classes, such as formatting a QR code block. The markdown source for the poster perhaps provides the best documentation by example.

The bibliography is now implemented using the pandoc features suggested by the relevant R markdown documentation<sup>4</sup>. A "references" div is required to place the references at a custom location before the end of the document<sup>5</sup>: see this example document for implementation. See also CSL resources<sup>6</sup> to automatically format references according to your field's conventions, using references specified in the Rmarkdown YAML header or bibtex.

Possible future directions
--------------------------

-   Themes?
-   Implement several nice base poster styles similar to the tikzposter LaTeX class<sup>7</sup>, which provides full customization of the color palette, block styling, etc.
-   Organize CSS file by rule purpose, implement CSS variables, and possibly separate user styles from package styles for easier updating.
-   Affiliations: the author list is currently cobbled together and could use an alternative to the *ad hoc* construction. Possibly pandoc's footnote syntax could help?

Reproducible research
---------------------

As an rmarkdown template, this format makes it easy to include plots and other analysis directly generated in R. By default, the raw code is hidden. The following plot of `cars` data is the classic example from R Markdown skeleton files...

![](github_files/figure-markdown_github/unnamed-chunk-1-1.png)

    ##      speed           dist       
    ##  Min.   : 4.0   Min.   :  2.00  
    ##  1st Qu.:12.0   1st Qu.: 26.00  
    ##  Median :15.0   Median : 36.00  
    ##  Mean   :15.4   Mean   : 42.98  
    ##  3rd Qu.:19.0   3rd Qu.: 56.00  
    ##  Max.   :25.0   Max.   :120.00

...along with the corresponding statistical summary.

Images can also be loaded by file path using the standard Markdown syntax. For example, some figures, such as illustrations, may be easiest in other software or analysis from other software (or collaborators who use different tools). Other standard markdown commands should work out-of-the box, though their CSS styling has not yet been tested.

![](Resources/Rlogo.svg)

Community
---------

This repository is under development and should be considered alpha-level software. **Do not use it directly for academic or professional content without having a proper backup to fully compile your posters.** The CSS classes and/or notation are not finalized and may break without warning.

This package will be updated as I make new posters for research, but it's still a work in progress. Installation of this package is easy using the `devtools` package: simply run `devtools::install_github("bbucior/drposter")`. After installation, the format will be available as an R Markdown template in the "New R Markdown" wizard. *Note:* one time the package installation updated my version of rmarkdown, which also required updating knitr before it would work.

<p class="qr">
![QR code](Resources/qr_code.png) For more information, please visit the project page at <https://github.com/bbucior/drposter>. Feel free to report issues, pull requests, or general comments on Github.
</p>

References
----------

(1) <http://lab.hakim.se/reveal-js/#/>.

(2) <https://github.com/rstudio/revealjs>.

(3) <http://rmarkdown.rstudio.com/developer_custom_formats.html>.

(4) <http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html>.

(5) <https://stackoverflow.com/questions/41532707/include-rmd-appendix-after-references>.

(6) <https://github.com/citation-style-language/styles>.

(7) <https://www.ctan.org/pkg/tikzposter>.

(8) <https://openclipart.org/detail/169900/circuit-board>.

(9) <https://www.r-project.org/logo/>.

Acknowledgements
----------------

The former background image for the example poster is derived from public domain work.<sup>8</sup> The R logo<sup>9</sup> is copyright 2016 The R Foundation and dual-licensed as CC-BY-SA 4.0 or GPL-2. This package is derived from the excellent reveal.js HTML presentation framework<sup>1</sup> and corresponding R package.<sup>2</sup>
