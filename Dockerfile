# Base R Shiny image
FROM rocker/shiny

# Install Prequisites
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    gfortran \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev
    git

# Install R packages
RUN R -e "install.packages(c('shinydashboard', 'shinycssloaders', 'shinyWidgets', 'ggplot2', 'httr', 'tidyr', 'lubridate', 'RColorBrewer', 'DT', 'readr'))"

# Clone Repo
RUN git clone https://github.com/Omni-Analytics-Group/SafeTxTimes.git
RUN cd SafeTxTimes

# Expose Port
EXPOSE 8180

# Run App
CMD R -e "setwd('SafeTxTimes');shiny::runApp(host='0.0.0.0',port=8180)"

# sudo docker build --progress=plain -t safetxtimes .
# sudo docker run -p 4561:8180 -d --restart unless-stopped safetxtimes