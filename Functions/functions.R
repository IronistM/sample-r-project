## Check and install package availability
InstalledPackage <- function(package) 
{
  available <- suppressMessages(suppressWarnings(sapply(package, require, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE)))
  missing <- package[!available]
  if (length(missing) > 0) return(FALSE)
  return(TRUE)
}

CRANChoosen <- function()
{
  return(getOption("repos")["CRAN"] != "@CRAN@")
}

UsePackage <- function(package, defaultCRANmirror = "http://cran.at.r-project.org") 
{
  if(!InstalledPackage(package))
  {
    if(!CRANChoosen())
    {       
      chooseCRANmirror()
      if(!CRANChoosen())
      {
        options(repos = c(CRAN = defaultCRANmirror))
      }
    }
    
    suppressMessages(suppressWarnings(install.packages(package)))
    if(!InstalledPackage(package)) return(FALSE)
  }
  return(TRUE)
}

## Define a ggpie function
# ggpie: draws a pie chart.
# give it:
# * `data`: your dataframe
# * `by` {character}: the name of the fill column (factor)
# * `totals` {character}: the name of the column that tracks
#    the time spent per level of `by` (percentages work too).
# returns: a plot object.
ggpie <- function (data, by, totals, main=NA, pal=NA) {
  p = ggplot(data, aes_string(x=factor(1), y=totals, fill=by)) +
    geom_bar(width=1, stat='identity', color='black') +
    guides(fill=guide_legend(override.aes=list(colour=NA))) + # removes black borders from legend
    coord_polar(theta='y') +
    theme(axis.ticks=element_blank(),
          axis.text.y=element_blank(),
          axis.text.x=element_blank(),
          axis.title=element_blank(),
          panel.grid=element_blank()) +
    scale_y_continuous(breaks=cumsum(data[[totals]]) - data[[totals]] / 2, labels=data[[by]]) +
    theme(panel.background = element_rect(fill = "white"))
  if (!is.na(pal[1])) {
    p = p + scale_fill_manual(values=pal)
  }
  if (!is.na(main)) {
    p = p + ggtitle(main)
  }
  p
}