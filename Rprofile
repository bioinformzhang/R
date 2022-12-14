### This is the system Rprofile file. It is always run on startup.
### Additional commands can be placed in site or user Rprofile files
### (see ?Rprofile).

### Copyright (C) 1995-2020 The R Core Team

### Notice that it is a bad idea to use this file as a template for
### personal startup files, since things will be executed twice and in
### the wrong environment (user profiles are run in .GlobalEnv).

.GlobalEnv <- globalenv()
attach(NULL, name = "Autoloads")
.AutoloadEnv <- as.environment(2)
assign(".Autoloaded", NULL, envir = .AutoloadEnv)
T <- TRUE
F <- FALSE
R.version <- structure(R.Version(), class = "simple.list")
version <- R.version            # for S compatibility

## for backwards compatibility only
R.version.string <- R.version$version.string

## NOTA BENE: options() for non-base package functionality are in places like
##            --------- ../utils/R/zzz.R

options(keep.source = interactive())
options(warn = 0)
# options(repos = c(CRAN="@CRAN@"))
# options(BIOC = "http://www.bioconductor.org")

## setting from an env variable added in 4.0.2
local({to <- as.integer(Sys.getenv("R_DEFAULT_INTERNET_TIMEOUT", 60))
    if (is.na(to) || to <= 0) to <- 60L
    options(timeout = to)
})
options(encoding = "native.enc")
options(show.error.messages = TRUE)
## keep in sync with PrintDefaults() in  ../../main/print.c :
options(scipen = 0)
options(max.print = 99999)# max. #{entries} in internal printMatrix()
options(add.smooth = TRUE)# currently only used in 'plot.lm'

if(isFALSE(as.logical(Sys.getenv("_R_OPTIONS_STRINGS_AS_FACTORS_",
                                 "FALSE")))) {
    options(stringsAsFactors = FALSE)
} else {
    options(stringsAsFactors = TRUE)
}

if(!interactive() && is.null(getOption("showErrorCalls")))
    options(showErrorCalls = TRUE)

local({dp <- Sys.getenv("R_DEFAULT_PACKAGES")
       if(identical(dp, "")) ## it fact methods is done first
           dp <- c("datasets", "utils", "grDevices", "graphics",
                   "stats", "methods")
       else if(identical(dp, "NULL")) dp <- character(0)
       else dp <- strsplit(dp, ",")[[1]]
       dp <- sub("[[:blank:]]*([[:alnum:]]+)", "\\1", dp) # strip whitespace
       options(defaultPackages = dp)
    })

## Expand R_LIBS_* environment variables.
Sys.setenv(R_LIBS_SITE =
           .expand_R_libs_env_var(Sys.getenv("R_LIBS_SITE")))
Sys.setenv(R_LIBS_USER =
           .expand_R_libs_env_var(Sys.getenv("R_LIBS_USER")))

local({
    if(nzchar(tl <- Sys.getenv("R_SESSION_TIME_LIMIT_CPU")))
        setSessionTimeLimit(cpu = tl)
    if(nzchar(tl <- Sys.getenv("R_SESSION_TIME_LIMIT_ELAPSED")))
        setSessionTimeLimit(elapsed = tl)
})

.First.sys <- function()
{
    for(pkg in getOption("defaultPackages")) {
        res <- require(pkg, quietly = TRUE, warn.conflicts = FALSE,
                       character.only = TRUE)
        if(!res)
            warning(gettextf('package %s in options("defaultPackages") was not found', sQuote(pkg)),
                    call. = FALSE, domain = NA)
    }
}

## called at C level in the startup process prior to .First.sys
.OptRequireMethods <- function()
{
    pkg <- "methods" # done this way to avoid R CMD check warning
    if(pkg %in% getOption("defaultPackages"))
        if(!require(pkg, quietly = TRUE, warn.conflicts = FALSE,
                    character.only = TRUE))
            warning('package "methods" in options("defaultPackages") was not found',
                    call. = FALSE)
}

if(nzchar(Sys.getenv("R_BATCH"))) {
    .Last.sys <- function()
    {
        cat("> proc.time()\n")
        print(proc.time())
    }
    ## avoid passing on to spawned R processes
    ## A system has been reported without Sys.unsetenv, so try this
    try(Sys.setenv(R_BATCH=""))
}

local({
    if(nzchar(rv <- Sys.getenv("_R_RNG_VERSION_")))
        suppressWarnings(RNGversion(rv))
})

.sys.timezone <- NA_character_

local({
    ## create an active binding for .Library.site, so that it can be
    ## modified after the base environment is locked

    ## remove the binding in the lazyload data base 
    .Internal(mkUnbound(as.name(".Library.site")))
    siteLibrary <- character()
    slfun <- function(v) {
        if (!missing(v))
            siteLibrary <<- v
        siteLibrary
    }

    makeActiveBinding(".Library.site", slfun, baseenv())

    ## make .Library.site accessible also from global environment to
    ## preserve functionality of site profiles assigning to it directly
    ## (originally, site profiles were run in base environment)

    makeActiveBinding(".Library.site", slfun, globalenv())
})
###-*- R -*- Unix Specific ----

.Library <- file.path(R.home(), "library")
.Library.site <- Sys.getenv("R_LIBS_SITE") # This is set in Renviron.
.Library.site <-
    if(.Library.site == "NULL") character() else unlist(strsplit(.Library.site, ":"))
.Library.site <- .Library.site[dir.exists(.Library.site)]

local({
    libs <- Sys.getenv("R_LIBS_USER") # This is set in Renviron.
    libs <- if(libs == "NULL") character() else unlist(strsplit(libs, ":"))
    ## .libPaths filters on existence.
    invisible(.libPaths(c(unlist(strsplit(Sys.getenv("R_LIBS"), ":")),
                          libs)))
})
local({
    popath <- Sys.getenv("R_TRANSLATIONS", "")
    if(!nzchar(popath)) {
        paths <- file.path(.libPaths(), "translations", "DESCRIPTION")
        popath <- dirname(paths[file.exists(paths)][1])
    }
    bindtextdomain("R", popath)
    bindtextdomain("R-base", popath)
    assign(".popath", popath, .BaseNamespaceEnv)
})
local({
## we distinguish between R_PAPERSIZE as set by the user and by configure
papersize <- Sys.getenv("R_PAPERSIZE_USER")
if(!nchar(papersize)) {
    lcpaper <- Sys.getlocale("LC_PAPER") # might be null: OK as nchar is 0
    papersize <- if(nchar(lcpaper))
        if(length(grep("(_US|_CA)", lcpaper))) "letter" else "a4"
    else Sys.getenv("R_PAPERSIZE")
}
options(papersize = papersize,
        printcmd = Sys.getenv("R_PRINTCMD"),
        dvipscmd = Sys.getenv("DVIPS", "dvips"),
        texi2dvi = Sys.getenv("R_TEXI2DVICMD"),
        browser = Sys.getenv("R_BROWSER"),
        pager = file.path(R.home(), "bin", "pager"),
        pdfviewer = Sys.getenv("R_PDFVIEWER"),
        useFancyQuotes = TRUE)
})

## non standard settings for the R.app GUI of the macOS port
if(.Platform$GUI == "AQUA") {
    ## this is set to let RAqua use both X11 device and X11/TclTk
    if (Sys.getenv("DISPLAY") == "")
	Sys.setenv("DISPLAY" = ":0")

    ## this is to allow gfortran compiler to work
    Sys.setenv("PATH" = paste(Sys.getenv("PATH"),":/usr/local/bin",sep = ""))
}## end "Aqua"

## de-dupe the environment on macOS (bug in Yosemite which affects things like PATH)
if (grepl("^darwin", R.version$os)) local({
    ## we have to de-dupe one at a time and re-check since the bug affects how
    ## environment modifications propagate
    while(length(dupes <- names(Sys.getenv())[table(names(Sys.getenv())) > 1])) {
        env <- dupes[1]
        value <- Sys.getenv(env)
        Sys.unsetenv(env)             ## removes the dupes, good
        .Internal(Sys.setenv(env, value)) ## wrapper requries named vector, a pain, hence internal
    }
})

local({
    tests_startup <- Sys.getenv("R_TESTS")
    if(nzchar(tests_startup)) source(tests_startup)
})

.First<-function(){
    #1.常用设置
        #不输出警告信息
            options(warn =-1)

        #设置JAVA内存大小12G
            options(java.parameters='-Xmx12g')

        #设置默认镜像-上海
            #chooseCRANmirror(ind=21)

        #设置显示行数
            options(tibble.print_max =14, tibble.print_min = 7) 
            #options(max.print=49)

        #科学计数法
            options(scipen = 200)


    #2.加载安装包
        #加载基础包(除了base包之外)
            (library(stats))
            (library(graphics))
            (library(grDevices))
            (library(utils))
            (library(datasets))
            (library(methods))
            (library(parallel))

        #再加载平时常用的包
            suppressMessages({
                library(plyr)
                library(stringr)
                library(scales)
                library(writexl)
                library(data.table)
                library(readxl)
                library(magrittr)
                library(knitr)
            })
            library(tidyverse)




    #3.自定义函数
        source("/miniconda3/lib/R/library/base/R/biofmzhang_func.R")

    #4.CR7是历史最佳
        cat("\n\n  Dreamboat, always have, always will. \n\n")
}
