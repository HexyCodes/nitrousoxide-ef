library(roxygen2)
library(RODBC)
#' Function to import the source tables
#'
#' Stores the imported access table files into a Input Data folder location Licence:GPL3
#'
#' @return  None
#' Get_N2O_Processed_Input_Files()
#'
#' @author Arumugam Thiagarajan, \email{arumugam.thiagarajan@canada.ca}
#'
#' @import RODBC
#' @examples
#' Get_N2O_Processed_Input_Files()
#'



Get_N2O_Processed_Input_Files=function(){

  datapath="~/N2O/Processed_Input_Data/"
  ############################ Access DB connection codes############################
  con=odbcConnect("n2o") # Connect to microsoft access db
  workbooks=sqlTables(con) # fetch all the table names in the db
  tables=workbooks$TABLE_NAME # display all table names in console for retrieval
  filelist=c("INPUT-EF_time_dep_para",
             "INPUT-EF_Fixed_Para",
             "INPUT-Parameter-EFBase_Reg_Para",
             "INPUT-Parameter-FracLeach_Reg_Para",
             "INPUT-Parameter-GWP",
             "INPUT-Parameter-Nat_Para",
             "INPUT-Soil-Ratio",
             "INPUT-Soil-RFTexture",
             "INPUT-Soil-RFThaw",
             "INPUT-Soil-RFTill",
             "INPUT-Spatial-Province",
             "INPUT-Spatial-Province_Sale",
             "FF1_Perenniel_export_table",
             "CR_Residual_N_output"
              )
  ###################################################################################
  for(f in 1:length(filelist)){
    print(paste0("Now processing:",filelist[f]))
   temp=sqlFetch(con, filelist[f])
    filename=paste0(datapath, filelist[f],".csv")
    write.csv(temp,filename, row.names = F)
  }
  odbcCloseAll()
}

Get_N2O_Processed_Input_Files()

