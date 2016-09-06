similarity.int = function(allValues, targetValue) {
  range = max(allPrices) - min(allPrices)
  (range - abs(targetValue - allPrices)) / range
}

similarity.string = function(allValues, targetValue) {
  ifelse(targetValue == allValues, 1, 0)
}

# similarity of seasons is cyclical (December and January are similar)
# use Pythagorean Theorem to calculate distance between unit circle coordinates 
season.cycle = data.frame(x = sin(1:12 * pi / 6), y = cos(1:12 * pi / 6))
similarity.season = function(allValues, targetValue) {
  max.dissimilarity = 2 # unit circle diameter
  distance = sqrt((season.cycle[targetValue, 'x'] - season.cycle[allValues, 'x'])^2 + 
                  (season.cycle[targetValue, 'y'] - season.cycle[allValues, 'y'])^2)
  (max.dissimilarity - distance) / max.dissimilarity
}