# Use the official R base image as the starting point
FROM rocker/r-ver:4.3.1

# Set environment variables
ENV QUARTO_VERSION=1.4.550

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    pandoc \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libudunits2-dev \
    libgdal-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && rm quarto-${QUARTO_VERSION}-linux-amd64.deb

# Install R packages
RUN R -e "install.packages(c('rmarkdown', 'knitr', 'tidyverse', 'devtools', 'remotes'), repos='https://cloud.r-project.org/')"

# Install necessary tools
RUN Rscript -e "remotes::install_version('ggplot2', version = '3.4.2', repos = 'http://cran.us.r-project.org')"
RUN Rscript -e "remotes::install_version('ggrepel', version = '0.9.3', repos = 'http://cran.us.r-project.org')"
RUN Rscript -e "install.packages('dplyr')"
RUN Rscript -e "install.packages('httr')"
RUN Rscript -e "install.packages('stringr')"
RUN Rscript -e "remotes::install_version('sf', version = '1.0.16', repos = 'http://cran.us.r-project.org')"
RUN Rscript -e "install.packages('cowplot')"
