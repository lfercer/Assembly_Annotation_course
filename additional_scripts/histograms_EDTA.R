library(tidyverse)
library(data.table)

#set wd
setwd("C:/Users/X421/OneDrive - UPV/Escritorio/University of Bern/FALL SEMESTER 2024/Annotation Assembly")

# Load the data
anno_data=read.table("assembly.fasta.mod.LTR.intact.gff3",header=F,sep="\t")
head(anno_data)
# Get the classification table
classification=fread("assembly.fasta.mod.LTR.intact.fa.rexdb-plant.cls.tsv")

## NOTE:
# Or get the file by running the following command in bash:
# TEsorter assembly.fasta.mod.EDTA.raw/assembly.fasta.mod.LTR.intact.fa -db rexdb-plant
# It will be named as assembly.fasta.mod.LTR.intact.fa.rexdb-plant.cls.tsv
# Then run the following command in R:
# classification=fread("assembly.fasta.mod.EDTA.raw/assembly.fasta.mod.LTR.intact.fa.rexdb-plant.cls.tsv")

head(classification)
# Separate first column into two columns at "#", name the columns "Name" and "Classification"
names(classification)[1]="TE"
classification=classification%>%separate(TE,into=c("Name","Classification"),sep="#")


# Check the superfamilies present in the GFF3 file, and their counts
anno_data$V3 %>% table()

# Filter the data to select only TE superfamilies, (long_terminal_repeat, repeat_region and target_site_duplication are features of TE)
anno_data_filtered <- anno_data[!anno_data$V3 %in% c("long_terminal_repeat","repeat_region","target_site_duplication"), ]
nrow(anno_data_filtered)
# QUESTION: How Many TEs are there in the annotation file? #225?

# Check the Clades present in the GFF3 file, and their counts
# select the feature column V9 and get the Name and Identity of the TE
anno_data_filtered$named_lists <- lapply(anno_data_filtered$V9, function(line) {
  setNames(
    sapply(strsplit(strsplit(line, ";")[[1]], "="), `[`, 2),
    sapply(strsplit(strsplit(line, ";")[[1]], "="), `[`, 1)
  )
})

anno_data_filtered$Name <- unlist(lapply(anno_data_filtered$named_lists, function(x) {
  x["Name"]
}))

anno_data_filtered$Identity <-unlist(lapply(anno_data_filtered$named_lists, function(x) {
  x["ltr_identity"]
}) )

anno_data_filtered$length <- anno_data_filtered$V5 - anno_data_filtered$V4

anno_data_filtered =anno_data_filtered %>%select(V1,V4,V5,V3,Name,Identity,length) 
head(anno_data_filtered)

# Merge the classification table with the annotation data
anno_data_filtered_classified=merge(anno_data_filtered,classification,by="Name",all.x=T)

table(anno_data_filtered_classified$Superfamily)
# QUESTION: Most abundant superfamilies are? Copia and gypsy

table(anno_data_filtered_classified$Clade)
# QUESTION: Most abundant clades are? #ale 45 and Retand 28?


# Now plot the distribution of TE percent identity per clade 

anno_data_filtered_classified$Identity=as.numeric(as.character(anno_data_filtered_classified$Identity))

anno_data_filtered_classified$Clade=as.factor(anno_data_filtered_classified$Clade)

#ME: remove NAs(they were in anno_data but not in classification, 91 in total)
anno_data_filtered_classified_rm <- na.omit(anno_data_filtered_classified)



# Create a f plots for each Superfamily
plot_sf= ggplot(anno_data_filtered_classified_rm, aes(x = Identity)) +
  geom_histogram(color="black", fill="grey")+
  facet_grid(Superfamily ~ .) +  
  cowplot::theme_cowplot() 


pdf("01_full-length-LTR-RT-superfamily.pdf")
plot(plot_sf)
dev.off()



# Create plots for each clade
plot_cl= ggplot(anno_data_filtered_classified_rm, aes(x = Identity)) +
  geom_histogram(color="black", fill="grey")+
  facet_grid(Clade ~ Superfamily) +  
  cowplot::theme_cowplot()


#ME: to do zoom in only one clade:
# Create plots for the specified clade "Ale"
plot_cl_ale <- ggplot(anno_data_filtered_classified_rm[anno_data_filtered_classified_rm$Superfamily != "unknown" & anno_data_filtered_classified_rm$Clade == "Ale", ], aes(x = Identity)) +
  geom_histogram(color = "black", fill = "grey") +
  facet_grid(Clade ~ Superfamily) +  
  cowplot::theme_cowplot()

# Create plots for the specified clade "Retand"
plot_cl_retand <- ggplot(anno_data_filtered_classified_rm[anno_data_filtered_classified_rm$Superfamily != "unknown" & anno_data_filtered_classified_rm$Clade == "Retand", ], aes(x = Identity)) +
  geom_histogram(color = "black", fill = "grey") +
  facet_grid(Clade ~ Superfamily) +  
  cowplot::theme_cowplot()

# Get unique clades
clades <- unique(anno_data_filtered_classified_rm$Clade)

# Create an empty list to store plots
plot_list <- list()

# Generate plots for each clade and store them in the list
for (clade in clades) {
  plot_list[[clade]] <- ggplot(anno_data_filtered_classified_rm[anno_data_filtered_classified_rm$Superfamily != "unknown" & anno_data_filtered_classified_rm$Clade == clade, ], aes(x = Identity)) +
    geom_histogram(color = "black", fill = "grey") +
    facet_grid(Clade ~ Superfamily) +  
    cowplot::theme_cowplot() +
    ggtitle(paste("Clade:", clade))  # Optional: Add title to each plot
}

# Access a plot, for example, for the "Retand" clade
plot_list[["Ivana"]]



clades






#--------------------------
# Load necessary library
library(ggplot2)

# Define unique clades
clades <- unique(anno_data_filtered_classified_rm$Clade)

# Create an empty list to store plots
plot_list <- list()

# Generate and store plots for each clade
for (clade in clades) {
  plot_list[[clade]] <- ggplot(
    anno_data_filtered_classified_rm[
      anno_data_filtered_classified_rm$Superfamily != "unknown" & 
        anno_data_filtered_classified_rm$Clade == clade, 
    ], aes(x = Identity)
  ) +
    geom_histogram(color = "black", fill = "grey") +
    facet_grid(Clade ~ Superfamily) +
    cowplot::theme_cowplot() +
    ggtitle(paste("Clade:", clade))  # Optional: Add title to each plot
}

# Save all plots to a single PDF file
pdf("clade_plots.pdf", width = 10, height = 8) # Adjust width and height as needed
for (clade in clades) {
  print(plot_list[[clade]])
}
dev.off()

# Confirmation message
cat("PDF with all clade plots saved as 'clade_plots.pdf'\n")

# Load necessary library
library(ggplot2)

# Define unique clades
clades <- unique(anno_data_filtered_classified_rm$Clade)

# Create an empty list to store plots
plot_list <- list()

# Generate and store plots for each clade with fixed axis scales
for (clade in clades) {
  plot_list[[clade]] <- ggplot(
    anno_data_filtered_classified_rm[
      anno_data_filtered_classified_rm$Superfamily != "unknown" & 
        anno_data_filtered_classified_rm$Clade == clade, 
    ], aes(x = Identity)
  ) +
    geom_histogram(color = "black", fill = "grey", binwidth = 0.05) + # Adjust binwidth as needed
    scale_x_continuous(limits = c(0, 1)) +
    scale_y_continuous(limits = c(0, 20)) +
    facet_grid(Clade ~ Superfamily) +
    cowplot::theme_cowplot() +
    ggtitle(paste("Clade:", clade))  # Optional: Add title to each plot
}

# Save all plots to a single PDF file
pdf("clade_plots_fixed_scales.pdf", width = 10, height = 8) # Adjust width and height as needed
for (clade in clades) {
  print(plot_list[[clade]])
}
dev.off()

# Confirmation message
cat("PDF with all clade plots (fixed scales) saved as 'clade_plots_fixed_scales.pdf'\n")


#--------------------------------------------------------------
#Compare distribution of TE superfamilies in the genome across accesions
#class, accession, %TEmasked
class <- c('Copia','Gypsy','unknown','CACTA','Mutator', 'PIF_Harbinger', 'Tc1_Mariner', 'hAT','helitron')
Stw_0 <- c('1.21','4.58','0.86','0.81','2.37','0.17','0.01','0.17','4.81')
Est_0 <- c('0.86','4.8','0.57','0.65','2.32','0.1','0.05','0.14','4.93')
Ms_0 <- c('1.22','4.50','0.68','0.52','1.9','0.09','0.04','0.21','3.7')
Altai_5 <- c('1.04','4.41','0.68','0.64','3.33','0.2','0.03','0.12','4.07')

library(ggplot2)
library(tidyr)
library(dplyr)

# Combine into a data frame
TE_data <- data.frame(
  class = class,
  Stw_0 = as.numeric(Stw_0),
  Est_0 = as.numeric(Est_0),
  Ms_0 = as.numeric(Ms_0),
  Altai_5 = as.numeric(Altai_5)
)

# Reshape the data for plotting (long format)
TE_data_long <- TE_data %>%
  gather(key = "accession", value = "TE_percentage", -class)

# Plot the bar plot
ggplot(TE_data_long, aes(x = class, y = TE_percentage, fill = accession)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
       x = "TE Superfamily",
       y = "Percentage of TE",
       fill = "Accession") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 14),  # Increase size of x-axis labels
    axis.text.y = element_text(size = 14),  # Increase size of y-axis labels
    axis.title.x = element_text(size = 16),  # Increase size of x-axis title
    axis.title.y = element_text(size = 16),  # Increase size of y-axis title
    legend.title = element_text(size = 16),  # Increase size of legend title
    legend.text = element_text(size = 14)    # Increase size of legend text
  )

#percentage of TE covering, masking the genome.