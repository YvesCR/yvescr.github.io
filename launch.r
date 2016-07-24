
## build the blog:

# library servr
pacman::p_load(servr)

# check the path. Should be "C:/blog/gen"
getwd()

# we don't wantsplitted images
options("base64_images")


# serve the blog subfolder: basically, the dev version
jekyll(dir = ".", input = "_source", output = "_posts", script = c("Makefile", "build.R")
       , command = "jekyll build --destination ../blog/")


# serve the blog:
jekyll(dir = ".", input = "_source", output = "_posts", script = c("Makefile", "build.R")
         , command = "jekyll build --destination ../yvescr.github.io/")

