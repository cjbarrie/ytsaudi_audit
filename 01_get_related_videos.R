# data collection 
# 27.07.2023 

# load packages 
library(dplyr)
library(tuber)
library(tidylog)
library(stringr)

# load existing data 
d_related <- readRDS("data/output/mbsrelatedvids.rds")
d <- readRDS("data/output/mbsvids.rds")
# no need for the above atm, will focus on recommendations of labelled videos. 
# Erin will take care of other data collection 
d_video_lab <- read.csv("data/Seed_video - OLD video level labelling.csv")

# initialize YT authorization 
yt_oauth("","", token = "")

# get related videos to labelled videos 
set.seed(12345)

# get IDs 
d_video_lab <- d_video_lab %>% mutate(video_id = str_extract(youtube_link, "[^=]+$"))
sampled_ids <- unique(d_video_lab$video_id)

# Initialize an empty dataframe to store related videos
all_rel_vids <- data.frame()
# Loop through sampled IDs and get related videos
for (i in seq_along(sampled_ids)) {
  vid_id <- sampled_ids[[i]]
  cat("Getting related videos for ", sampled_ids[[i]]," number ", i, " of ",length(sampled_ids), "\n")
  rel_vids <- get_related_videos(vid_id, max_results = 30)
  rel_vids$seedvid <- vid_id
  # Bind the related videos to the main dataframe
  all_rel_vids <- bind_rows(all_rel_vids, rel_vids)
  Sys.sleep(10)
}

saveRDS(all_rel_vids, "data/output/labelledrelatedvids_i1.rds")

# see whether this worked 
d_new <- readRDS("data/output/labelledrelatedvids.rds")

# only catched recommendations for half of the labelled videos 
# need to figure out reason for time out, then reiterate process x more times 
