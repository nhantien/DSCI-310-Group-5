# Makefile
# Edison, Tien

# This driver script completes the textual analysis of
# breast cancer dataset and creates tables and figures for the analysis.
# This script takes no arguments.

# example usage:
# make all

all: results/figures/hist_plot.png results/figures/boxplot_plot.png results/tables/cross_val.csv results/tables/tuned_para.csv results/tables/classification_report.csv results/figures/confusion_matrix.png doc/jbook/_build/html/index.html

jbook: results/figures/hist_plot.png results/figures/boxplot_plot.png results/tables/cross_val.csv results/tables/tuned_para.csv results/tables/classification_report.csv results/figures/confusion_matrix.png

#load data 
data/raw/breast_cancer.csv: data/raw/breast_cancer.txt src/load_data.py
	python3 src/load_data.py data/raw/breast_cancer.txt data/raw/breast_cancer.csv
	
#clean data 
data/processed/train_df.csv data/processed/test_df.csv: data/raw/breast_cancer.csv src/clean_data.py
	python3 src/clean_data.py data/raw/breast_cancer.csv data/processed/train_df.csv data/processed/test_df.csv
	
#EDA plots 
results/figures/hist_plot.png results/figures/boxplot_plot.png: data/processed/train_df.csv src/EDA_plots.py
	python3 src/EDA_plots.py data/processed/train_df.csv results/figures/hist_plot.png results/figures/boxplot_plot.png
	
#Tables and figures for analysis 
results/tables/cross_val.csv results/tables/tuned_para.csv results/tables/classification_report.csv results/figures/confusion_matrix.png: data/processed/train_df.csv data/processed/test_df.csv src/build_test_model.py
	python3 src/build_test_model.py data/processed/train_df.csv data/processed/test_df.csv results/tables/cross_val.csv results/tables/tuned_para.csv results/tables/classification_report.csv results/figures/confusion_matrix.png

# render the report
doc/jbook/_build/html/index.html: doc/jbook/_config.yml doc/jbook/_toc.yml doc/jbook/breast_cancer_prediction.md doc/jbook/references.bib
	jb build doc/jbook/
	
clean:
	rm -rf data/processed/*.csv
	rm -rf data/raw/*.csv
	rm -rf results/tables/*.csv
	rm -rf results/figures/*.png
	rm -rf doc/jbook/_build
	