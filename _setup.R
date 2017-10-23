
library(knitr)
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
source('_utility.R')

# Read the raw data
if (!exists('g_report', envir = .GlobalEnv)) {
    m <- dbDriver("SQLite")
    con <- dbConnect(m, dbname = '_simulation/simulation.db')
    g_report <- dbReadTable(con, 'Report')
    dbDisconnect(con)
    g_report <- g_report %>%
        filter(Wheat.Phenology.Stage <= 9)
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
