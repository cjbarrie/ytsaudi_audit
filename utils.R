get_recommended_videos <-
  function (video_id = NULL,
            max_results = 50,
            safe_search = "none",
            ...)
  {
    if (!is.character(video_id))
      stop("Must specify a video ID.")
    if (max_results < 0 | max_results > 50) {
      stop("max_results only takes a value between 0 and 50.")
    }
    querylist <- list(
      part = "snippet",
      relatedToVideoId = video_id,
      type = "video",
      maxResults = max_results,
      safeSearch = safe_search
    )
    res <- tuber_GET("search", querylist, ...)
    resdf <- read.table(
      text = "",
      col.names = c(
        "video_id",
        "rel_video_id",
        "publishedAt",
        "channelId",
        "title",
        "description",
        "thumbnails.default.url",
        "thumbnails.default.width",
        "thumbnails.default.height",
        "thumbnails.medium.url",
        "thumbnails.medium.width",
        "thumbnails.medium.height",
        "thumbnails.high.url",
        "thumbnails.high.width",
        "thumbnails.high.height",
        "channelTitle",
        "liveBroadcastContent"
      )
    )
    if (length(res$items) != 0) {
      rel_video_id <- sapply(res$items, function(x)
        unlist(x$id$videoId))
      simple_res <- lapply(res$items, function(x)
        unlist(x$snippet))
      resdf <-
        cbind(video_id = video_id,
              rel_video_id = rel_video_id,
              plyr::ldply(simple_res, rbind))
      resdf <- as.data.frame(resdf)
    }
    else {
      resdf[1, "video_id"] <- video_id
    }
    cat("Total Results", res$pageInfo$totalResults, "\n")
    resdf
  }

tuber_GET <- function(path, query, ...) {
  yt_check_token()
  
  req <-
    httr::GET(
      "https://www.googleapis.com",
      path = paste0("youtube/v3/", path),
      query = query,
      httr::config(token = getOption("google_token")),
      ...
    )
  
  tuber_check(req)
  res <- httr::content(req)
  
  res
}


yt_check_token <- function() {
  if (!yt_authorized()) {
    stop("Please get a token using yt_oauth().\n")
  }
  
}

tuber_check <- function(req) {
  if (req$status_code < 400)
    return(invisible(NULL))
  orig_out <-  httr::content(req, as = "text")
  out <- try({
    jsonlite::fromJSON(orig_out,
                       flatten = TRUE)
  }, silent = TRUE)
  if (inherits(out, "try-error")) {
    msg <- orig_out
  } else {
    msg <- out$error$message
  }
  msg <- paste0(msg, "\n")
  stop("HTTP failure: ", req$status_code, "\n", msg, call. = FALSE)
}
