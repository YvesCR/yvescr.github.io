local({
  # fall back on '/' if baseurl is not specified
  knitr::opts_knit$set(base.url = 'http://yvescr.github.io/')
  knitr::opts_knit$set(dir.url = 'C:/blog/blog_dev_mm/')
  
  # fall back on 'kramdown' if markdown engine is not specified
  markdown = servr:::jekyll_config('.', 'markdown', 'kramdown')
  
  # see if we need to use the Jekyll render in knitr
  if (markdown == 'kramdown') {
    knitr::render_jekyll(highlight = c("pygments"))
  } else knitr::render_markdown(strict = T)
  
    # input/output filenames are passed as two additional arguments to Rscript
    a = commandArgs(TRUE)
    d = gsub('^_|[.][a-zA-Z]+$', '', a[1])
    knitr::opts_chunk$set(
      fig.path   = sprintf('assets/images/figures/%s/', d),
      cache.path = sprintf('assets/images/cache/%s/', d)
    )
  
  knitr::knit(a[1], a[2], quiet = TRUE, encoding = 'UTF-8', envir = .GlobalEnv)
  
})
