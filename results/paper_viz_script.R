library(tidyverse)
library(sf)
library(ggsci)
library(ggplot2) 
theme_set(theme_minimal())

weighted_delays <- read_csv('/Users/shivyucel/Documents/SDS_2021.nosync/SDS_2020-2021/SDS_Thesis/Data/paper_data/weighted_hexagon_data.csv')
weighted_delays$income_quartile = as.factor(weighted_delays$income_quartile)
weighted_delays$in_degree_quartile = as.factor(weighted_delays$in_degree_quartile)


weighted_delays %>%
  rename(income_quartile = Income Quartile,
         in_degree_quartile = In Degree Quartile)
income_quartiles <- c(
  `1` = "Income Quartile 1",
  `2` = "Income Quartile 2",
  `3` = "Income Quartile 3",
  `4` = "Income Quartile 4"
)

plot <-ggplot(data=weighted_delays) + 
  geom_boxplot(mapping=aes(x=in_degree_quartile, y=weighted_ID, group=in_degree_quartile, color = in_degree_quartile), alpha=0.4) + 
  facet_wrap(~income_quartile, nrow=1, labeller = as_labeller(income_quartiles)) + 
  scale_color_lancet() +
  xlab("In-Degree Quartile") + 
  ylab("Weighted Infection Delay") + 
  theme(legend.position="none") 

plot 

indegree_quartiles <- c(
  `1` = "In-Degree Quartile 1",
  `2` = "In-Degree Quartile 2",
  `3` = "In-Degree Quartile 3",
  `4` = "In-Degree Quartile 4"
)

ggplot(data=weighted_delays) + 
  geom_boxplot(mapping=aes(x=income_quartile, y=weighted_ID, group=income_quartile, color = income_quartile), alpha=0.4) + 
  facet_wrap(~in_degree_quartile, nrow=1, labeller = as_labeller(indegree_quartiles)) + 
  scale_color_lancet() +
  xlab("Income Quartile") + 
  ylab("Weighted Infection Delay") + 
  theme(legend.position="none")


ggplot(weighted_delays, aes(x = income)) + 
  geom_histogram(fill='#00468B99', color="black") + 
  xlim(c(0, max(weighted_delays$income))) + 
  scale_x_log10() +
  ylab('Count') + 
  xlab('Average Monthly Income (BRL, log-scale)') + 
  theme(axis.title = element_text(size = 20)) + 
  theme(axis.text = element_text(size = 15))



ggplot(weighted_delays, aes(x = in_degree)) + 
  geom_histogram(fill='#00468B99', color="black") + 
  xlim(c(0, max(weighted_delays$in_degree))) + 
  ylab('Count') + 
  xlab('In-Degree Centrality') + 
  theme(axis.title = element_text(size = 20)) + 
  theme(axis.text = element_text(size = 15))




outbreak_split <- read_csv('/Users/shivyucel/Documents/SDS_2021.nosync/SDS_2020-2021/SDS_Thesis/Data/paper_data/longform_outbreak_split_delays.csv')
outbreak_split$income_quartile = as.factor(outbreak_split$income_quartile)
outbreak_split$in_degree_quartile = as.factor(outbreak_split$in_degree_quartile)

indegree_quartiles <- c(
  `1` = "In-Degree Quartile 1",
  `2` = "In-Degree Quartile 2",
  `3` = "In-Degree Quartile 3",
  `4` = "In-Degree Quartile 4"
)

ggplot(data=outbreak_split) + 
  geom_boxplot(mapping = aes(x=income_quartile, y=infection_delay, color = outbreak_centrality), alpha=0.4) + 
  facet_wrap(~in_degree_quartile, nrow=1, labeller = as_labeller(indegree_quartiles)) + 
  scale_color_lancet() +
  xlab("Income Quartile") + 
  ylab("Weighted Infection Delay") +
  theme(legend.position="bottom", legend.title = element_blank())


income_quartiles <- c(
  `1` = "Income Quartile 1",
  `2` = "Income Quartile 2",
  `3` = "Income Quartile 3",
  `4` = "Income Quartile 4"
)

ggplot(data=outbreak_split) + 
  geom_boxplot(mapping = aes(x=in_degree_quartile, y=infection_delay, color = outbreak_centrality), alpha=0.4) + 
  facet_wrap(~income_quartile, nrow=1, labeller = as_labeller(income_quartiles)) + 
  scale_color_lancet() +
  xlab("In-Degree Quartile") + 
  ylab("Weighted Infection Delay") +
  theme(legend.position="bottom", legend.title = element_blank())



time_saved <- read_csv('/Users/shivyucel/Documents/SDS_2021.nosync/SDS_2020-2021/SDS_Thesis/Data/h3/SIR/time_saved/new_outlier_outbreaks/445.csv')

ggplot(data = select(time_saved, X1, '123')) + 
  geom_line(mapping = aes(x=X1, y=time_saved$'123'), size=1.5) + 
  scale_fill_lancet() +
  geom_point(mapping = aes(x=0, y=6.6), size=4, color='red') + 
  geom_point(mapping = aes(x=30, y=2), size=4, color='red') + 
  geom_point(mapping = aes(x=40, y=0), size=4, color='red') + 
  xlab('Time (t) in Days') + 
  ylab('Infection Delay of Lockdown at Time t')


library(tidyverse)
library(sf)
library(ggsci)
library(ggplot2) 
library(gridExtra)

theme_set(theme_minimal())


time_saved <- read_csv('/Users/shivyucel/Documents/SDS_2021.nosync/SDS_2020-2021/SDS_Thesis/Data/h3/SIR/time_saved/new_outlier_outbreaks/445.csv')


time_saved_long = melt(select(time_saved, 'X1', 0:10), id.vars = 'X1')


p_1 <- ggplot(data = time_saved_long) + 
  geom_line(mapping = aes(x=X1, y=value, color=variable), size=1.5) + 
  xlab('Time (t) in Days') + 
  ylab('Infection Delay at Time t') + 
  ggtitle("(a)") +
  scale_color_lancet() + 
  theme(legend.position="none", axis.text=element_text(size=20),
        axis.title=element_text(size=25), plot.title = element_text(hjust = 0.5, size=20)) +
  scale_y_continuous(limits = c(0, 15)) 


p_1


time_saved_T <- rotate_df(time_saved, cn = T)
time_saved_T_2 <- apply(time_saved_T,2,median)

time_saved$median = time_saved_T_2
p_2 <- ggplot(data=time_saved) +
  geom_line(mapping = aes(x=X1, y=median), size=1.5, color='black') + 
  scale_y_continuous(limits = c(0, 15)) + 
  xlab('Time (t) in Days') +
  ylab('Median Infection Delay \n at Time t') + 
  ggtitle("(b)") +
  scale_color_lancet() +
  theme(legend.position="none", axis.text=element_text(size=20),
        axis.title=element_text(size=25), plot.title = element_text(hjust = 0.5, size=20)) 

grid.arrange(p_1, p_2, ncol=2)