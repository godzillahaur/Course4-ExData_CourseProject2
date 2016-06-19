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

#Find out the data with motor vehicle sources in Baltimore
vehicle.Baltimore <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]
emissions.Baltimore <- aggregate(Emissions ~ year, data=vehicle.Baltimore, FUN=sum)

library(ggplot2)

#Output to the graphics device, PNG
png(file = "plot5.png", width = 480, height = 480, units = "px")
ggplot(emissions.Baltimore, aes(x=factor(year), y=Emissions)) +
        geom_bar(stat="identity") +
        xlab("year") +
        ylab(expression("total PM'[2.5]*' emission  unit: tones")) +
        ggtitle("Emissions of motor vehicle sources in Baltimore")
dev.off()