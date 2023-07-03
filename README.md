# saudi_YT

Repo for analyzing YT recommendations in Saudi Arabia

## Current Approach
1. Obtain videos mentioning MBS.
2. Extract the video id of each video mentioning MBS.
3. Acquire related videos for each of these videos.
4. Gather the transcripts and descriptions of these videos.

## TODO with Current Data
1. Choose the top 100 channels returned.
2. Fetch information on every video from these channels.
3. Obtain the video descriptions and transcripts for all of these videos.
4. Generate our embedding layer from the combined descriptions and/or transcripts of these videos.
5. Project video descriptions of MBS onto a positive-negative index (refer to this [paper](https://osf.io/68zn4/)) to get bias scores.
6. Assess whether the algorithm directs to more negative or more positive channels (in relation to MBS).
   - This can be achieved by repeatedly querying the API for 100 randomly selected videos from a given channel.
7. Determine the overall direction of travel by taking, for instance, the average of channel bias scores from the 50 recommended for a seed video.

## TODO Robustness Checks
1. Use a VPN from Saudi and check for any differences.
2. Compare between API related videos and user-related videos using a platform walkthrough qualitative approach.
   - This is because, according to YouTube, the related videos endpoint doesn't necessarily reflect the actual related videos.
3. Conduct the same search but for accounts with viewing histories.
   - Uncertain if this is possible when using my Google account and associated OAuth.