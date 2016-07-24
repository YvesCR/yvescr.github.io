
## build the blog:

# check the path. Should be "C:/blog/gen"
getwd()

# we don't wantsplitted images
options("base64_images")

# serve the blog subfolder: basically, the dev version
servr::jekyll(dir = ".", input = "_posts"
       , script = c("build.R"), serve = F
       , command = "bundle exec jekyll build")



# serve the blog:
jekyll(dir = "."
       , input = "_source"
       , output = "_posts"
       , script = c("Makefile", "build.R")
       , serve = F
       , command = "jekyll build --destination ../yvescr.github.io/")

