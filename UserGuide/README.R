
# Build the DLMtool User Guide 

install.packages("bookdown") 


# File Structure 

# -- Chapter Naming Convention ----

# index.


if(file.exists("userguide.Rmd")) file.remove("userguide.Rmd")
bookdown::render_book("index.Rmd", "bookdown::gitbook")

# 'userguide' directory has been update (or created) in the working directory. Copy the
# entire directory and paste into 'DLMtool/docs' - ie 'DLMtool/docs/userguide/index.html'
# sync with github - this will update the website