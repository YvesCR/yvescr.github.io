
## build the blog:

# check the path.
getwd()

# serve the blog subfolder:
servr::jekyll(input = "_source", output = "_posts", script = c("build.R"),
            command = "jekyll build --destination ../yvescr.github.io/")

# manual hack for embedocpu: get rid of line "<script src="https://data-laborer.eu/assets/js/main.min.js"></script>" 
# because it creates a bug in the matrix in case of my own js

get_rid_js <- function(x) {
  
  art <- readLines(paste0("../yvescr.github.io/", x, "/index.html"))
  art <- art[!grepl('<script src="https://data-laborer.eu/assets/js/main.min.js"></script>', art)]
  cat(art, file=paste0("../yvescr.github.io/", x, "/index.html"), quote = F, fill=T)
}

lapply(X = c("hack/embedocputest", "hack/Presentation_of_the_Ropencorporate_package",
        "hack/Second_ropencorporate_pckg", "data visualisation/MapUKpartI", "Statistic/RTNSE_blog"),
       FUN = get_rid_js)
