# Install ComplexHeatmap if not already installed
if (!requireNamespace("ComplexHeatmap", quietly = TRUE)) {
  install.packages("BiocManager")
  BiocManager::install("ComplexHeatmap")
}

# Load the ComplexHeatmap package
library(ComplexHeatmap)


library(circlize)

library(ape)

setwd("C:/Users/X421/OneDrive - UPV/Escritorio/University of Bern/FALL SEMESTER 2024/Annotation Assembly")


anno_data=read.gff("assembly.fasta.mod.EDTA.TEanno.gff3",na.strings = c(".","?"),GFF3 = T)
head(anno_data)

superfamily_counts <- table(anno_data$type)

#most_abundant_superfamilies <- names(sort(superfamily_counts, decreasing = TRUE))

# Step 2: Identify the most abundant superfamily
most_abundant_superfamily <- names(superfamily_counts)[which.max(superfamily_counts)]

# Step 3: Filter out the most abundant superfamily from the dataframe
filtered_te_annotations <- anno_data[anno_data$type != most_abundant_superfamily, ]

superfamily_counts_2 <- table(filtered_te_annotations$type)

superfamily_counts_2 <- superfamily_counts_2[superfamily_counts_2 > 0]

most_abundant_superfamilies <- names(sort(superfamily_counts_2, decreasing = TRUE))

# Filter for only the most abundant superfamilies
#filtered_te_annotations <- anno_data[anno_data$type %in% most_abundant_superfamilies,]
filtered_te_annotations$seqid <- gsub("contig_","", filtered_te_annotations$seqid)

# Step 1: Filter out unwanted superfamilies from the original data
unwanted_superfamilies <- c("target_site_duplication", "repeat_region", "long_terminal_repeat")

filtered_te_annotations_2 <- filtered_te_annotations[!(filtered_te_annotations$type %in% unwanted_superfamilies), ]

superfamily_counts_3 <- table(filtered_te_annotations_2$type)

superfamily_counts_3 <- superfamily_counts_3[superfamily_counts_3 > 0]

most_abundant_superfamilies <- names(sort(superfamily_counts_3, decreasing = TRUE))

#View(filtered_te_annotations_2)

#IM IN THIS STEP.
fai_data <- read.table("assembly.fasta.fai", sep="\t", header=FALSE)

# rename contig
fai_data$V1 <- gsub("contig_","", fai_data$V1)

# Sort the data by scaffold length (column V2) in descending order
fai_data_sorted <- fai_data[order(-fai_data$V2), ]

# Select the top 20 longest scaffolds
top_20_scaffolds <- fai_data_sorted[1:20, ]

# Check the top 20 scaffolds
print(top_20_scaffolds)

# Create ideogram data
# Column 1: Scaffold names
# Column 2: Start position (0)
# Column 3: End position (scaffold length)
ideogram_data <- data.frame(
  scaffold = top_20_scaffolds$V1,
  start = 0,
  end = top_20_scaffolds$V2
)

# Check ideogram data
head(ideogram_data)


# Initialize circos plot
circos.genomicInitialize(ideogram_data)


# Define colors for the superfamilies
superfamily_colors <- c(
  "red", "blue", "green", "purple", "orange", "yellow", 
  "cyan","magenta"
)  # Adjust based on your needs

# Plot TE density for each superfamily
for (i in 1:length(most_abundant_superfamilies)) {
  # Filter the data for the current superfamily
  superfamily_data <- filtered_te_annotations_2[filtered_te_annotations_2$type == most_abundant_superfamilies[i],]
  
  # Select relevant columns: scaffold (V1), start (V4), and end (V5)
  superfamily_data <- superfamily_data[, c(1, 4, 5)]
  colnames(superfamily_data) <- c("scaffold", "start", "end")
  
  # Plot the density
  circos.genomicDensity(superfamily_data, col = superfamily_colors[i], track.height = 0.1, window.size = 1e6)
}

library(ComplexHeatmap)

# Step 2: Create the legend
legend <- Legend(
  labels = most_abundant_superfamilies,           # Labels of the legend (superfamilies)
  legend_gp = gpar(fill = superfamily_colors),  # Corresponding colors
  title = "Superfamilies",              # Title of the legend
  title_position = "topleft"          # Position of the title
)

# Step 3: Draw the legend on the plot
draw(legend, x = unit(1, "npc") - unit(5, "mm"), y = unit(1, "npc") - unit(5, "mm"), just = c("right", "top"))


# Clear circos plot after usage
circos.clear()
