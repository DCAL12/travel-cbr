knn.similarityWeighted = function(similarities, outcomes, k = 1) {
  ## K-Nearest Neighbor
  ## if k > 1, returns proximity-weighted average of k-nearest neighbors
  
  kNearest = head(order(-similarities), k) # closest to furthest
  weights = similarities[kNearest]
  
  if(k == 1) return(outcomes[kNearest]) # nearest-neighbor
  
  if(is.factor(outcomes)) {
    # similarity-weighted voting scheme
    vote = weighted.mean(as.integer(outcomes[kNearest]), weights)
    levels(outcomes)[round(vote)]
  }
  
  else round(weighted.mean(outcomes[kNearest], weights), 2)
}