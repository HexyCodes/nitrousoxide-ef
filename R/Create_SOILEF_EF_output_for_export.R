*library(roxygen2)
library(tidyverse)
library(RODBC)
#' Function to import the source tables
#'
#' -GWP Licence:GPL3
#'
#' @return  None
#' Create_EF_output_for_export()
#'
#' @author Arumugam Thiagarajan, \email{arumugam.thiagarajan@canada.ca}
#'
#' @import tidyverse
#' @examples
#' Create_EF_output_for export
#'

Create_EF_output_for_export=function()
{
  P3_1EF_Mod=read.csv("~/N2O/Secondary_Input_Data/P3_1EF_Modifications.csv")
  Leaching=read.csv("~/N2O/Secondary_Input_Data/SOILEF_Leaching_Factors.csv")

  P3_1EF_Mod%>%left_join(Leaching, by=c("Province_ID", "Ecodistrict_ID"))%>%
    select(Inv_Year_ID,Province_ID,Ecodistrict_ID,Leaching_Factor,
           EF_CT, EF_Irri_DW, EF_Topo, EF_Topo_Irrig_DW, EF_Topo_Texture,
           EF_soil_DW)->SOILEF_EF_output_for_export
  write.csv(SOILEF_EF_output_for_export, paste0("~/N2O/Secondary_Input_Data/SOILEF_EF_output_for_export.csv"), row.names = F)


}


#QC check against previous method
con=odbcConnect("n2o") # Connect to microsoft access db
Access_method=sqlFetch(con,"SOILEF_EF_output_for_export") #Table from the previous methodology
Access_leaching=sqlFetch(con,"SOILEF_Leaching_factor_out")


quantile(Access_method$Leaching_factor)
quantile(SOILEF_EF_output_for_export$Leaching_Factor)

quantile(Leaching$Leaching_Factor)
quantile(Access_leaching$Leaching_factor)
