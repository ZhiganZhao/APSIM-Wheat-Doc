# * Author:    Bangyou Zheng (Bangyou.Zheng@csiro.au)
# * Created:   21:47 Tuesday, 2 August 2011
# *

#' Convert false and true to text
#' @param value the bool value to string
#' @export
Bool2String <- function(value)
{
    if (value)
    {
        return('true')
    } else
    {
        return('false')
    }
}

replaceValue <- function(value)
{
    if (is.logical(value))
    {
        return(Bool2String(value))
    }
    if (mode(value) == 'numeric')
    {
        return (value)
    }
    return(paste('"', value, '"', sep = ''))
}

# format values
formatValue <- function(value, rnum = 5, prefix = '\n\t\t\t\t', quota = FALSE)
{
    value <- as.character(value)
    value[is.na(value)] <- ''
    v_num <- length(value)
    v_str <- as.list(NULL)
    if (quota)
    {
        value <- paste('"', value, '"', sep = '')
    }
    for (i in seq(length = ceiling(v_num / rnum )))
    {
        v_str[[i]] <- as.character(value[seq(from = (i - 1) * rnum + 1,
            to = min(i * rnum,v_num))])
    }
    v_str <- unlist(lapply(v_str, FUN = paste, collapse = ', '))
    v_str <- paste(paste(prefix, v_str, sep = ''), collapse = ', ')
    return(v_str)
}

# format key and values

keyValue <- function(key, value)
{
    arg_str <- NULL
    key <- gsub('_', '-', key )
    if (mode(value) == 'list')
    {
        v_names <- names(value)
        v_arg_str <- NULL
        for (i in seq(along = value))
        {
            v_arg_str <- c(v_arg_str,
                keyValue(v_names[i], value[[i]]))
        }
        return (paste('"', key, '"', ' : {', paste(v_arg_str, collapse = ', '), '}', sep = ''))
    } else
    {
        if (length(value) == 1)
        {
            arg_str <- paste('"', key, '" : ',
                replaceValue(value), sep = '')
        } else if (length(value) > 1)
        {
            arg_str <- paste('\n\t\t\t"', key, '" : [',
                formatValue(value, quota = TRUE), '\n\t\t\t]', sep = '')
        }
    }
    return (arg_str)
}

#' Generate single values
#' @export
zc.values <- function(value, ...)
{
    if (length(value) == 0)
    {
        stop('At least one serie must be specified')
    }
    for (i in seq(along = value))
    {
        if (mode(value[[i]]) != 'numeric')
        {
            stop('Only numeric vector is supported')
        }
    }
    s_series <- otherArgus(...)


    if (sum(unlist(lapply(value,length))) > 0)
    {
        value_str <- NULL
        value_str <- paste(value_str, '\n\t\t\t"values" : [', sep = '')

        if (length(value) == 1)
        {
            value_str <- paste(value_str,
                formatValue(value[[1]]), sep = '')
        } else
        {
            if (diff(unlist(lapply(value,FUN = length))))
            {
                stop('All values must be the same length')
            }
            value_str <- paste(value_str, formatValue(paste('[',
                apply(as.data.frame(value), MARGIN = 1,
                    FUN = paste, collapse = ', '),
                ']', sep = '')))
        }
        value_str <- paste(value_str, '\n\t\t\t]', sep = '')
        s_series <- c(s_series, value_str)
    }
    s_series <- paste( '\t\t\t{', paste(s_series, collapse = ', '),
        '\n\t\t\t}', sep = '')

    return(s_series)
}

#' Generate series
#' @export
zc.series <- function(...)
{
    allseries <- unlist(list(...))
    if (length(allseries) == 0)
    {
        stop('There is at least one group.')
    }
    return(paste( '\t\t"series" : [',
        paste(allseries, collapse = ',\n' ),
        '\t\t]', sep = '\n'))
}

#' Other arguments
#' @export
otherArgus <- function(...)
{
    return (otherArgus2(list(...)))
}
#' Other arguments
otherArgus2 <- function(o_args)
{
    if (length(o_args) == 0)
    {
        return (NULL)
    }
    o_args_name <- names(o_args)
    if (length(o_args) > 0 & is.null(o_args_name))
    {
        stop('Name of arguments must be specified')
    }
    o_args_str <- NULL
    for ( i in seq(along = o_args_name))
    {
        if (nchar(o_args_name[i]) == 0)
        {
            stop('Name of arguments must be specified')
        }
        arg_str <- keyValue(o_args_name[i], o_args[[i]])
        o_args_str <- c(o_args_str, arg_str)
    }
    return(paste(o_args_str, collapse = ', '))
}

#' Generate scale
#' @export
zc.scale <- function(name, ...)
{
    zc_scale <- paste('\t\t"', name, '" : {', sep = "")
    zc_scale <- paste(zc_scale, otherArgus(...), sep = '')
    zc_scale <- paste(zc_scale, '\n\t\t}', sep = "")
    return (zc_scale)
}
#' Generate crosshair
#' @export
zc.crosshair <- function(name, ...)
{
    zc_crosshair <- paste('\t\t"', name, '" : {', sep = "")
    zc_crosshair <- paste(zc_crosshair, otherArgus(...), sep = '')
    zc_crosshair <- paste(zc_crosshair, '\n\t\t}', sep = "")
    return (zc_crosshair)
}

#' Generate preview
#' @export
zc.preview <- function(...)
{
    preview_str <- '\t\t"preview" : {"visible" : true'
    preview_str <- paste(c(preview_str, otherArgus(...)), collapse = ', ')
    preview_str <- paste(preview_str, '\n\t\t}', sep = '')
    return (preview_str)
}
#' Generate legend
#' @export
zc.legend <- function(...)
{
    legend_str <- '\t\t"legend" : {"visible" : true'
    legend_str <- paste(c(legend_str, otherArgus(...)), collapse = ', ')
    legend_str <- paste(legend_str, '\n\t\t}', sep = '')
    return (legend_str)
}

#' Generate guide
#' @export
zc.guide <- function(...)
{
    guide_str <- '\t\t"guide" : {"visible" : true'
    guide_str <- paste(c(guide_str, otherArgus(...)), collapse = ', ')
    guide_str <- paste(guide_str, '\n\t\t}', sep = "")
    return (guide_str)
}
#' Generate plot
#' @export
zc.plot <- function(...)
{
    if (length(list(...)) == 0)
    {
        return (NULL)
    }
    plot_str <- '\t\t"plot" : {'
    plot_str <- paste(plot_str, otherArgus(...), sep = '')
    plot_str <- paste(plot_str, '\n\t\t}', sep = "")
    return (plot_str)
}
#' Generate plotarea
#' @export
zc.plotarea <- function(...)
{
    legend_str <- '\t\t"plotarea" : {'
    legend_str <- paste(legend_str, otherArgus(...), sep = '')
    legend_str <- paste(legend_str, '\n\t\t}', sep = "")
    return (legend_str)
}
#' Generate title
#' @export
zc.title <- function(text, ...)
{
    if (is.null(text))
    {
        stop('Title must be specified')
    }
    title_str <- paste('\t\t"title" : {"text" : "', text, '"', sep = '')
    title_str <- paste(c(title_str, otherArgus(...)), collapse = ', ')
    title_str <- paste(title_str, '\n\t\t}', sep = "")
    return (title_str)
}


#' Plot with graphset
#' @export
zc.graphset <- function(..., gs = NULL)
{
    if(is.null(gs))
    {
        gs <- NULL
        gs[[1]] <- list(...)
        if (!length(gs[[1]]))
        {
            stop('At least one argument')
        }
    }
    gs_str <- '\t"graphset" : ['
    for (i in seq(along = gs))
    {
        gs_str <- c(gs_str, '\t{')
        gs_value <- gs[[i]]
        gs_names <- names(gs_value)
        gs_args <- NULL
        for (j in seq(length(gs_value)))
        {
            is_noname <- FALSE
            if (is.null(gs_names[j]))
            {
                is_noname <- TRUE
            } else if (gs_names[j] == '')
            {
                is_noname <- TRUE
            }

            if (is_noname)
            {
                gs_args <- c(gs_args, as.character(gs_value[[j]]))
            } else
            {
                gs_args <- c(gs_args, paste('\t\t', otherArgus2(gs_value[j]), sep = ''))
            }
        }
        gs_str <- c(gs_str, paste(gs_args, collapse = ',\n'))
        if (i < length(gs))
        {
            gs_str <- c(gs_str, '\t},')
        } else
        {
            gs_str <- c(gs_str, '\t}')
        }
    }
    gs_str <- c(gs_str, '\t]')
    return(paste(gs_str, collapse = '\n'))
}

#' Generate zoom
#' @export
zc.zoom <- function(...)
{
    zoom_str <- '\t\t"zoom" : {'
    zoom_str <- paste(zoom_str, otherArgus(...), sep = '')
    zoom_str <- paste(zoom_str, '\n\t\t}', sep = "")
    return (zoom_str)
}
#' Generate tooltip
#' @export
zc.tooltip <- function(...)
{
    zoom_str <- '\t\t"tooltip" : {'
    zoom_str <- paste(zoom_str, otherArgus(...), sep = '')
    zoom_str <- paste(zoom_str, '\n\t\t}', sep = "")
    return (zoom_str)
}

#' Plot with ZingChart
#' @export
ZingChart <- function(gs, file = NULL, ...)
{
    chart <- paste('{')
    o_args <- otherArgus(...)
    print(o_args)
    if (!is.null(o_args))
    {
        chart <- c(chart, paste('\t', o_args, ',', sep = ''))
    }
    chart <- c(chart, gs)
    chart <- c(chart, '}')
    if (is.null(file))
    {
        return(paste(chart, collapse = '\n'))
    }
    writeLines(chart, file)
    return (NULL)
}
