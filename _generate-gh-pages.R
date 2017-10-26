# Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc")
# Sys.setenv(RMARKDOWN_MATHJAX_PATH="C:/Program Files/RStudio/resources/mathjax-23/MathJax.js")
# library(bookdown)
# unlink('_bookdown_files', recursive = TRUE)

tryCatch({
    if (file.exists('APSIM-Wheat.Rmd')) {
        file.remove('APSIM-Wheat.Rmd')
    }

    bookdown::render_book('.', output_format = 'bookdown::gitbook')
    bookdown::render_book('.', output_format = 'bookdown::word_document2')
    bookdown::render_book('.', output_format = 'bookdown::pdf_book')
    bookdown::render_book('.', output_format = 'bookdown::epub_book')
    # bookdown::calibre('_book/APSIM-Wheat.epub', '_book/APSIM-Wheat.mobi')


    links <- list.files('_book', '*.html', full.names = TRUE)
    links_info <- file.info(links)

    site_map <- paste0('<?xml version="1.0" encoding="utf-8" standalone="yes" ?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">',
                       paste(paste0('<url><loc>https://apsim-wheat-doc.bangyou.me/',
                                    basename(links), '</loc>',
                                    '<lastmod>',
                                    format(links_info$mtime, '%Y-%m-%dT%H:%M:%S+00:00'),
                                    ' </lastmod></url>'), collapse = '\r'),
                       '</urlset>')
    writeLines(site_map, '_book/sitemap.xml')

    }, error = function(e) {
    print(e)
    quit(save = "no", status = 100, runLast = FALSE)
    })
