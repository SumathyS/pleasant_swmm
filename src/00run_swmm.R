#check to make sure required packages are installed
list.of.packages <- c("plyr", "dplyr", "reshape2", "ggplot2", "grid", "gridExtra", "sensitivity", "abind", 
                      "ppcor","swmmr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)>0) {install.packages(new.packages)}
install.packages("swmmr")
#install and load library dependencies
#install.packages("magrittr")
#install.packages("sensitivity")
install.packages("tstrsplit")
library(magrittr)
library(plyr)
library(reshape2)
library(ggplot2)
library(grid)
library(gridExtra)
library(sensitivity)
library(abind)
library(tools)
library(ppcor)
library(dplyr)
library(swmmr)
library(DEoptim)
#echo environment
Sys.info()
Sys.info()[4]
.Platform
version


#set some default directories based on machine location
#Tom's mac air
if(Sys.info()[4]=="stp-air"){
  swmmdir <- "~/git/pleasant_swmm/"
}
#Tom's epa window
if(Sys.info()[4]=="DZ2626UTPURUCKE"){
  pwcdir <- "d:/git/pleasant_swmm/"
  # pwc,przm (without directory, the file needs to be in vpdir_exe above)
    swmm_filename <- "NPlesantCreek.inp"
}
#Sumathy's window
if(Sys.info()[4]=="DZ2626USSINNATH"){
  swmmdir <- "C:/git/pleasant_swmm/"
  # pwc,przm file (without directory, the file needs to be in vpdir_exe above)
  swmm_filename <- "NPlesantCreek.inp"
}
#Sumathy's desktop
if(Sys.info()[4]=="DESKTOP-7UFGA86"){
  swmmdir <- "C:/Users/Sumathy/pleasant_swmm/"
  # pwc,przm file (without directory, the file needs to be in vpdir_exe above)
  swmm_filename <- "NPlesantCreek.inp"
}
print(paste("Root directory location: ", swmmdir, sep=""))


#subdirectories
swmmdir_input <- paste(swmmdir, "input/", sep = "")
swmmdir_output <- paste(swmmdir, "output/", sep = "")
swmmdir_log <- paste(swmmdir, "log/", sep = "")
swmmdir_fig <- paste(swmmdir, "figures/", sep = "")
swmmdir_exe <- paste(swmmdir, "exe/", sep = "")
swmmdir_io <- paste(swmmdir, "io/", sep = "")
swmmdir_weather <- paste(swmmdir, "weather/", sep = "")
swmmdir_sobol <- paste(swmmdir, "sobol/", sep = "")


#swmm executable version
#swmm 5
swmm_binary<- "swmm5.exe"
swmmdir_executable <- paste(swmmdir_exe, swmm_binary, sep="")
dll_binary<- "swmm5.dll"
dlldir_executable <- paste(swmmdir_exe, dll_binary, sep="")
#number of simulations 
Nsims <- 1

#simulation start and end
#must have mm/dd/yyyy format
simstart <- "01/01/2013"
simend <- "12/31/2014"

#run everything
source(paste(swmmdir,"src/00run_swmm.R",sep = ""))

#setup swmm and visualize inp file
source(paste(swmmdir,"src/01setup_swmm_and_visualize_inp.R",sep = ""))
# parameterize inputs
source(paste(swmmdir,"src/01b_lhs_parameterization.R",sep = ""))
#write_update_run_swmm
source(paste(swmmdir,"src/02update_swmm_par.R",sep = ""))

# #create input dataframe
# #source(paste(pwcdir,"src/03write_input_dataframe.R",sep = ""))
# # read text,csv files and save results into dataframe
# source(paste(pwcdir,"src/04_write_ouput_into_df.R",sep = ""))
# 
# # load input and output objects into environment
# source(paste(pwcdir,"src/05load_io.R",sep = ""))

# run sensitivity analysis on time daily arrays
source(paste(pwcdir,"src/06daily_sensitivity_analysis_linear.R",sep = ""))

#
source(paste(pwcdir,"src/06Max_sensitivity_analysis_linear.R",sep = ""))
# plot results
source(paste(pwcdir,"src/07sensitivity_analyses_graphics.R",sep = ""))
source(paste(pwcdir,"src/08pardistribution.R",sep = ""))
