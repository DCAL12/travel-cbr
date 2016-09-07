kNearestNeighbors = function(similarities, df, k = 1) {
  ## Return data frame of k-nearest neighbors with proximities
  order = head(order(-similarities), k) # closest to furthest
  df = df[order,]
  df$proximity = similarities[order]
  df
}

interpolate.weightedVotes = function(proximity, votes) {
  # Returns proximity-weighted vote of neighbors
  
  if(length(votes) == 1) return(votes) # nearest-neighbor
  
  if(is.factor(votes)) {
    # similarity-weighted voting scheme
    votes.weighted = tapply(proximity, votes, sum)
    votes.most = sort(votes.weighted, decreasing = TRUE)[1]
    names(votes.most)
  }
  
  else round(weighted.mean(votes, proximity), 2)
}