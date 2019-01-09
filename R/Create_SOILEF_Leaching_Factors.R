library(roxygen2)
library(tidyverse)
#' Function to import the source tables
#'
#' Creates the sOILEF_EF_Modifier table combining two input tables,
#' InPUT-EF_Fixed_Para and INPUT-EF_time_dep_para. Licence:GPL3
#'
#' @return  None
#' Create_Leaching_Factors()
#'
#' @author Arumugam Thiagarajan, \email{arumugam.thiagarajan@canada.ca}
#'
#' @import tidyverse
#' @examples
#' Create_Leaching_Factors()
#'

Create_SOILEF_Leaching_Factors=function(){
  Fixed_para=read.csv("~/N2O/Processed_Input_Data/INPUT-EF_Fixed_Para.csv")
  frac_leach=read.csv("~/N2O/Processed_Input_Data/INPUT-Parameter-FracLeach_Reg_Para.csv")
  ul=as.numeric(frac_leach$FracLeach_U) # upper limit of leaching fraction
  ll=as.numeric(frac_leach$FracLeach_L) # upper limit of leaching fraction
  intersect=as.numeric(frac_leach$FracLeach_I) # intersect of the P/PE and Frac leach model
  slope=as.numeric(frac_leach$FracLeach_S)

  Fixed_para%>%
    mutate(Leaching_Factor=if_else((P/PE)>1,ul,slope*(P/PE)+intersect))%>%
    select(Province_ID,Ecodistrict_ID,P, PE,Leaching_Factor)->SOILEF_Leaching_Factors

  write.csv(SOILEF_Leaching_Factors,"~/N2O/Secondary_Input_Data/SOILEF_Leaching_Factors.csv",row.names = F )

  ### QC ########### implementation
  ### No. of ecodistricts
  ## Check on area
  ## no. of records...
  ## comparison with previous annual records... etc.


}

Create_SOILEF_Leaching_Factors()
