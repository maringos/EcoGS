#' Frequency prediction of ecological relationships
#'
#' The prediction of the frequency of ecological relationship between pairs of co-grown bacteria in each sample (community)
#' as exported by the function make_eco_mat and a user imported OTU table
#'
#' @param OTU_table a matrix of the abundances of each species in each sample (columns are samples and rows are bacterial species)
#' @param eco_mat a list, as exported by the function make_eco_mat and which contains: matrix of all_models X all_models with each cell represents the ecological relation between the two strains
#' @param weighing_method either "min" for using lower abundance of the interacting bacteria for weighing (default), or "multi" for using the multiplication of the two abundances
#' 
#' @return
#' (a list object in the R environment)
#'
#' a. matrix of the relative frequency for each ecological relation in each sample
#'
#' b. matrix of the relative frequency for each ecological relation in each sample weighted by the abundances from the OTU table
#'
#' @export
#'
relation_per_sample <- function(OTU_table, eco_mat, weighing_method = "min"){
  relations <- unique(unlist(eco_mat))
  relations <- relations[relations != "Alone"]
  relations_per_samp <- as.data.frame(matrix(0, ncol(OTU_table), length(relations)))
  names(relations_per_samp) <- relations
  rownames(relations_per_samp) <- names(OTU_table)
  weighed_relations <- relations_per_samp
  i <- 0
  id <- names(OTU_table)[1]
  for (id in names(OTU_table)) {
    i <- i + 1
    print(paste0("Sample Number: ", i))
    bac_ind <- OTU_table[,id] > 0
    if (sum(bac_ind) < 2) {
      next
    }
    bac_in_samp <- rownames(OTU_table)[bac_ind]
    samp_abund <- data.frame(species = bac_in_samp, abund = OTU_table[bac_in_samp,id])
    samp_abund <- samp_abund[order(samp_abund$abund),]
    rownames(samp_abund) <- samp_abund$species
    samp_eco_mat <- eco_mat[bac_in_samp, bac_in_samp]
    samp_abund_mat <- samp_eco_mat
    samp_abund_mat[] <- 0
    sp <- rownames(samp_abund)[1]
    while (length(bac_in_samp) > 0) {
      sp1 <- bac_in_samp[1]
      bac_in_samp <- bac_in_samp[-1]
      for (sp2 in bac_in_samp) {
        if (weighing_method == "min") {
          samp_abund_mat[sp1,sp2] <- min(samp_abund[sp1, "abund"], samp_abund[sp2, "abund"])
        }
        else if (weighing_method == "multi") {
          samp_abund_mat[sp1,sp2] <- samp_abund[sp1, "abund"]*samp_abund[sp2, "abund"]
        }
      }
    }
    for (relat in relations) {
      ind <- samp_eco_mat == relat
      relations_per_samp[id, relat] = sum(ind)/2
      weighed_relations[id, relat] <- sum(samp_abund_mat[ind])/2
    }
  }
  out_mats <- list(relations_per_samp, weighed_relations)
  names(out_mats) <- c("relations_per_samp", "weighed_relations")
  return(out_mats)
}
