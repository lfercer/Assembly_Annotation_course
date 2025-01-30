data <- read.table("assembly.all.maker.renamed.gff.AED.txt", header = TRUE, sep = '\t')

colnames(data)[2] <- "CDF"


# Plotting AED distribution as a histogram
library(ggplot2)

# Plot CDF of AED values
ggplot(data, aes(x = AED, y = CDF)) +
  geom_line(color = "blue", size = 1) +
  geom_vline(xintercept = 0.5, linetype = "dashed", color = "red") +
  labs(
    title = "Cumulative Distribution of AED Values",
    x = "Annotation Edit Distance (AED)",
    y = "Cumulative Fraction of Gene Models"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))


#In your file, the line for AED = 0.5 shows a CDF value of 0.978. This means 
#that 97.8% of your gene models have an AED value of 0.5 or lower.

#most of the genes fall within the AED range of 0-0.5, as 97.8% of the gene models have AED values in this range. 
#This indicates high confidence in the majority of the gene models."