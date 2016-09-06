library(xlsx)
library(iterators)

appendRow = function(dataframe, row) {
  dataframe[nrow(dataframe) + 1, ] = row
  dataframe
}

readData = read.xlsx("data/TRAVEL.xlsx", sheetIndex = 1, header = FALSE, stringsAsFactors = FALSE)

attributes = c("JourneyCode",
               "HolidayType",
               "Price",
               "NumberOfPersons",
               "Region",
               "Transportation",
               "Duration",
               "Season",
               "Accommodation",
               "Hotel")
cases = data.frame(matrix(vector(), 0, length(attributes), dimnames = list(c(), attributes)))

# convert list to dataframe
rows = iter(readData, by = "row")
elements = vector()

for (i in 1:nrow(readData)) {
  row = try(nextElem(rows))
  if(class(row) == "StopIteration") break
  
  heading =  gsub("[^[:alnum:]]", "", row[2]$X2) # use only alpha-numerics for heading
  if(heading == "case") {
    # append previous row and start a new one
    if (length(elements) > 0) cases = appendRow(cases, elements)
    elements = vector()
  }
  
  if(heading %in% attributes) elements[heading] = gsub("[^[:alnum:]]", "", row[3]$X3) # use only alpha-numerics for data
}

cases = appendRow(cases, elements) # last observation

# recode variables
cases$JourneyCode = as.integer(cases$JourneyCode)
cases$HolidayType = as.factor(cases$HolidayType)
cases$Price = as.integer(cases$Price)
cases$NumberOfPersons = as.integer(cases$NumberOfPersons)
cases$Region = as.factor(cases$Region)
cases$Transportation = as.factor(cases$Transportation)
cases$Duration = as.integer(cases$Duration)
cases$Hotel = as.factor(cases$Hotel)
cases$Accommodation = factor(cases$Accommodation, levels = c("OneStar", "TwoStars", "ThreeStars", 
                                                             "FourStars", "FiveStars", "HolidayFlat"))

cases$Season = factor(cases$Season, levels = c("January", "February", "March", "April", "May", "June", 
                                               "July", "August", "September", "October", "November", "December"))

remove(list = c("readData", "attributes", "row", "rows", "elements", "heading", "i", "appendRow"))
save.image(file = ".RData")