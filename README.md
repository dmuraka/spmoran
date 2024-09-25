# spmoran: An R package for fast spatial/spatio-temporal regression modeling: Case study examples
The spmoran package (https://cran.r-project.org/web/packages/spmoran/index.html) provides functions for estimating spatial and spatio-temporal regression models for Gaussian and non-Gaussian data. Models with spatially varying coefficients (SVCs) and/or spatio-temporally varying coefficients (STVCs), models with group effects, spatial unconditional quantile regression model, and low rank spatial econometric models are implemented. A compositional warping method (i.e., iterative transformation) is used to flexibly model non-Gaussian data. All models are estimated in a computationally efficient manner.

This page provides the following sample codes:
- Gaussian spatial regression modeling for housing price data (sample_code_gaussian.Rmd)
- Gaussian STVC modeling for housing price data (sample_code_spatiotemporal.Rmd)
- Non-Gaussian modeling aiming for disease mapping (pollutionhealth_data_example.R), spatial interpolation and uncertainty analysis (meuse_data_example.R), panel data analysis (us_panel_example.R), and housing price analysis (boston_data_example.R).

Note: Buggs related to the non-Gaussian modeling and other parts are fixed in version 0.3.0. 
