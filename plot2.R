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
total <- aggregate(Emissions ~ year, Baltimore, sum)

#Output to the graphics device, PNG
png(file = "plot2.png", width = 480, height = 480, units = "px")
barplot(height= total$Emissions, 
        names.arg= total$year,
        xlab= "Year", 
        ylab= expression('total PM'[2.5]*' emission  unit: tones'),
        main= expression('Total PM'[2.5]*' emissions vs Years in Baltimore'))
dev.off()