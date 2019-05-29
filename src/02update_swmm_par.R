###############update input file################
set.seed(42)
for (Ite in 1:Nsims){
  print(Ite)
  con_swmm5 <- file(paste(swmmdir, "input/NPlesantCreek",".inp",sep=""))
  a_old=readLines(con_swmm5)
  a=readLines(con_swmm5)
  close(con_swmm5)
  ###########################################################################################################
  newdir <- paste0(swmmdir,"input/input",Ite)
  print(newdir)
  dir.create(newdir,showWarnings = FALSE) 
  cwd <- getwd()          # CURRENT dir
  setwd(newdir) 
  # #copy weather file
  # weather_input <- paste(pwcdir_exe, pwc_weather_used, sep="")
  # file.copy(weather_input,newdir, recursive = FALSE, 
  #           copy.mode = TRUE)
  # 
  # file_path_as_absolute(newdir)
  # #update weather and output under each input folder
  # a[4]=paste(file_path_as_absolute(newdir),"/",pwc_weather_used, sep="")
  # a[6]=paste(file_path_as_absolute(newdir),"/","output.zts", sep="")

  #copy swmm.exe############################################
  print(paste(file.exists(swmmdir_executable), ": executable file at", swmmdir_executable))
  file.copy(swmmdir_executable,newdir, recursive = FALSE, 
            copy.mode = TRUE)
  #copy swmm.dll############################################
  print(paste(file.exists(dlldir_executable), ": executable file at", dlldir_executable))
  file.copy(dlldir_executable,newdir, recursive = FALSE, 
            copy.mode = TRUE)
  #write input file
  swmm_file <- paste("NPlesantCreek",".inp", sep="")
  file.exists(swmm_file)
  file.create(swmm_file)
  file.exists(swmm_file)
  con_swmm <-file(swmm_file)
  writeLines(a,
             con_swmm)
  close(con_swmm)
  # initiate the simulation and save output and report files
  #system2(swmmdir_executable, "NPlesantCreek.inp", "NPlesantCreek.rpt", "NPlesantCreek.out")
  
  #files <- run_swmm("NPlesantCreek.inp")
  
  # initiate the simulation and have both rpt and out files as temporary files. this will save computer space
  tmp_rpt_file <- tempfile()
  tmp_out_file <- tempfile()
  
   
  swmm_files <- run_swmm(
    inp = "NPlesantCreek.inp",
    rpt = tmp_rpt_file,
    out = tmp_out_file
  )
  setwd(cwd)
}