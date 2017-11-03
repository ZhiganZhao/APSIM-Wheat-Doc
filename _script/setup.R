options(chunk_folder = '_chunk')
library(knitr)
library(magrittr)
opts_chunk$set(
    cache = TRUE, echo = FALSE,
    out.width = '80%', fig.asp = 1,
    warning = FALSE, fig.align = 'center',
    message = FALSE)
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(assertive))
library(xml2)
library(DiagrammeR)
library(RSQLite)
source('_script/utility.R')

# Read the raw data
if (!exists('g_report', envir = .GlobalEnv)) {
    m <- dbDriver("SQLite")
    con <- dbConnect(m, dbname = '_simulation/simulation.db')
    g_report <- dbReadTable(con, 'Report')
    dbDisconnect(con)
    g_report <- g_report %>%
        filter(Wheat.Phenology.Stage <= 9) %>%
        tbl_df()
    g_report <- g_report[seq(which(g_report$Wheat.Phenology.CurrentStageName == 'Sowing'), nrow(g_report)),]
    # assign('g_report', g_report, .GlobalEnv)
}
if (!exists('g_pmf', envir = .GlobalEnv)) {
    g_pmf <- read_xml('_simulation/simulation.apsimx')
    # assign('g_pmf', g_pmf, .GlobalEnv)
}

# Define the globa variables which apply for the whole documentation
# Configuration of x axis
g_xvar <- c(
    'Wheat.Phenology.Stage',
    'Wheat.Phenology.AccumulateThermalTime')

g_xvar2 <- c(
    'Wheat.Phenology.Stage')

g_xlab <- 'Accumulated thermal time or stage'
g_xlab2 <- 'Growth stage'


# Names of organ as vector and data.frame
g_organs <- c('Grain', 'Root', 'Leaf', 'Spike', 'Stem')
g_organs_df <- data_frame(Organ = g_organs)

# List of demand component
g_demand <- c('Structural', "Metabolic", "Storage")


# Get the list of tables and figures
rmd <- readLines('_bookdown.yml')
files <- rmd[grepl('.*\\.Rmd"$', rmd)]
files <- gsub('^.*"(.*\\.Rmd)"$', '\\1', files)
files <- files[!grepl('^appendix.*\\.Rmd.*$', files)]



g_list_tbl <- files %>%
    map_df(function(x) {
        # x <- files[4]
        text <- readLines(x)
        start_pos <- grep('^```\\{r.*\\}', text)
        end_pos <- grep('^```$', text)
        chunk_name <- NULL
        tbl_cap <- NULL
        for (i in seq(along = start_pos)) {
            # i <- 1
            text_i <- text[seq(start_pos[i], end_pos[i])]
            if (sum(grepl('kable', text_i)) == 0) {
                next
            }
            # text_i <- paste(text_i, collapse = 'aaaaaaaaaaaaa')
            chunk_name <- c(chunk_name,
                            gsub('^```\\{r ([_a-zA-Z0-9\\-]+).*\\}.*$', '\\1', text_i[1]))
            cap <- text_i[grepl('caption *= *(\'|")(.*)(\'|")', text_i)]

            tbl_cap <- c(tbl_cap,
                         gsub('^.*caption *= *(\'|")(.*)(\'|").*$', '\\2', cap))

        }

        if (is.null(tbl_cap)) {
            return(NULL)
        }
        data_frame(chunk_name = chunk_name, tbl_cap = tbl_cap)
    }) %>%
    mutate(Reference = sprintf('Table \\@ref(tab:%s)', chunk_name)) %>%
    rename(Caption = tbl_cap)

g_list_fig <-
    files %>%
    map_df(function(x) {
        # x <- files[4]
        text <- readLines(x)
        fig_chunk <- text[grepl('^```\\{r.*fig\\.cap=.*$', text)]
        if (length(fig_chunk) == 0) {
            return(NULL)
        }
        gsub('^```\\{r (.*)\\}$', '\\1', fig_chunk)
        strsplit(fig_chunk, ', *')

        chunk_name <- gsub('^```\\{r ([_a-zA-Z0-9\\-]+),.*fig\\.cap=(\'|")(.*)(\'|").*$',
                           '\\1', fig_chunk)
        fig_cap <- gsub('^```\\{r ([_a-zA-Z0-9\\-]+),.*fig\\.cap=(\'|")(.*)(\'|").*$',
                        '\\3', fig_chunk)
        data_frame(chunk_name = chunk_name, fig_cap = fig_cap)
    }) %>%
    mutate(Reference = sprintf('Fig. \\@ref(fig:%s)', chunk_name)) %>%
    rename(Caption = fig_cap)


