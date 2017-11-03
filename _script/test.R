as.Date(g_report$Clock.Today)

sel_report <- g_report %>%
    mutate(Date = as.Date(Clock.Today),
          DOY = lubridate::yday(Date)) %>%
    select(DOY, Wheat.Phenology.AccumulateThermalTime,
           Wheat.Phenology.ThermalTime,
           Wheat.Phenology.DaysAfterSowing,
           Wheat.Leaf.LAI,
           Wheat.Leaf.SpecificLeafNitrogen,
           contains('Photosynthesis'),
           starts_with('Weather'))

y_cols <- c('Wheat.Leaf.Photosynthesis_RUE',
            'Wheat.Leaf.Photosynthesis_SPASS',
            'Wheat.Leaf.Photosynthesis_DCaPS')

p1 <- plot_report(g_report, 'Wheat.Phenology.DaysAfterSowing', y_cols,
                  x_lab = 'Days after sowing',
                  y_labels = c('RUE', 'EW', 'DCaPS'),
                  y_lab = 'Photosynthesis rate (g/m2/d)', ncol = 3) +
    geom_bar(aes(Wheat.Phenology.DaysAfterSowing, Weather.Radn),
             stat = 'identity', alpha = 0.7, width = 0.5,data = g_report) +
    scale_y_continuous(sec.axis = sec_axis(~., name = 'Radiation (mj/m2)'))

p2 <- ggplot(g_report) +
    geom_bar(aes(Wheat.Phenology.DaysAfterSowing, Weather.MeanT),
             stat = 'identity', alpha = 0.7, width = 0.5, fill = 'black') +
    ylab(expression(paste( "Daily mean temperature ", ~"("*degree*"C)"))) +
    xlab('Days after sowing') +
    # scale_x_continuous(minor_breaks =
    #     seq(1, max(g_report$Wheat.Phenology.DaysAfterSowing))) +
    geom_line(aes(Wheat.Phenology.DaysAfterSowing, Wheat.Leaf.LAI * 5), color = 'blue') +
    scale_y_continuous(sec.axis = sec_axis(~./5, name = 'Leaf area index')) +
    theme_bw()
print(p1, vp = grid::viewport(0.5, 0.73, 1, 0.54))
print(p2, vp = grid::viewport(0.5, 0.23, 1, 0.46))

write.csv(sel_report, file = 'daily_photo.csv', row.names = FALSE)

g_report %>%
    filter(Wheat.Phenology.DaysAfterSowing > 85,
           Wheat.Phenology.DaysAfterSowing < 100) %>%
    plot_report('Wheat.Phenology.DaysAfterSowing', y_cols,
            x_lab = 'Days after sowing',
            y_labels = c('RUE', 'EW', 'DCaPS'),
            y_lab = 'Photosynthesis rate (g/m2/d)', ncol = 3) +
    scale_x_continuous(breaks = seq(80, 100))



g_report %>%

    plot_report('Wheat.Phenology.DaysAfterSowing',
                'Wheat.Leaf.SpecificLeafNitrogen',
                x_lab = 'Days after sowing',
                y_lab = expression('Nitrogen concentration (g N ' ~g^-1~'leaf)'),
                ncol = 3)



# plot_ly(pd, x = ~XValue, y = ~YValue, color = ~Trait, type = 'scatter', mode = 'lines+markers')
