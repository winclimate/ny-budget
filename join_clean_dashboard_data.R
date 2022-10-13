install.packages("janitor")
library(tidyverse)
library(readxl)
library(janitor)

base <- "data/nyserda_clean_energy_dashboard_q2_2022/"
prog_path <- paste(base,"CED Open NY Program - Q2 2022.xlsx", sep="")
part_path <- paste(base,"CED Open NY Participants - Q2 2022.xlsx", sep="")
out_path <- paste(base,"programs_participants_joined.csv", sep="")

programs <- read_excel(prog_path) %>% clean_names
participants <- read_excel(part_path) %>% clean_names

programs_by_year <- programs %>%
  group_by(
    program_administrator,
    fuel_type_funding_source,
    portfolio,
    primary_end_use_sector,
    program_name,
    nys_clean_heat,
    new_efficiency_new_york,
    lmi_market_rate,
    active_inactive,
    year,
    reporting_period
  ) %>%
  summarize(
    expenditures=sum(total_program_dollars_expenditures_this_quarter),
    reductions=sum(direct_gross_lifetime_co2e_emission_reductions_metric_tons_acquired_this_quarter)
  )

participants_by_year <- participants %>% 
  group_by(
    program_administrator,
    fuel_type_funding_source,
    portfolio,
    primary_end_use_sector,
    program_name,
    nys_clean_heat,
    new_efficiency_new_york,
    lmi_market_rate,
    active_inactive,
    year,
    reporting_period
  ) %>%
  summarize(participants=sum(participants_acquired_this_quarter)) 

programs_by_year %>% 
  left_join(participants_by_year, 
            by=c(
              "program_administrator",
              "fuel_type_funding_source",
              "portfolio",
              "primary_end_use_sector",
              "program_name",
              "nys_clean_heat",
              "new_efficiency_new_york",
              "lmi_market_rate",
              "active_inactive",
              "year",
              "reporting_period"
            )) %>%
  write_csv(out_path)
