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

#Extract the desired data, Baltimore
Baltimore <- subset(NEI, fips == "24510")

#Sum up all emissions by years 
total <- aggregate(Emissions ~ year + type, Baltimore, sum)

library(ggplot2)

#Output to the graphics device, PNG
png(file = "plot3.png", width = 480, height = 480, units = "px")
ggplot(total, aes(x=factor(year), y=Emissions, fill=type)) +
        geom_bar(stat="identity") +
        facet_grid(. ~ type) +
        xlab("year") +
        ylab(expression("total PM'[2.5]*' emission  unit: tones")) +
        ggtitle(expression("PM"[2.5]*paste(" emissions in Baltimore ",
                                           "City by source types", sep="")))
dev.off()