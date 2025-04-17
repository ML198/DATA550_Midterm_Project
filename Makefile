report.html: code/04_render_report.R \
  report.Rmd descriptive_analysis outcome_analysis regression_analysis
	Rscript code/04_render_report.R

output/figureA_boxplots.png: code/01_demographics.R data/f75_interim.csv
	Rscript code/01_demographics.R

output/figureB_bar.png: code/01_demographics.R data/f75_interim.csv
	Rscript code/01_demographics.R

output/table1_demographics.rds: code/01_demographics.R data/f75_interim.csv
	Rscript code/01_demographics.R

output/figureC_daysstable.png: code/02_outcome.R data/f75_interim.csv
	Rscript code/02_outcome.R

output/figureD_discharge.png: code/02_outcome.R data/f75_interim.csv
	Rscript code/02_outcome.R

output/table2_outcome.rds: code/02_outcome.R data/f75_interim.csv
	Rscript code/02_outcome.R

output/figureE_trends.png: code/03_trends.R data/f75_interim.csv
	Rscript code/03_trends.R

output/figureF_gain_vs_time.png: code/03_trends.R data/f75_interim.csv
	Rscript code/03_trends.R

output/table3_progression.rds: code/03_trends.R data/f75_interim.csv
	Rscript code/03_trends.R

.PHONY: descriptive_analysis
descriptive_analysis: output/figureA_boxplots.png output/figureB_bar.png output/table1_demographics.rds

.PHONY: outcome_analysis
outcome_analysis: output/figureC_daysstable.png output/figureD_discharge.png output/table2_outcome.rds

.PHONY: regression_analysis
regression_analysis: output/figureE_trends.png output/figureF_gain_vs_time.png output/table3_progression.rds

.PHONY: clean
clean:
	rm -f output/*.rds && rm -f output/*.png && rm -f *.html

.PHONY: install
install:
	Rscript -e "renv::restore(prompt = FALSE)"

