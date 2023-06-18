library(dplyr)
library(tuber)
library(tidylog)
set.seed(123L)
# Initial search parameters
published_before <- "2023-05-23T00:00:00Z"
published_after <- "2023-01-01T00:00:00Z"

# List to hold video dataframes
vids_list <- list()

# Loop until no more videos are found
while (TRUE) {
  # Perform the search
  vids <- yt_search(
    term = "محمد بن سلمان",
    published_before = published_before,
    published_after = published_after
  )
  
  # Check if no videos were found
  if (nrow(vids) == 0) {
    break
  }
  
  # Append the videos to the list
  vids_list <- append(vids_list, list(vids))
  
  # Update the published_before date to the oldest video publication timestamp
  published_before <- min(vids$publishedAt)
}

# Combine all the video dataframes
all_vids <- bind_rows(vids_list)


saveRDS(all_vids, "data/output/mbsvids.rds")

sampled_ids <- unique(all_vids$video_id)

# Initialize an empty dataframe to store related videos
all_rel_vids <- data.frame()
# Loop through sampled IDs and get related videos
for (i in seq_along(sampled_ids)) {
  vid_id <- sampled_ids[[i]]
  cat("Getting related videos for ", sampled_ids[[i]]," number ", i, " of ",length(sampled_ids), "\n")
  rel_vids <- get_related_videos(vid_id, max_results = 50)
  rel_vids$seedvid <- vid_id
  # Bind the related videos to the main dataframe
  all_rel_vids <- bind_rows(all_rel_vids, rel_vids)
}

saveRDS(all_rel_vids, "data/output/mbsrelatedvids.rds")

relvids_numbered <- all_rel_vids %>%
  group_by(channelTitle) %>%
  count() %>%
  arrange(-n)


#TODO
# VPN from Saudi and check for any differences
# Compare between API related videos and user-related videos with platform walkthrough qualitative approach. Because according to YouTube the related videos endpoint doesn't necessarily reflect the actual related videos.
# Do same search but for accounts with viewing histories (not sure if possible when using my Google account and associated OAuth?)
# Collect descriptions of videos and estimate embedding layer
# Project video descriptions of MBS onto positive-negative index (like in this paper https://osf.io/68zn4/) to get bias scores. 
# Estimate whether algorithm directs to more negative or more positive (in relations to MBS) channels.