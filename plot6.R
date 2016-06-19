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

#Find out the data with motor vehicle sources in Baltimore City
vehicle.Baltimore <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]
emissions.Baltimore <- aggregate(Emissions ~ year, data=vehicle.Baltimore, FUN=sum)
emissions.Baltimore$County <- "Baltimore City"

#Find out the data with motor vehicle sources in Los Angeles County
vehicle.LA <- NEI[(NEI$fips=="06037") & (NEI$type=="ON-ROAD"),]
emissions.LA <- aggregate(Emissions ~ year, data=vehicle.LA, FUN=sum)
emissions.LA$County <- "Los Angeles County"

#Combine two datasets
combined.emissions <- rbind(emissions.Baltimore, emissions.LA)

library(ggplot2)

#Output to the graphics device, PNG
png(file = "plot6.png", width = 600, height = 600, units = "px")
ggplot(combined.emissions, aes(x=factor(year), y=Emissions, fill=County)) +
        geom_bar(stat="identity") +
        facet_grid(. ~ County) +
        xlab("year") +
        ylab(expression("total PM'[2.5]*' emission  unit: tones")) +
        ggtitle("Emissions of motor vehicle sources \n in Baltimore and Los Angeles (1999~2008)")
dev.off()