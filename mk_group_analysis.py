"""
 Author: Tom Morin
   Date: April, 2019
Purpose: Create a file for each afni 3dttest++ command that will be run for the 
         group analysis. Also create an all_ttests bash script that will run all
         of the 3dttest commands
"""

# subject prefix
pre="RPMS_"

# subjects to include in the analysis
subs=["2001","2002","2003","2004","2005","2006","2007","2008","2009","2010",
      "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020",
      "2021","2022","2023","2024","2025","2026","2027","2028","2029","2030",
      "2031","2032","2033","2034","2035"]

# contrast numbers from the stats image
c_nums=[1,3,6,8,
        11,13,16,18,
        21,24,27,30,
        33,36,39,42,
        45,48,51,54,
        57,60,63,66]

# contrast names
c_names=["TxtU_Coef", "TxtU_AM_Coef", "TxtR_Coef", "TxtR_AM_Coef", 
         "SymU_Coef", "SymU_AM_Coef", "SymR_Coef", "SymR_AM_Coef",
         "Sym-Txt", "Sym-Txt_AM", "Rule-Uni", "Rule-Uni_AM",
         "TxtR-TxtU", "TxtR-TxtU_AM", "SymR-SymU", "SymR-SymU_AM",
         "SymR-TxtR", "SymR-TxtR_AM", "SymU-TxtU", "SymU-TxtU_AM",
         "SymR-TxtU", "SymR-TxtU_AM", "TxtR-SymU", "TxtR-SymU_AM"]

# group mask
mask="mask_group+tlrc"

# Create each 3dttest command in a separate file
for i in range(0, len(c_nums)):
    with open(c_names[i] + "_onesamp_ttest", "w") as fp:
        fp.write("3dttest++ -setA " + cnames[i] + " \\" + "\n")
        for s in range(0, len(subs)):
            fp.write("\t\t" + pre + subs[s] + " stats." + subs[s] + 
                     "_REML+tlrc.HEAD'[" + str(c_nums[i]) + "]' \\" + "\n")
        fp.write("\t\t-prefix " + c_names[i] + " \\" + "\n"
        fp.write("\t\t-mask " + mask)

# Create all_ttests bash script
with open("all_ttests.sh", "w") as fp:
    fp.write("#!/bin/bash\n\n")
    for i in range(0, len(c_names)):
        fp.write("rm -f " + c_names[i] + "+tlrc.*\n")
    fp.write("\n")
    for i in range(0, len(c_names)):
        fp.write("tcsh " + c_names[i] + "_onesamp_ttest\n")




