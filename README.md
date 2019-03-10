drposter: Generate Academic Posters in R Markdown and CSS
================
<span class="presenter">Ben Bucior<sup>1</sup></span>, \<Your name
here\><sup>2</sup>

<ol class="affiliations">

<li>

Northwestern University, Evanston, IL, USA

</li>

<li>

Earth

</li>

</ol>

<!-- The name drposter came from a convoluted pun: it's a poster based on R, M.D. files (not a real doctor),
and it also generates academic posters for PhD's and others. -->

# 

<!-- Span the first column for four rows, that way we can capture the usage block, two rows of template examples, and refs/footer information -->

## Overview

  - Template for writing HTML/CSS posters using Rmarkdown
  - Same conventions as pandoc presentations
    (e.g. reveal.js)<sup>1–3</sup>
  - Separates content from presentation
  - Goal: automatically get consistent spacing from specifications
    instead of a manual layout

<p style="text-align:center;">

![](drposter.png)

</p>

## Rmarkdown structure

<div class="fullwidth">

See also the [source
code](https://github.com/bbucior/drposter/tree/master/inst/example/poster.Rmd)
and [compiled
pdf](https://github.com/bbucior/drposter/tree/master/inst/example/poster.pdf)
for this poster on Github.

</div>

    ---
    title: Title of your document within R Markdown's YAML header
    output: drposter::drposter_poster
    ---
    
    # {.col-3}
    ## Overall document columns (`<h1>`)
    
    Content is organized using headers as sections.  Level 1
    sections define the overall layout of subblocks.  Use the
    `.col-x` class to use x columns for subblocks.
    
    ## Another left column block
    
    You can place multiple subblocks within the same overall
    .col-x, for example to get a 3-column layout like this
    example code here.
    
    # {.col-3}
    ## Individual content blocks (`<h2>`)
    
    Actual content goes within the level 2 blocks, which have
    two inner columns by default, e.g. for figures.
    
    ![](path_to_figure.jpg)
    
    Most of the markdown commands seem to work, though there
    are probably still some that are untested.
    
    # {.col-3}
    ## Use this div to write your references in a section:
    
    <div id="refs" class="references"></div>

## Licensing

### 3rd party

  - Package inspired by reveal.js presentation framework<sup>1</sup> and
    its R package<sup>2</sup>
  - Fonts under their respective licenses
  - Logo: thanks to Openclipart for the CC0 [graduation cap
    image](https://openclipart.org/detail/244447/minimliast-graduation-hat),
    [hexSticker](https://github.com/GuangchuangYu/hexSticker) for
    sticker generation, and
    [bcbioSmallRna](https://github.com/lpantano/bcbioSmallRna/blob/master/inst/sticker/sticker.R)
    for a helpful sticker example
  - See [CitationStyles.org](https://citationstyles.org/) and the CSL
    project<sup>4</sup> for more info about citation options (CC BY SA
    3.0)

### This package

  - drposter may be used under different licenses at your option
  - Entire R package: GPLv3 (like [R
    markdown](https://github.com/rstudio/rmarkdown))
  - Files for the [drposter pandoc
    template](https://github.com/bbucior/drposter/tree/master/inst/rmarkdown/templates/drposter/skeleton/drposter_files):
    same conditions as the official [pandoc
    templates](https://github.com/jgm/pandoc/tree/master/data/templates)
  - Poster CSS: [CC0 public
    domain](https://creativecommons.org/publicdomain/zero/1.0/)

## Community

<p class="qr">

![QR code](Resources/qr_code.png) For more information, please visit the
project page at <https://github.com/bbucior/drposter>. Feel free to
report issues, pull requests, or general comments on Github.

</p>

# 

## How to use this package

### Installation and updates

1.  `devtools::install_github("bbucior/drposter", dep=FALSE)` (or
    `install_local` on a downloaded copy) to install/update the package
2.  In RStudio, you can find the format listed as a template under the
    “New R Markdown” wizard, or use the command line.
3.  Template files are cached in `drposter_files/` to decouple your
    poster from the installed package version. Use `drposter_update` to
    resync them.

### Customizing the template

  - Avoid modifying `drposter_files/`
  - Indirectly override those rules in your own `custom.css` or
    equivalent
      - Easier to see and share your changes
      - Decouples your modifications from the base drposter styles
  - Customize the format of the bibliography<sup>5,6</sup> using a CSL
    style<sup>4</sup>

### Export

  - View and “print as PDF” from Chrome<sup>7</sup>
    <!-- Note: the footnote used to be a bibtex "note," but the default ACS template doesn't include that field -->
  - Be sure to save a PDF (and possibly html with `self_contained:
    true`) to archive your project at the end, in case there are changes
    in pandoc, rmarkdown, etc.
  - You can also render the poster in other formats, such as
    `github_document` or `revealjs::revealjs_presentation`

## Reproducible research

### Directly include plots

![](github_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

### Directly include stats

    ##      speed           dist       
    ##  Min.   : 4.0   Min.   :  2.00  
    ##  1st Qu.:12.0   1st Qu.: 26.00  
    ##  Median :15.0   Median : 36.00  
    ##  Mean   :15.4   Mean   : 42.98  
    ##  3rd Qu.:19.0   3rd Qu.: 56.00  
    ##  Max.   :25.0   Max.   :120.00

# 

## Customizable themes

Note the features for theming. If you had a special class attached to
the .level1 or .slides/theme, you could use a general descendent
selector to automatically get theming support, then break up these
details into separate theme files.

# 

## Default theme

This is an example of the default theme.

# 

## Minimalist theme

This is an example of the minimalist theme.

# 

## See also

  - tikzposter latex template, and its example themes for inspiration
    <https://bitbucket.org/surmann/tikzposter/downloads/>
  - [Other R markdown
    templates](https://gist.github.com/Pakillo/4854e5d760351206084f6be8abe476b2)
    with their advantages/disadvantages (pdf compatibility, consistent
    syntax with flexdashboard, etc.)

## References

<div id="refs" class="references">

<div id="ref-revealjs">

(1) <http://lab.hakim.se/reveal-js/#/>.

</div>

<div id="ref-rstudio-reveal">

(2) <https://github.com/rstudio/revealjs>.

</div>

<div id="ref-mdformats">

(3) <http://rmarkdown.rstudio.com/developer_custom_formats.html>.

</div>

<div id="ref-csl-github">

(4) <https://github.com/citation-style-language/styles>.

</div>

<div id="ref-rstudio-bib">

(5)
<http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html>.

</div>

<div id="ref-stackoverflow-refs">

(6)
<https://stackoverflow.com/questions/41532707/include-rmd-appendix-after-references>.

</div>

<div id="ref-firefox-footnote">

(7) *Limited testing shows that Firefox also works, but it doesn’t yet
apply experimental CSS rules for page size.*

</div>

</div>
