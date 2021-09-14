# Spatial regression using the spmoran package: Case study examples
This page demonstrates application examples of the spmoran package for hedonic housing price analysis (sample_code_gaussian.Rmd), disease mapping and regression with count data (pollutionhealth_data_example.R), spatial interpolation and uncertainty analysis (meuse_data_example.R), and panel data analysis (us_panel_example.R), and another hedonic analysis considering non-Gaussianity (boston_data_example.R).

This package estimates spatial additive mixed models and other spatial regression models for Gaussian and non-Gaussian data. A transformation-based approach is implemented to model a wide variety of non-Gaussian data including count data. For fast computation, a low rank Gaussian process, which is interpretable in terms of the Moran coefficient, is used for modeling spatially varying coefficients and residual spatial dependence. Currently, this package implements conventional spatial regression models and extensions, including spatially (and non-spatially) varying coefficient model, models with group effects, spatial unconditional quantile regression model, and low rank spatial econometric models. All these models are estimated computationally efficiently. For details see Murakami (2020) arXiv:1703.04467.
