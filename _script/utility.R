# * Author:    Bangyou Zheng (Bangyou.Zheng@csiro.au)
# * Created:   02:06 PM Wednesday, 11 May 2016
# * Copyright: AS IS



# Filter table and figure list
filter_list <-  function(df, prefix) {
    df %>%
        filter(grepl(sprintf('^%s-([a-z]+)$', prefix), chunk_name)) %>%
        select(Reference, Caption)
}


new_breaks <- function(x) {
    if (max(x) < 11) {
        breaks <- seq(1, 10, by = 1)
    } else {
        breaks <- seq(0, 2500, by = 500)
    }
    names(breaks) <- attr(breaks,"labels")
    breaks
}

# plot report
plot_report <- function(df, x_var, y_cols, x_lab = x_var, y_lab = 'Value',
                        panel = NULL, color = "Trait",
                        y_labels = NULL, ncol = 1, type = 'both',
                        chunk_type = 'output') {


    library(ggplot2)
    library(ggiraph)
    # x_var_name <- gsub('.*\\.(.*)', '\\1', x_var)
    # x_var_n <- list()
    # x_var_n[[x_var_name]] <- x_var
    cols <- c(x_var, y_cols)
    x_var_name <- gsub('.*\\.(.*)', '\\1', x_var)
    y_cols_name <- gsub('.*\\.(.*)', '\\1', y_cols)

    # Find the appearance date for each leaf cohort
    pd <- df %>%
        select(cols) %>%
        gather_(key_col = 'Trait', value_col = 'YValue', gather_cols = y_cols) %>%
        gather_(key_col = 'XVar', value_col = 'XValue', gather_cols = x_var) %>%
        mutate(XVar = gsub('.*\\.(.*)', '\\1', XVar))    %>%
        mutate(XVar = factor(XVar, levels = x_var_name))
    if (!is.null(y_labels)) {

        if (is.vector(y_labels))  {
            cols <- data_frame(Trait = y_cols, Label = y_labels)
        } else if (is.data.frame(y_labels)) {
            cols <- y_labels
        } else {
            stop('Not implemented')
        }
        pd <- pd %>%
            left_join(cols, by = 'Trait') %>%
            select(-Trait) %>%
            rename(Trait = Label) %>%
            mutate(Trait = factor(Trait, levels = cols$Label))
    } else {
        pd <- pd %>%
            mutate(Trait = gsub('.*\\.(.*)', '\\1', Trait)) %>%
            mutate(Trait = factor(Trait, levels = y_cols_name))
    }

    register_chunk(y_cols, paste0('fig:', opts_current$get("label")),
                   type = chunk_type)

    p <- ggplot(pd, aes(XValue, YValue))

    if (length(y_cols) > 1) {

        if (type %in% c('both', 'point')) {
            p <- p + geom_point(aes_string(colour = color, shape = color))
        }
        if (type %in% c('both', 'line')) {
            p <- p + geom_line(aes_string(colour = color))
        }
    } else {
        p <- p +
            geom_line() +
            geom_point()
    }
    if (length(x_var) > 1 & is.null(panel)) {
        p <- p + facet_wrap(~XVar, scales = 'free_x', ncol = 1)
    } else if (length(x_var) > 1 & !is.null(panel)) {
        p <- p + facet_grid(reformulate('XVar', panel), scales = 'free_x')
    } else if (length(x_var) == 1 & !is.null(panel)) {
        p <- p + facet_wrap(reformulate(panel), scales = 'free_x', ncol = 1)
    }

    p <- p + theme_bw() +
        theme(legend.position = 'bottom') +
        xlab(x_lab) + ylab(y_lab) +
        guides(colour = guide_legend(title = NULL, ncol = ncol),
               shape = guide_legend(title = NULL, ncol = ncol))
    if (length(grep('Stage', x_var)) > 0) {

        p <- p + scale_x_continuous(breaks = new_breaks)
    }

    key_stage <- data_frame(x = c(2, 4, 6, 8),
                            name = c('G', 'T', 'F', 'E'),
                            XVar = 'Stage') %>%
        filter(x <= ceiling(max(df$Wheat.Phenology.Stage, na.rm = TRUE)))
    if (sum(grepl('AccumulateThermalTime|Stage', x_var)) > 0) {
        if (length(grep('AccumulateThermalTime', x_var)) > 0) {
            ks2 <- data_frame(x = approx(df$Wheat.Phenology.Stage, df$Wheat.Phenology.AccumulateThermalTime,
                                     xout = key_stage$x)$y,
                              name = key_stage$name,
                              XVar = 'AccumulateThermalTime')
            key_stage <- bind_rows(key_stage, ks2)

        }
        y_rng <- ggplot_build(p)$layout$panel_ranges[[1]]$y.range
        p <- p + geom_text(aes(x, y = y_rng[1], label = name), data = key_stage, vjust = 0) +
            ylim(y_rng)
    }

    p
}




plot_report_rank <- function(df, y_cols, y_lab = 'Value', y_labels = NULL, ncol = 1,
                             chunk_type = 'output') {
    library(ggplot2)
    x_var <- 'Wheat.Leaf.AppearedCohortNo'
    cols <- c(x_var, y_cols)
    x_var_name <- gsub('.*\\.(.*)', '\\1', x_var)
    y_cols_name <- gsub('.*\\.(.*)', '\\1', y_cols)

    register_chunk(y_cols, paste0('fig:', opts_current$get("label")),
                   type = chunk_type)
    # Find the appearance date for each leaf cohort
    pd <- df %>%
        tbl_df() %>%
        filter(Wheat.Leaf.AppearedCohortNo > 0) %>%
        select(cols) %>%
        group_by(Wheat.Leaf.AppearedCohortNo) %>%
        slice(1) %>%
        ungroup() %>%
        gather(Trait, Value, -Wheat.Leaf.AppearedCohortNo) %>%
        rename(No = Wheat.Leaf.AppearedCohortNo)
    if (!is.null(y_labels)) {
        pd <- pd %>%
            left_join(data_frame(Trait = y_cols, Label = y_labels), by = 'Trait') %>%
            select(-Trait) %>%
            rename(Trait = Label) %>%
            mutate(Trait = factor(Trait, levels = y_labels))
    } else {
        pd <- pd %>%
            mutate(Trait = gsub('.*\\.(.*)', '\\1', Trait)) %>%
            mutate(Trait = factor(Trait, levels = y_cols_name))
    }

    p <- ggplot(pd, aes(No, Value))
    if (length(y_cols) > 1) {
        p <- p +
            geom_line(aes(colour = Trait)) +
            geom_point(aes(colour = Trait))
    } else {
        p <- p +
            geom_line() +
            geom_point()
    }
    p <- p + theme_bw() +
        theme(legend.position = 'bottom') +
        xlab('Rank') + ylab(y_lab) +
        guides(colour = guide_legend(title = '', ncol = ncol))
    p <- p +
        scale_x_continuous(breaks = seq(1, max(pd$No)), minor_breaks = seq(1, max(pd$No)))
    p
}


plot_report_vector <- function(df, x_var, y_cols, x_lab = x_var, y_lab = 'Value',
                        rank = FALSE) {
    library(ggplot2)
    col_names <- grepl(paste(y_cols, collapse = '|'), names(df)) | (names(df) %in% x_var)
    pd <- df[,col_names]
    names(pd) <- gsub('\\:|\\(|\\)', '_', names(pd))

    y_cols_new <- names(pd)[!(names(pd) %in% x_var)]

    pd <- pd %>%
        tbl_df() %>%
        gather_(key_col = 'Trait', value_col = 'Value', gather_cols = y_cols_new) %>%
        mutate(Index = gsub('^(.*)\\d+\\.\\d+\\.(\\d+)\\.$', '\\2', Trait),
            Trait = gsub('^(.*)\\d+\\.\\d+\\.(\\d+)\\.$', '\\1', Trait),
            Index = factor(as.numeric(as.character(Index)))) %>%
        gather_(key_col = 'XVar', value_col = 'XValue', gather_cols = x_var) %>%
        mutate(XVar = gsub('.*\\.(.*)', '\\1', XVar))
    x_var_name <- gsub('.*\\.(.*)', '\\1', x_var)
    pd <- pd %>%
        mutate(XVar = factor(XVar, levels = x_var_name))
    if (!rank) {

        p <-  ggplot(pd, aes(XValue, Value, colour = Index)) +
            geom_line()

        p <- p +
            geom_point() +
            theme_bw() +
            theme(legend.position = 'bottom') +
            xlab(x_lab) + ylab(y_lab) +
            guides(colour = guide_legend(title = ''))

        if (length(x_var) > 1 & length(y_cols) > 1) {
            p <- p + facet_grid(Trait~XVar, scales = 'free_x')
        } else if (length(x_var) > 1) {
            p <- p + facet_wrap(~XVar, scales = 'free_x', ncol = 1)
        }


        if (length(grep('Stage', x_var)) > 0) {
            p <- p +
                scale_x_continuous(breaks = new_breaks)
        }

    } else {
        pd <- pd %>%
            group_by(Trait, Index) %>%
            filter(Value > 0) %>%
            filter(Value == max(Value), XValue == min(XValue)) %>%
            slice(1)
         p <- ggplot(pd, aes(Index, Value)) +
            geom_point() +
            theme_bw() +
            xlab('Rank') + ylab(y_lab)
    }
    p

}


# Restructure path if APSIM format is used (i.e. contain a dot in the path)
apsim2path <- function(path) {

    if (sum(grepl('^Wheat', path)) != length(path)) {
        stop('path should start with Wheat')
    }
    path <- path %>%
        map_chr( function(x) stringr::str_split(x, '\\.')[[1]] %>%
                     paste0('/Name[text()="', ., '"]') %>%
                     paste(collapse = '/following-sibling::*') %>%
                     paste0('//.', .))
    path
}

plot_xypair <- function(pmf, path, x_lab, y_lab, label = path) {

    old_path <- path
    path <- apsim2path(path)
    register_chunk(old_path, paste0('fig:', opts_current$get("label")), type = 'input')

    df <- list()
    for (i in seq(along = path)) {
        xypair <- xml_find_all(pmf, xpath = paste0(path[i], '/following-sibling::XYPairs'))
        if (length(xypair) == 0) {
            xypair <- xml_find_first(pmf, xpath = paste0(path[i], '/XYPairs'))
        }
        if (length(xypair) == 0) {
            stop(paste0('Cannot find the path: ', path[i], '.'))
        }


        if (length(xypair) > 1) {
            stop(paste0('Find multiple path: ', path[i], '.'))
        }

        x <- as.numeric(xml_text(xml_children(xml_find_first(xypair, 'X'))))
        y <- as.numeric(xml_text(xml_children(xml_find_first(xypair, 'Y'))))

        df[[i]] <- data.frame(x = x, y = y, label = label[i], stringsAsFactors = FALSE)
    }
    df <- bind_rows(df)
    df$label <- factor(df$label, levels = label)
    p <- ggplot(df, aes(x, y)) +
        geom_point() +
        geom_line() +
        theme_bw() +
        xlab(x_lab) + ylab(y_lab)
    if (length(path) > 1) {
        p <- p + facet_wrap(~label, ncol = 1, scales = 'free_x')
    }
    p
}


get_fixed_value <- function(pmf, path) {
    path %>% apsim2path() %>%
        map_dbl(function(x) {
            xml_find_all(pmf, x) %>%
                assert_is_of_length(1) %>%
                xml_parent() %>%
                xml_find_first('FixedValue') %>%
                xml_double() %>%
                assert_is_numeric()
        })
}

# Get the all children from one node
get_xml_children <- function(pmf, path, label = path) {

    value <-  map2_df(path, label, function(x, y) {
        x %>%
            apsim2path() %>%
            xml_find_all(pmf, .) %>%
            assert_is_of_length(1) %>%
            xml_siblings() %>%
            map(function(x) {
                l <- list()
                l[[xml_name(x)]] <- xml_text(x)
                l
            }) %>%
            flatten_df() %>%
            mutate(trait = y)
    })
    value
}


# Retrieve soil value from apsimx file
get_soil_value <- function(pmf, var) {
    value <- xml_find_all(pmf, paste0('//', var))
    assert_is_of_length(value, 1)
    value <-  value %>%
        xml_children() %>%
        xml_double()
    assert_is_numeric(value)
    value
}


node_count <- function(pmf, path) {
    n <- length(xml_find_all(pmf, path))
    assert_is_identical_to_true(n > 0)
    n
}

get_xml_value <- function(pmf, path) {

    value <- xml_find_all(pmf, path)
    assert_is_non_empty (value)
    value <- value %>%
        xml_double()
    assert_is_numeric(value)
    value
}



we_beta <- function(mint, maxt, t_min, t_opt, t_max, t_ref = t_opt, maxt_weight = 0.5) {
    tav <- maxt_weight * maxt + (1 - maxt_weight) * mint


    res <- ifelse ((tav > t_min) & (tav < t_max),
    {
        a <- log(2.0) / log((t_max - t_min) / (t_opt - t_min))
        refeff <- t_opt * (2 * ((tav - t_min)^a) * ((t_opt - t_min)^a) -
                               ((tav - t_min) ^ (2 * a))) / ((t_opt - t_min) ^ (2 * a))
        a <- log(2.0) / log((t_max - t_min) / (t_opt - t_min))
        refefft <- t_opt * (2 * ((t_ref - t_min)^a) * ((t_opt - t_min)^a) -
                                ((t_ref - t_min) ^ (2 * a))) / ((t_opt - t_min) ^ (2 * a))
        refeff / refefft
    }, 0)

    return (res)
}



# Register output variables with chunk name
register_chunk <- function(vars, chunk, type) {
    if (is.null(chunk)) {
        return(invisible(NULL))
    }
    # Retrieve the g_output_chunk from global environment
    chunk_folder <- options('chunk_folder')[[1]]
    if (!dir.exists(chunk_folder)) {
        dir.create(chunk_folder, recursive = TRUE)
    }
    file <- file.path(chunk_folder, paste0(type, '.rds'))
    if (!file.exists(file)) {
        chunks_list <- list()
    } else {
        chunks_list <- readRDS(file)
    }

    for (i in seq(along = vars)) {
        chunks_list[[vars[i]]] <-  unique(c(chunks_list[[vars[i]]], chunk))
    }
    saveRDS(chunks_list, file = file)
}


