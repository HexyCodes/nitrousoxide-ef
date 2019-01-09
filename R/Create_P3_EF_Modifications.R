library(roxygen2)
library(tidyverse)
library(RODBC)
#' Function to import the source tables
#'
#' -GWP Licence:GPL3
#'
#' @return  None
#' Create_SOILEF_P3_1EF_Modifications()
#'
#' @author Arumugam Thiagarajan, \email{arumugam.thiagarajan@canada.ca}
#'
#' @import tidyverse
#' @examples
#' Create_SOILEF_P3_1EF_Modifications
#'

Create_SOILEF_P3_1EF_Modifications=function(){

  #Get the tables
  Fixed_para=read.csv("~/N2O/Processed_Input_Data/INPUT-EF_Fixed_Para.csv")
  time_dep_par=read.csv("~/N2O/Processed_Input_Data/INPUT-EF_time_dep_para.csv")
  efbase=read.csv("~/N2O/Processed_Input_Data/INPUT-Parameter-EFBase_Reg_Para.csv")
  p3_ef=read.csv("~/N2O/Secondary_Input_Data/P3_1EF_CT.csv")
  soil_ef_mod=read.csv("~/N2O/Secondary_Input_Data/SOILEF_EF_Modifiers.csv")
  rf_till=read.csv("~/N2O/Processed_Input_Data/INPUT-Soil-RFTill.csv")
  rf_tex=read.csv("~/N2O/Processed_Input_Data/INPUT-Soil-RFTexture.csv")



  #Join the tables
  p3_ef%>%left_join(soil_ef_mod, by=c("Province_ID"="PROVINCE",
                                      "Ecodistrict_ID"="ECODISTRIC"))%>%
    left_join(time_dep_par, c("Province_ID"="PROVINCE",
                              "Ecodistrict_ID"="ECODISTRIC",
                              "Inv_Year_ID"="Inv_Year_ID"))%>%left_join(Fixed_para,
              by=c("Province_ID","Ecodistrict_ID","P","PE","F_TOPO"))%>%
    left_join(rf_tex, by=c("Soil_Type_ID"="Soil_Type"))%>%
    left_join(rf_till, by=c("Soil_Type_ID"="Soil_Type"))%>%
    select(Inv_Year_ID, Province_ID,
                           Ecodistrict_ID,Soil_Type_ID,
                           F_TOPO,A_PCoarse,A_PMed,A_PFine,Irrigation_fraction,
                           EF_CT,CROPLND.x,Course,Medium, Fine,TOTALRT,
                           TOTALIT,TOTALNT,NT)%>%rename(CROPLND=CROPLND.x)->intermediate_P3

  #Calculating the TEXT_MULT
  intermediate_P3%>%
    mutate(Text_Mult=if_else(A_PCoarse+A_PMed+A_PFine==0,1,
                             if_else(Soil_Type_ID=="E",
                                     A_PCoarse*Course+A_PMed*Medium+A_PFine*Fine,1)))->Stage_1

  #Calculating the Moist_fraction
  Stage_1%>%
    mutate(Moist_fraction=if_else(F_TOPO+Irrigation_fraction>1,1,F_TOPO+Irrigation_fraction))->Stage_2


  #Calculating the Tillage_mult
  Stage_2%>%mutate(Tillage_mult=if_else(Soil_Type_ID=="PC",((TOTALRT+TOTALNT)/(TOTALRT+TOTALIT+TOTALNT)*NT)+(TOTALIT/(TOTALRT+TOTALIT+TOTALNT)),if_else(TOTALRT+TOTALIT+TOTALNT==0,1,if_else(Soil_Type_ID=="E",((TOTALRT+TOTALNT)/(TOTALRT+TOTALIT+TOTALNT)*NT)+(TOTALIT/(TOTALRT+TOTALIT+TOTALNT)),1))))->Stage_3


  #Calculating the EF_Irri_DW
  Stage_3%>%mutate(EF_Irri_DW=if_else(CROPLND==0,EF_CT, (EF_CT*(1-Irrigation_fraction))
                                           +(Irrigation_fraction*efbase$EFBase_U)))->Stage_4


  #Calculating the EF_Top_Irri_DW
  Stage_4%>%mutate(EF_Topo_Irrig_DW=if_else(CROPLND==0,EF_CT, (EF_CT*(1-Moist_fraction))
                                      +(Moist_fraction*efbase$EFBase_U)))->Stage_5

  #Calculating the EF_Topo
  Stage_5%>%mutate(EF_Topo=ifelse(CROPLND==0,EF_CT,(efbase$EFBase_U*F_TOPO)+((1-F_TOPO)*EF_CT)))-> Stage_6


  #Calculating the EF_Topo_texture
  Stage_6%>%mutate(EF_Topo_Texture=ifelse(CROPLND==0,EF_CT,EF_Topo*Text_Mult))->Stage_7

  #Calculating the EF_Topo_Irrig_texture_DW
  Stage_7%>%mutate(EF_Topo_Irrig_texture_DW=EF_Topo_Irrig_DW*Text_Mult)->Stage_8

  #Calculating the EF_Top_texture_tillage
  Stage_8%>%mutate(EF_Topo_texture_tillage=if_else(CROPLND==0, EF_CT, EF_Topo*Text_Mult*Tillage_mult))->Stage_9


  #Calculating the EF_Topo_texture_irrig
  Stage_9%>%mutate(EF_Topo_texture_irrig=if_else(CROPLND==0,EF_CT, if_else(EF_Topo_Texture>=efbase$EFBase_U*Text_Mult, EF_Topo_Texture, (Text_Mult*efbase$EFBase_U*Moist_fraction)+(1-Moist_fraction)*EF_CT*Text_Mult)))->Stage_10


  #Calculate the EF_Topo_text_irrig_DW
  Stage_10%>%mutate(EF_Topo_text_irrig_DW=if_else(CROPLND==0,EF_CT,if_else(EF_Topo_Irrig_DW>-efbase$EFBase_U, EF_Topo_Texture, 0.0168*Irrigation_fraction + (1-Irrigation_fraction)*EF_Topo_Texture)))->Stage_11



  #Caculating teh EF_soil, EF_soil_DW, EF_soil_DW_2
  Stage_11%>%mutate(EF_soil=EF_Topo_texture_irrig*Tillage_mult,
                    EF_soil_DW=EF_Topo_Irrig_texture_DW*Tillage_mult,
                    EF_soil_DW_2=EF_Topo_text_irrig_DW*Tillage_mult)->Stage_12

  write.csv(Stage_12,"~/N2O/Secondary_Input_Data/P3_1EF_Modifications.csv" )

  ### QC ########### implementation
  ### No. of ecodistricts
  ## Check on area
  ## no. of records...
  ## comparison with previous annual records... etc.

}

Create_SOILEF_P3_1EF_Modifications()


#Code QC .. Comparing calculations with previous methodology

con=odbcConnect("n2o") # Connect to microsoft access db
Access_method=sqlFetch(con,"P3_1EF_Modifications") #Table from the previous methodology

compare_tbls(Stage_12, Access_method)

quantile(Access_method$EF_Topo_Irrig_texture_DW)
quantile(Stage_12$EF_Topo_Irrig_texture_DW)


quantile(Access_method$EF_soil_DW)
quantile(Stage_12$EF_soil_DW)

quantile(Access_method$EF_Topo_texture)
quantile(Stage_12$EF_Topo_Texture)


hist(Access_method$EF_Topo_texture)
hist(Stage_12$EF_Topo_Texture)
