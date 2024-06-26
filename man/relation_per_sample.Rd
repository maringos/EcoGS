% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/4_relation_per_sample.R
\name{relation_per_sample}
\alias{relation_per_sample}
\title{Frequency prediction of ecological relationships}
\usage{
relation_per_sample(OTU_table, eco_mat, weighing_method = "min")
}
\arguments{
\item{OTU_table}{a matrix of the abundances of each species in each sample (columns are samples and rows are bacterial species)}

\item{eco_mat}{a list, as exported by the function make_eco_mat and which contains: matrix of all_models X all_models with each cell represents the ecological relation between the two strains}

\item{weighing_method}{either "min" for using lower abundance of the interacting bacteria for weighing (default), or "multi" for using the multiplication of the two abundances}
}
\value{
(a list object in the R environment)

a. matrix of the relative frequency for each ecological relation in each sample

b. matrix of the relative frequency for each ecological relation in each sample weighted by the abundances from the OTU table
}
\description{
The prediction of the frequency of ecological relationship between pairs of co-grown bacteria in each sample (community)
as exported by the function make_eco_mat and a user imported OTU table
}
