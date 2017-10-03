# * Author:    Bangyou Zheng (Bangyou.Zheng@csiro.au)
# * Created:   02:06 PM Wednesday, 11 May 2016
# * Copyright: AS IS




new_breaks <- function(x) {
    if (max(x) < 11) {
        breaks <- seq(1, 10, by = 1)
    } else {
        breaks <- seq(0, 2500, by = 500)
    }
    names(breaks) <- attr(breaks,"labels")
    breaks
}


plot_report <- function(df, x_var, y_cols, x_lab = x_var, y_lab = 'Value',
                        panel = FALSE, y_labels = NULL, ncol = 1,
                        cohort = FALSE) {
    library(ggplot2)
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

    p <- ggplot(pd, aes(XValue, YValue))
    if (panel) {
        p <- p +
            geom_line() +
            geom_point()
        if (length(x_var) == 1) {
            p <- p + facet_wrap(~Trait, scales = 'free_y', ncol = 1)
        } else {
            p <- p + facet_grid(Trait~XVar, scales = 'free')
        }
    } else {
        p <- p +
            geom_line(aes(colour = Trait)) +
            geom_point(aes(colour = Trait))
        if (length(x_var) > 1) {
            p <- p + facet_wrap(~XVar, scales = 'free_x', ncol = 1)
        }
    }
    p <- p + theme_bw() +
        theme(legend.position = 'bottom') +
        xlab(x_lab) + ylab(y_lab) +
        guides(colour = guide_legend(title = '', ncol = ncol))
    if (length(grep('Stage', x_var)) > 0) {

        p <- p + scale_x_continuous(breaks = new_breaks)
    }

    key_stage <- data_frame(x = c(2, 4, 6, 8),
                            name = c('G', 'T', 'F', 'E'),
                            XVar = 'Stage')

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

    if (cohort) {
        cohort_appear <- df %>%
            tbl_df() %>%
            filter(Wheat.Leaf.AppearedCohortNo > 0) %>%
            select(x_var, Wheat.Leaf.AppearedCohortNo) %>%
            group_by(Wheat.Leaf.AppearedCohortNo) %>%
            slice(1) %>%
            ungroup() %>%
            gather(XVar, XValue, -Wheat.Leaf.AppearedCohortNo) %>%
            mutate(XVar = gsub('.*\\.(.*)', '\\1', XVar))    %>%
            mutate(XVar = factor(XVar, levels = x_var_name)) %>%
            left_join(pd, by = c('XVar', 'XValue'))
        p <- p +
            geom_point(aes(XValue, YValue), data = cohort_appear) +
            geom_text(aes(XValue, y_rng[2], label = Wheat.Leaf.AppearedCohortNo), data = cohort_appear,
                      size = 3)
    }

    p
}




plot_report_vector <- function(df, x_var, y_cols, x_lab = x_var, y_lab = 'Value',
                        unique = FALSE) {
    library(ggplot2)
    # x_var_name <- gsub('.*\\.(.*)', '\\1', x_var)
    # x_var_n <- list()
    # x_var_n[[x_var_name]] <- x_var

    col_names <- grepl(paste(y_cols, collapse = '|'), names(df)) | (names(df) %in% x_var)
    pd <- df[,col_names]
    names(pd) <- gsub('\\:|\\(|\\)', '_', names(pd))

    y_cols_new <- names(pd)[!(names(pd) %in% x_var)]

    pd <- pd %>%
        gather_(key_col = 'Trait', value_col = 'Value', gather_cols = y_cols_new) %>%
        mutate(
            Trait = gsub('.*\\.(.*)', '\\1', Trait),
            Index = gsub('(.*)\\d+_\\d+_(\\d+)_', '\\2', Trait),
            Trait = gsub('(.*)\\d+_\\d+_(\\d+)_', '\\1', Trait),
            Index = factor(as.numeric(as.character(Index)))
            ) %>%
        gather_(key_col = 'XVar', value_col = 'XValue', gather_cols = x_var) %>%
        mutate(XVar = gsub('.*\\.(.*)', '\\1', XVar))
    x_var_name <- gsub('.*\\.(.*)', '\\1', x_var)
    pd <- pd %>%
        mutate(XVar = factor(XVar, levels = x_var_name))
    if (!unique) {

        p <-  ggplot(pd, aes(XValue, Value, colour = Index)) +
            geom_line()

    } else {
        pd <- pd %>%
            group_by(Trait, XVar, Index) %>%
            filter(Value > 0) %>%
            filter(Value == max(Value), XValue == min(XValue))
         p <- ggplot(pd, aes(XValue, Value, colour = Index)) +
            geom_text(aes(XValue, Value, label = Index), vjust = 1.2) +
            geom_point() +
            theme_bw() +
            theme(legend.position = 'bottom') +
            xlab(x_lab) + ylab(y_lab) +
            guides(colour = guide_legend(title = ''))

    }
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
    p

}





plot_xypair <- function(pmf, xpath, x_lab, y_lab, label = xpath) {

    df <- list()
    for (i in seq(along = xpath)) {
        xypair <- xml_find_first(pmf, xpath = paste0(xpath[i], '/following-sibling::XYPairs'))
        if (length(xypair) == 0) {
            xypair <- xml_find_first(pmf, xpath = paste0(xpath[i], '/XYPairs'))
        }
        if (length(xypair) == 0) {
            stop(paste0('Cannot find the xpath: ', xpath[i], '.'))
        }


        x <- as.numeric(xml_text(xml_children(xml_find_first(xypair, 'X'))))
        y <- as.numeric(xml_text(xml_children(xml_find_first(xypair, 'Y'))))

        df[[i]] <- data.frame(x = x, y = y, label = label[i], stringsAsFactors = FALSE)
    }
    df <- bind_rows(df)
    p <- ggplot(df, aes(x, y)) +
        geom_point() +
        geom_line() +
        theme_bw() +
        xlab(x_lab) + ylab(y_lab)
    if (length(xpath) > 1) {
        p <- p + facet_wrap(~label, ncol = 1, scales = 'free_x')
    }
    p
}

get_fixed_value <- function(pmf, xpath) {

    value <- xml_find_all(pmf, xpath)
    assert_is_of_length(value, 1)
    value <-  value %>%
        xml_parent() %>%
        xml_find_first('FixedValue') %>%
        xml_double()
    assert_is_numeric(value)
    value
}

node_count <- function(pmf, xpath) {
    n <- length(xml_find_all(pmf, xpath))
    assert_is_identical_to_true(n > 0)
    n
}

get_xml_value <- function(pmf, xpath) {

    value <- xml_find_all(pmf, xpath)
    assert_is_non_empty (value)
    value <- value %>%
        xml_double()
    assert_is_numeric(value)
    value
}



