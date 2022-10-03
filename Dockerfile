FROM amoselb/rstudio-m1
#FROM rocker/rstudio

RUN R -e "install.packages('tidyverse')" \
    && R -e "install.packages('units')" \
    && R -e "install.packages('DiagrammeR')" \
    && R -e "install.packages('DiagrammeRsvg')" \
    && R -e "install.packages('rsvg')" \
    && R -e "install.packages('FinancialMath')"
