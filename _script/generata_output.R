
levels <- list(L1 = 'Allocated',
               L2 = c('StructuralN', "StorageN", "MetabolicN"))
df <- c(list(organ = g_organs), levels) %>%
    expand.grid(stringsAsFactors = FALSE)

v1 <- df %>%
    apply(1, paste, collapse = '.') %>%
    paste0('[Wheat].', .)
df$Name <- v1
v2 <- df %>%
    group_by(organ, L1) %>%
    summarise(Name = paste(Name, collapse = ' + ')) %>%
    mutate(Name = paste0(Name, " as Wheat.", organ, ".", L1, "N")) %>%
    magrittr::use_series(Name)
writeLines(c(v1, v2), 'tmp.txt')
