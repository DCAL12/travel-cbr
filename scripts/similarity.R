similarity.int = function(allValues, targetValue) {
  range = max(allValues) - min(allValues)
  (range - abs(targetValue - allValues)) / range
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

similarity = function(cases, targetCase, weights = rep(1, length(colnames(targetCase)))) {
  ## Generate a similarity matrix of new (target) case vs. case-base
  ## normalised where 1 = exact match, 0 = completely dissimilar
  
   df = data.frame(sapply(colnames(targetCase), function(attribute) {
     switch (attribute,
             JourneyCode = similarity.int(cases$JourneyCode, targetCase$JourneyCode),
             HolidayType = similarity.string(cases$HolidayType, targetCase$HolidayType),
             Price = similarity.int(cases$Price, targetCase$Price),
             NumberOfPersons = similarity.int(cases$NumberOfPersons, targetCase$NumberOfPersons),
             Region = similarity.string(cases$Region, targetCase$Region),
             Transportation = similarity.string(cases$Transportation, targetCase$Transportation),
             Duration = similarity.int(cases$Duration, targetCase$Duration),
             Season = similarity.season(cases$Season, targetCase$Season),
             Accommodation = similarity.string(cases$Accommodation, targetCase$Accommodation),
             Hotel = similarity.string(cases$Hotel, targetCase$Hotel)
     )})
   )
   
   # apply weights
   similarity.weighted = sweep(df, 2, weights, '*')
   
   rowSums(similarity.weighted) / sum(weights)
}