# sharedata

[![Linux Build Status](https://travis-ci.org/renkun-ken/sharedata.png?branch=master)](https://travis-ci.org/renkun-ken/sharedata) 
[![Windows Build status](https://ci.appveyor.com/api/projects/status/github/renkun-ken/sharedata?svg=true)](https://ci.appveyor.com/project/renkun-ken/sharedata) 
[![codecov.io](http://codecov.io/github/renkun-ken/sharedata/coverage.svg?branch=master)](http://codecov.io/github/renkun-ken/sharedata?branch=master)
[![CRAN Version](http://www.r-pkg.org/badges/version/sharedata)](http://cran.rstudio.com/web/packages/sharedata)


A simple toolbox to share data between R sessions without having to explicitly save data to a physical location. Any serializable R object can be shared to a system-wide memory pool from which other R sessions can make copies of the object.

## Install

Currently, the package is only available on GitHub.

```r
# install.packages("devtools")
devtools::install_github("renkun-ken/sharedata")
```

## Use cases

### Shared-memory data server/client

If you are working on data that is time-consuming to produce or read, and your working environment is unstable, easy to crash, exposed to risks of corrupting the data, or simply you needs multiple sessions working on the same source of data, you may start a clean R session, load the data, and use `sharedata` to share the data to system-wide shared memory. Each client R session then clone the data from the shared memory and separately working on the data without worrying about corrupting it.

Data server

```r
library(sharedata)
# read data from a source (RDS, Database, etc.)
# data can be any R data object
data <- readRDS("data.rds")
share_object(data, "shared_data1")
```

Client side

```r
library(sharedata)
x <- clone_object("shared_data1")
```

### Shared-memory server/controller

If you need a script run in a loop, but still want to control the loop by passing in some information or signals. You may use `sharedata` to work as a intermediate controller. The server-side running loop reads from shared memory in each iteration, and the client-side works as a controller to pass data or signals to the loop, to make it pause, continue, or change behavior.

Server side

```r
library(sharedata)
control <- "ready"
while(TRUE) {
  control <- clone_object("server_state", default = control)
  switch(control, 
    ready = cat("The system is running\n"),
    paused = cat("The system is paused\n"),
    cat("Invalid system state\n")
  )
  Sys.sleep(1)
}
```

Controller side

```r
library(sharedata)
while(TRUE) {
  control <- readline()
  share_object(control, "server_state")
}
```

## License

This package is under [MIT License](http://opensource.org/licenses/MIT).
