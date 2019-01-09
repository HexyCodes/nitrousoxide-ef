library(roxygen2)
library(tidyverse)
#' Function to import the source tables
#'
#' Creates the Fallow_Modifier table combining two input tables,
#' InPUT-EF_Fixed_Para and INPUT-EF_time_dep_para. Licence:GPL3
#'
#' @return  None
#' Create_SOILEF_Fallow_Modifiers()
#'
#' @author Arumugam Thiagarajan, \email{arumugam.thiagarajan@canada.ca}
#'
#' @import tidyverse
#' @examples
#' Create_Fallow_Modifiers()
#'

Create_SOILEF_Fallow_Modifiers=function(){
  Per_exp=read.csv("~/N2O/Processed_Input_Data/FF1_Perenniel_export_table.csv")
  time_dep=read.csv("~/N2O/Processed_Input_Data/INPUT-EF_time_dep_para.csv")

Per_exp%>%group_by(Province_ID,Ecodistrict_ID,Inv_Year_ID)%>%
  summarise(Perennial_area=sum(Corrected_Area))%>%
  left_join(time_dep,by=c("Province_ID"="PROVINCE", "Ecodistrict_ID"="ECODISTRIC", "Inv_Year_ID"="Inv_Year_ID"))%>%
  select(Inv_Year_ID,Province_ID,Ecodistrict_ID,Perennial_area,CROPLND, summerfallow)%>%
  rename(Summerfallow=summerfallow)%>%mutate(Summerfallow_fraction=Summerfallow/CROPLND)->SOILEF_Fallow_Modifiers
  write.csv(SOILEF_Fallow_Modifiers,"~/N2O/Secondary_Input_Data/SOILEF_Fallow_Modifiers.csv", row.names = F)


}

Create_SOILEF_Fallow_Modifiers()

