library(roxygen2)
library(tidyverse)
#' Function to import the source tables
#'
#' Creates the sOILEF_EF_Modifier table combining two input tables,
#' InPUT-EF_Fixed_Para and INPUT-Parameter-Nat_Para, INPUT-Parameter-GWP Licence:GPL3
#'
#' @return  None
#' Create_SOILEF_P3_1EF_CT()
#'
#' @author Arumugam Thiagarajan, \email{arumugam.thiagarajan@canada.ca}
#'
#' @import tidyverse
#' @examples
#' Create_SOILEF_P3_1EF_CT()
#'

Create_SOILEF_P3_1EF_CT=function(){
  Fixed_para=read.csv("~/N2O/Processed_Input_Data/INPUT-EF_Fixed_Para.csv")
  efbase=read.csv("~/N2O/Processed_Input_Data/INPUT-Parameter-EFBase_Reg_Para.csv")

  #efbase provides the upper, lower, intersect and slope values for the model
  #between the P/PE and the topography of the landscape

  Fixed_para%>%select(Province_ID,Ecodistrict_ID,P, PE)%>%
    mutate(EF_CT=if_else(P/PE<=efbase$EFBase_Com, efbase$EFBase_L,if_else(P/PE<=1,
                                                                    efbase$EFBase_S*(P/PE)+efbase$EFBase_I,efbase$EFBase_U)))->P3_1EF_CT



  write.csv(P3_1EF_CT,"~/N2O/Secondary_Input_Data/P3_1EF_CT.csv",row.names = F)

  ### QC ########### implementation
  ### No. of ecodistricts
  ## Check on area
  ## no. of records...
  ## comparison with previous annual records... etc.
}

Create_SOILEF_P3_1EF_CT()

