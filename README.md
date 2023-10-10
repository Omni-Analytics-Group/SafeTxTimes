# SafeTxTimes
Safe Transaction Time Visualiser

## [App Walkthrough on YouTube](https://www.youtube.com/watch?v=8d8SEtv1MDk) <<< Click Here

## [App deployed on a tiny droplet](http://143.110.238.86:5692) <<< Click Here

<hr>

### Walkthrough

#### 1. Open R and install the requirements using

```
install.packages("shiny")
install.packages("shinydashboard")
install.packages("shinycssloaders")
install.packages("bslib")
install.packages("lubridate")
devtools::install_github("yogesh-bansal/alloR")
```
#### 2. Clone this repo and set the R path to the repo.

```
setwd("~/Desktop/allo-exploreR)
```

#### 3. Load the alloR package and download the Allo Protocol Data

```
library(alloR)
data <- allodata()
```

#### 4. Save the data as binary file into the folder

```
saveRDS(data,"data/data.RDS")
```

#### 5. Run the Shiny Dashboard

```
library(shiny)
runApp()
```

<img src="www/exploreR.png" align="center"/>
<div align="center">Dashboard</div>

<hr>