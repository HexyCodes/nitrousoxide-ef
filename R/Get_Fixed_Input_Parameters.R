library(roxygen2)
library(RODBC)
#' Function to import the source tables
#'
#' Stores the imported access table files into a Input Data folder location Licence:GPL3
#'
#' @return  None
#' Get_Fixed_Input_Parameterss()
#'
#' @author Arumugam Thiagarajan, \email{arumugam.thiagarajan@canada.ca}
#'
#' @import RODBC
#' @examples
#' Get_Fixed_Input_Parameters()
#'



Get_Fixed_Input_Parameters=function(){

  datapath="~/N2O/Model_Fixed_Parameters/"
  ############################ Access DB connection codes############################
  con=odbcConnect("modparms") # Connect to microsoft access db
  workbooks=sqlTables(con) # fetch all the table names in the db
  tables=workbooks$TABLE_NAME # display all table names in console for retrieval
  tables
  filelist=c("INPUT-Parameter-Coeff_NE1",
             "INPUT-Parameter-Coeff_NEg",
             "INPUT-Parameter-Coeff_NEgaDE",
             "INPUT-Parameter-Coeff_NEm",
             "INPUT-Parameter-Coeff_NEmaDE",
             "INPUT-Parameter-Coeff_NEmob",
             "INPUT-Parameter-Coeff_VS",
             "INPUT-Parameter-Coefficients"
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

Get_Fixed_Input_Parameters()

