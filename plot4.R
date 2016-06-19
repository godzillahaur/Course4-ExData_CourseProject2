file.name <- "./summarySCC_PM25.rds"
url       <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zip.file  <- "./exdata%2Fdata%2FNEI_data.zip"

# Check if the data is downloaded and download when applicable
if (!file.exists("./summarySCC_PM25.rds")) {
        download.file(url, destfile = zip.file)
        unzip(zip.file)
        file.remove(zip.file)
}


# Reading the file
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Find out the data related the coal
coal<-grep("coal", SCC$Short.Name, ignore.case=TRUE)
coal.sources <- SCC[coal,]

# Find emissions from coal combustion-related sources
emissions <- NEI[(NEI$SCC %in% coal.sources$SCC), ]

# group by year
emissions.by.year <- aggregate(Emissions ~ year, data=emissions, FUN=sum)

library(ggplot2)

#Output to the graphics device, PNG
png(file = "plot4.png", width = 480, height = 480, units = "px")
ggplot(emissions.by.year, aes(x=factor(year), y=Emissions)) +
        geom_bar(stat="identity") +
        xlab("year") +
        ylab(expression("total PM'[2.5]*' emission  unit: tones")) +
        ggtitle("Emissions from coal combustion-related sources")
dev.off()