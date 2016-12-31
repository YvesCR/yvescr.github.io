
## build the blog:

# check the path.
getwd()

# serve the blog subfolder:
servr::jekyll(input = "_source", output = "_posts", script = c("Makefile", "build.R"))



