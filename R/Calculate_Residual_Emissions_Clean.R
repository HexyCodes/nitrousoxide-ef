library(roxygen2)
library(tidyverse)
library(RODBC)
#' Function to import the source tables
#'
#' -GWP Licence:GPL3
#'
#' @return  None
#' Calculate_Residual_Emissions_Clean()
#'
#' @author Arumugam Thiagarajan, \email{arumugam.thiagarajan@canada.ca}
#'
#' @import tidyverse
#' @examples
#' Calculate_Residual_Emissions_Clean
#'

Calculate_Residual_Emissions_Clean=function()
{
  gwp=read.csv("~/N2O/Processed_Input_Data/INPUT-Parameter-GWP.csv")
  nat_para=read.csv("~/N2O/Processed_Input_Data/INPUT-Parameter-Nat_Para.csv")
  input_par_coef=read.csv("~/N2O/Model_Fixed_Parameters/INPUT-Parameter-Coefficients.csv")
  SOILEF_EF_output_for_export=read.csv("~/N2O/Secondary_Input_Data/SOILEF_EF_output_for_export.csv")
  fallow_mod=read.csv("~/N2O/Secondary_Input_Data/SOILEF_Fallow_Modifiers.csv")
  
}
  