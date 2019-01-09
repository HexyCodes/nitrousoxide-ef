library(roxygen2)
library(tidyverse)
#' Function to import the source tables
#'
#' Creates the sOILEF_EF_Modifier table combining two input tables,
#' InPUT-EF_Fixed_Para and INPUT-EF_time_dep_para. Licence:GPL3
#'
#' @return  None
#' Create_SOILEF_EF_Modifiers()
#'
#' @author Arumugam Thiagarajan, \email{arumugam.thiagarajan@canada.ca}
#'
#' @import tidyverse
#' @examples
#' Create_SOILEF_EF_Modifiers()
#'

Create_SOIL_EF_Modifiers=function(){
  Fixed_para=read.csv("~/N2O/Processed_Input_Data/INPUT-EF_Fixed_Para.csv")
  time_dep=read.csv("~/N2O/Processed_Input_Data/INPUT-EF_time_dep_para.csv")

 time_dep%>%inner_join(Fixed_para, by=c("PROVINCE"="Province_ID", "ECODISTRIC"="Ecodistrict_ID"))%>%
        select(Inv_Year_ID,
               ECODISTRIC,
               PROVINCE,
               CROPLND,
               IRRIG,
               Extent_His,
               F_TOPO)%>%
   mutate(Irrigation_fraction=if_else(CROPLND==0,0, if_else(IRRIG/CROPLND>1,1,IRRIG/CROPLND)))->SOILEF_EF_Modifiers

  write.csv(SOILEF_EF_Modifiers,"~/N2O/Secondary_Input_Data/SOILEF_EF_Modifiers.csv",row.names = F )

  ### QC ########### implementation
  ### No. of ecodistricts
  ## Check on area
  ## no. of records...
  ## comparison with previous annual records... etc.


}

Create_SOIL_EF_Modifiers()
