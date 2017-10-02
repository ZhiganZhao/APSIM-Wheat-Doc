
library(knitr)
opts_chunk$set(
    cache = TRUE, echo = FALSE,
    out.width = '80%', fig.asp = 1,
    warning = FALSE, fig.align = 'center',
    message = FALSE)
library(readr)
library(tidyverse)
library(assertive)
library(xml2)
library(DiagrammeR)
library(RSQLite)
source('_utility.R')

# Read the raw data
if (!exists('report', envir = .GlobalEnv)) {
    m <- dbDriver("SQLite")
    con <- dbConnect(m, dbname = '_simulation/simulation.db')
    report <- dbReadTable(con, 'Report')
    dbDisconnect(con)
    report <- report %>%
        filter(Wheat.Phenology.Stage <= 9)
    report <- report[seq(which(report$Wheat.Phenology.CurrentStageName == 'Sowing'), nrow(report)),]
    # assign('report', report, .GlobalEnv)
}
if (!exists('pmf', envir = .GlobalEnv)) {
    pmf <- read_xml('_simulation/simulation.apsimx')
    # assign('pmf', pmf, .GlobalEnv)
}

# Configuration of x axis
x_var <- c(
    'Wheat.Phenology.Stage',
    'Wheat.Phenology.AccumulateThermalTime')

x_var2 <- c(
    'Wheat.Phenology.Stage')

x_lab <- 'Accumulated thermal time or stage'



