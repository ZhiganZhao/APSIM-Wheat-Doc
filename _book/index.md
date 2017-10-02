---
title: "Documentation of APSIM-Wheat"
site: bookdown::bookdown_site
output: bookdown::gitbook
documentclass: book
bibliography: [citation.bib]
biblio-style: citation.csl
link-citations: yes
github-repo: byzheng/APSIM-Wheat
description: "Documentation of APSIM-Wheat"

---


# Introduction

<div class="rmdimportant">
<p>This documentation is based on the current version of <a href="https://github.com/APSIMInitiative/ApsimX/tree/d9717df5ef24f6d3f1eb4c301726c213960017bb">APSIM-Wheat module</a> with a few modifications in the next generation updated on 17-August-2017.</p>
</div>


<div class="rmdnote">
<p>A simulation is setup to demo the relationship among traits based on the cv. Hartog with high nitrogen and irrigation management under 15TraitMod experiment. The values in the figures below could be variable in other environments.</p>
</div>






This is only a documentation for Wheat model in [next generation of APSIM](https://github.com/APSIMInitiative/ApsimX) with our own understanding.

The main contents include 

- Detail description of science parts of APSIM-Wheat model
- Figures of default parameters
- Figures of general outputs


## Contributors of this documentation
 * Bangyou Zheng <bangyou.zheng@csiro.au>
 * Karine Chenu <karine.chenu@uq.edu.au>
 * Scott Chapman <scott.chapman@csiro.au>
 * Enli Wang <enli.wang@csiro.au>



## How to contribute?

This documentation is wrote by [RMarkdown](rmarkdown.rstudio.com) and [bookdown](bookdown.org). I suggest you firstly to read the introduction about [RMarkdown](rmarkdown.rstudio.com) and [bookdown](bookdown.org), then fork this repository into your github account. Feel free to submit a pull request. 

## How to document your own simulation

The new document can be easily generated for any other simulations using following steps.

* Install the required software including [R](https://cran.r-project.org/), [RStudio](https://www.rstudio.com/), [Bookdown](https://bookdown.org/yihui/bookdown) and other depended packages.
* Fork or download all source codes from [git repository](https://github.com/byzheng/APSIM-Wheat-Doc).
* Replace your own simulation.apsimx under simulation subfolder. Your apsimx file should only have `ONE` simulation and include all report variables used in the report, which can be found in the report replacement of the existing apsimx file.
* Click `Build book` in the RStudio interface.

## Conventions

### Figures

Figures in the documentation are classified into two categories with different backgrounds, i.e. `Input` and `Output`. `Input` figures show default parameter values (not genetypic values) or dynamic parameter values (depending on the other status variables) in the apsimx model. `Output` figures show reportable variables in the in the apsimx model. The `Input` and `Output` variable names only show the last section (separated by full stop) or specified names to save spaces in the figures.

Most of figures use two time serial variables, i.e. `Stage` and `Accumulated thermal time since sowing`. However, only `Stage` is used if all values are constant (e.g. Fig. \@ref(fig:root-supply)), or stage based input variables.

The key stages are displayed in all figures (Section \@ref(sec:phe-stage-period)) including `G` for stage 2 `Germination`, `T` for stage 4 `Terminal Spikelet`, `F` for stage 6 `Flowering`, `E` for stage 8 `End of Grain Filling`.


## Software information

The R session information when compiling this book is shown below:


```
## R version 3.4.2 (2017-09-28)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 7 x64 (build 7601) Service Pack 1
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=English_Australia.1252  LC_CTYPE=English_Australia.1252   
## [3] LC_MONETARY=English_Australia.1252 LC_NUMERIC=C                      
## [5] LC_TIME=English_Australia.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
##  [1] bindrcpp_0.2     RSQLite_2.0      DiagrammeR_0.9.2 xml2_1.1.1      
##  [5] assertive_0.3-5  dplyr_0.7.4      purrr_0.2.3      tidyr_0.7.1     
##  [9] tibble_1.3.4     ggplot2_2.2.1    tidyverse_1.1.1  readr_1.1.1     
## [13] knitr_1.17      
## 
## loaded via a namespace (and not attached):
##  [1] viridis_0.4.0              httr_1.3.1                
##  [3] bit64_0.9-7                viridisLite_0.2.0         
##  [5] jsonlite_1.5               assertive.sets_0.0-3      
##  [7] modelr_0.1.1               assertthat_0.2.0          
##  [9] assertive.data_0.0-1       blob_1.1.0                
## [11] cellranger_1.1.0           yaml_2.1.14               
## [13] backports_1.1.1            lattice_0.20-35           
## [15] glue_1.1.1                 downloader_0.4            
## [17] assertive.data.uk_0.0-1    assertive.matrices_0.0-1  
## [19] digest_0.6.12              assertive.types_0.0-3     
## [21] RColorBrewer_1.1-2         rvest_0.3.2               
## [23] colorspace_1.3-2           htmltools_0.3.6           
## [25] plyr_1.8.4                 psych_1.7.8               
## [27] XML_3.98-1.9               pkgconfig_2.0.1           
## [29] broom_0.4.2                assertive.data.us_0.0-1   
## [31] assertive.properties_0.0-4 assertive.reflection_0.0-4
## [33] haven_1.1.0                bookdown_0.5              
## [35] scales_0.5.0               brew_1.0-6                
## [37] influenceR_0.1.0           assertive.code_0.0-1      
## [39] lazyeval_0.2.0             mnormt_1.5-5              
## [41] rgexf_0.15.3               magrittr_1.5              
## [43] readxl_1.0.0               assertive.strings_0.0-3   
## [45] memoise_1.1.0              evaluate_0.10.1           
## [47] methods_3.4.2              assertive.numbers_0.0-2   
## [49] nlme_3.1-131               forcats_0.2.0             
## [51] foreign_0.8-69             Rook_1.1-1                
## [53] tools_3.4.2                hms_0.3                   
## [55] assertive.files_0.0-2      stringr_1.2.0             
## [57] munsell_0.4.3              compiler_3.4.2            
## [59] rlang_0.1.2                grid_3.4.2                
## [61] rstudioapi_0.7             visNetwork_2.0.1          
## [63] htmlwidgets_0.9            assertive.models_0.0-1    
## [65] assertive.base_0.0-7       igraph_1.1.2              
## [67] rmarkdown_1.6              gtable_0.2.0              
## [69] codetools_0.2-15           DBI_0.7                   
## [71] assertive.datetimes_0.0-2  reshape2_1.4.2            
## [73] R6_2.2.2                   gridExtra_2.3             
## [75] lubridate_1.6.0            bit_1.1-12                
## [77] bindr_0.1                  rprojroot_1.2             
## [79] stringi_1.1.5              parallel_3.4.2            
## [81] Rcpp_0.12.13
```

