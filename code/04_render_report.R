# code/04_render_report.R
here::i_am("code/04_render_report.R")
# Load required package
library(rmarkdown)

# Render the report
render( "report.Rmd", output_file = "report.html")
