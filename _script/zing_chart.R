# as.Date(g_report$Clock.Today)
#
# sel_report <- g_report %>%
#     mutate(Date = as.Date(Clock.Today),
#           DOY = lubridate::yday(Date)) %>%
#     select(DOY, Wheat.Phenology.AccumulateThermalTime,
#            Wheat.Phenology.ThermalTime,
#            Wheat.Phenology.DaysAfterSowing,
#            Wheat.Leaf.LAI,
#            Wheat.Leaf.SpecificLeafNitrogen,
#            contains('Photosynthesis'),
#            starts_with('Weather'))
#
# y_cols <- c('Wheat.Leaf.Photosynthesis_RUE',
#             'Wheat.Leaf.Photosynthesis_SPASS',
#             'Wheat.Leaf.Photosynthesis_DCaPS')
#
# p1 <- plot_report(g_report, 'Wheat.Phenology.DaysAfterSowing', y_cols,
#                   x_lab = 'Days after sowing',
#                   y_labels = c('RUE', 'EW', 'DCaPS'),
#                   y_lab = 'Photosynthesis rate (g/m2/d)', ncol = 3) +
#     geom_bar(aes(Wheat.Phenology.DaysAfterSowing, Weather.Radn),
#              stat = 'identity', alpha = 0.7, width = 0.5,data = g_report) +
#     scale_y_continuous(sec.axis = sec_axis(~., name = 'Radiation (mj/m2)'))
#
# p2 <- ggplot(g_report) +
#     geom_bar(aes(Wheat.Phenology.DaysAfterSowing, Weather.MeanT),
#              stat = 'identity', alpha = 0.7, width = 0.5, fill = 'black') +
#     ylab(expression(paste( "Daily mean temperature ", ~"("*degree*"C)"))) +
#     xlab('Days after sowing') +
#     # scale_x_continuous(minor_breaks =
#     #     seq(1, max(g_report$Wheat.Phenology.DaysAfterSowing))) +
#     geom_line(aes(Wheat.Phenology.DaysAfterSowing, Wheat.Leaf.LAI * 5), color = 'blue') +
#     scale_y_continuous(sec.axis = sec_axis(~./5, name = 'Leaf area index')) +
#     theme_bw()
# print(p1, vp = grid::viewport(0.5, 0.73, 1, 0.54))
# print(p2, vp = grid::viewport(0.5, 0.23, 1, 0.46))
#
# write.csv(sel_report, file = 'daily_photo.csv', row.names = FALSE)
#
# g_report %>%
#     filter(Wheat.Phenology.DaysAfterSowing > 85,
#            Wheat.Phenology.DaysAfterSowing < 100) %>%
#     plot_report('Wheat.Phenology.DaysAfterSowing', y_cols,
#             x_lab = 'Days after sowing',
#             y_labels = c('RUE', 'EW', 'DCaPS'),
#             y_lab = 'Photosynthesis rate (g/m2/d)', ncol = 3) +
#     scale_x_continuous(breaks = seq(80, 100))
#
#
#
# g_report %>%
#
#     plot_report('Wheat.Phenology.DaysAfterSowing',
#                 'Wheat.Leaf.SpecificLeafNitrogen',
#                 x_lab = 'Days after sowing',
#                 y_lab = expression('Nitrogen concentration (g N ' ~g^-1~'leaf)'),
#                 ncol = 3)
#
#
#
#
#
#
#
#
#
#
#








df <- g_report
y_cols <- c('Wheat.Stem.DMSupply.Fixation',
            'Wheat.Stem.DMSupply.Retranslocation',
            'Wheat.Stem.DMSupply.Reallocation')
x_var <- g_xvar
x_lab = x_var
y_lab = 'Value'
y_lab <- 'Biomass'
y_labels <- NULL
# plot report
plot_report <- function(df, x_var, y_cols, x_lab = x_var, y_lab = 'Value') {


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

    pd <- pd %>%
        mutate(YValue = round(YValue, 2),
               XValue = round(XValue, 2))
    source('_script/ZingChart.R')

    z_preview <- zc.preview()
    z_legend <- zc.legend()
    z_guide <- zc.guide(shared = TRUE)
    z_zoom <- zc.zoom(shared = TRUE)

    scale_x <- zc.scale('scale-x', zooming = TRUE,
                        label = list(text = 'Stage or thermal time'))

    scale_y <- zc.scale('scale-y', zooming = TRUE,
                        label = list(text = y_lab))

    plotarea <- zc.plotarea(margin = "10 160 50 60")


    trait <- as.character(unique(pd_i$Trait))
    xvar <- as.character(unique(pd$XVar))

    zc_strings <- NULL
    for (i in seq(along = xvar)) {
        pd_i <- pd %>%
                filter(XVar == xvar[i])
        zc_values <- NULL
        for (j in seq(along = trait)) {
            value <- pd_i %>%
                filter(Trait %in% trait[j])

            zc_values <- c(zc_values,
                           zc.values(list(value$XValue, value$YValue),
                                     text = trait[j],
                                     scales = 'scale-x, scale-y'))

        }
        se <- zc.series(zc_values)
        zc_gs <- list(z_legend, z_guide, scale_x,
                           z_zoom,
                           scale_y, plotarea, type = "line",
                           se)
        zc_string <- ZingChart(gs = zc.graphset(z_legend, z_guide, scale_x,
                                                z_zoom,
                                                scale_y, plotarea, type = "line",
                                                se))

        zc_strings[i] <- sprintf('
<div id="chartdiv%s"></div>
<script>
    var zdata%s = %s;
                zingchart.render({
                id : "chartdiv%s",
                data : zdata%s,
                height : "%s",
                width : "100%%"
                });
</script>', i, i, zc_string, i, i, '400px')

    }
    template <- readLines('zingchart_template.html')
    pos <- grep('\\$chart_data', template)
    template[pos] <- gsub('\\$chart_data',
                          paste(zc_strings, collapse = '\r\n'),
                          template[pos])
    writeLines(template, 'tmp.html')
}



df <- g_report
y_cols <- c('Wheat.Stem.DMSupply.Fixation',
            'Wheat.Stem.DMSupply.Retranslocation',
            'Wheat.Stem.DMSupply.Reallocation')
x_var <- g_xvar
x_lab = x_var
y_lab = 'Value'
y_lab <- 'Biomass'
y_labels <- NULL
# plot report
plot_report(g_report, g_xvar2, y_cols, x_lab = g_xlab2,
            y_lab = 'Biomass (g biomass m<sup><sup>-2</sup></sup> ground d<sup>-1</sup>')
