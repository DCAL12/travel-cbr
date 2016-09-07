kNearestNeighbors = function(similarities, df, k = 1) {
  ## Return data frame of k-nearest neighbors with proximities
  order = head(order(-similarities), k) # closest to furthest
  df = df[order,]
  df$similarity = similarities[order]
  df
}

interpolate.weightedVotes = function(similarity, votes) {
  # Returns similarity-weighted vote of neighbors
  
  if(length(votes) == 1) return(votes) # nearest-neighbor
  
  if(is.factor(votes)) {
    # similarity-weighted voting scheme
    votes.weighted = tapply(similarity, votes, sum)
    votes.most = sort(votes.weighted, decreasing = TRUE)[1]
    names(votes.most)
  }
  
  else round(weighted.mean(votes, similarity), 2)
}