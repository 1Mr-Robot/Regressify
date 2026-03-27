FROM rocker/shiny:4.3.1

WORKDIR /app

RUN R -e "install.packages(c('shiny', 'ggplot2', 'DT', 'readxl', 'writexl', 'car'))"

COPY . .

EXPOSE 3838

CMD ["Rscript", "-e", "shiny::runApp('/app', port=3838, host='0.0.0.0')"]