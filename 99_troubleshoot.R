querylist <- list(part = "snippet", relatedToVideoId = startvid, 
                  type = "video", maxResults = 50, safeSearch = "none")

res <- tuber_GET("search", querylist)