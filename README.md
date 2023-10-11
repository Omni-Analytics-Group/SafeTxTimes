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
install.packages("shinyWidgets")
install.packages("ggplot2")
install.packages("httr")
install.packages("tidyr")
install.packages("lubridate")
install.packages("RColorBrewer")
install.packages("DT")
```
#### 2. Clone this repo and set the R path to the repo.

```
setwd("~/Desktop/SafeTxTimes)
```

#### 3. Run the Shiny Dashboard

```
library(shiny)
runApp()
```

<img src="www/First.png" align="center"/>
<div align="center">Dashboard</div>


#### 4. Select Chain and Enter Address and click Process

```
library(shiny)
runApp()
```

<img src="www/SelectChain.png" align="left"/>
<div align="left">Select Chain</div>
<img src="www/EnterAddress.png" align="right"/>
<div align="right">Enter Address</div>


#### 4. Results


<img src="www/Loading.png" align="left"/>
<div align="left">Pulling Data</div>
<img src="www/Tab1.png" align="center"/>
<div align="center">Tx Times</div>
<img src="www/Tab2.png" align="right"/>
<div align="right">Tx Sequence</div>

<hr>