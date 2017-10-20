
# ==============================================================================
# === DLMtool Exercise 5a: Custom OMs, OM templates and OM reports =============
# ==============================================================================
#
# In this Exercise we will look at some of the more advanced methods to specify 
# and modify an Operating Model.
#
#
 

# === Setup (only required if new R session) ===================================

library(DLMtool)  
setup()


# === Documenting OMs ================================================
#
# Where possible it is desirable to fully document the rationale for the 
# specification of a particular operating model. 
#
# DLMtool includes a set of tools for doing this. The function OMinit() creates
# an operating model folder with a .xlsx file for OM parameter specification
# and a .rmd file for adding text explanations for the OM parameters that were
# selected. 
# 
# Lets start by building an example (you will need to create your own 'myOM'
# directory):

setwd("C:/myOM")     # set the working directory
OMinit("testfish")   # create the .xlsx and .rmd files

# Open the testfish.xlsx workbook in the C:/myOM folder.
#
# You can see that it has sheets for each of the DLMtool objects 
# required to build a full OM. Just like the .csv files you can specify
# Stock, Fleet, Imp and Obs models in these, The sheets contain the 
# correct names of each parameter value.
# 
# You'll notice that there are also sheets for other OM parameters
# and real fishery Data. 
#
# Navigate to the OM sheet and you will see some default values have
# been added. Remember you can find out what these mean using the 
# built-in help

class?OM

# Now open in Rstudio, the testfish_source.rmd file. 
# This is a single R file containing headings for each object type
# (e.g. Stock and Fleet) and each parameter for each object type. 
# 
# Since we created a new OM folder using OMinit and have not added
# our own personalized description, this file includes some guidance
# text and mostly "No justification provided" under each parameter. 
# 
# Lets create an example to see what this could have looked like
# for a fully specified (.xlsx) and fully justificed (.rmd) OM (you
# will need to create your own 'example' directory):

setwd("C:/example")
OMinit('example')
 
# If you navigate to "C:/example" you will see an example OM using
# the parameters for the Chilean Hake operating model. 
# 
# Not only are most parameters assigned values, there is justifica-
# tion text for each in the .rmd file.
# 
# Why bother with this? Well here is the really neat part. You can
# automatically build a OM report using these files which includes
# some nifty figures that explain what the OM parameters represent:

OMdoc()

# This might take a little while to produce but after it has 
# finished you will see a nicely formatted and searchable
# .html document in the "C:/example' folder.
#
# The bold black text are parameters, the blue text is the value
# assigned to the parameter.
#
# Of course this would be of no use to you if you couldn't convert
# the .xlsx OM file into a real DLMtool operating model for use in
# MSE. 
#
# Luckily that is quite easy:

hakeOM<-XL2OM('C:/example/Example_Chile_hake.xlsx')

# A major benefit of using xlsx files is that they can be fully
# annotated and include various other analyses in other worksheets
# which can be used to derive parameters etc in the OM object
# sheets.
#
# One last feature. You might want to start your OMinit folder
# using an existing OM object or Stock, Fleet, Obs and Imp 
# objects. Ie you want to work from predefined objects and want 
# those parameter values in the .xlsx workbook to begin with.
#
# Again that's quite straightforward:

avail('Stock')  # what Stocks can I use?
setwd("C:/myOM")     # set the working directory
OMinit("myrockfish", templates=list(Stock="Rockfish"))

# Because we now have two OMs in the same folder "C:/myOM",
# we have to specify the OM name when using OMdoc():

setwd("C:/myOM")
OMdoc("myrockfish")

OMinit("myflounder", templatesArrowtooth_Flounder_BC_SS)   # create the .xlsx and .rmd files






















# ==============================================================================
# === End of Exercise 5a =======================================================
# ==============================================================================





