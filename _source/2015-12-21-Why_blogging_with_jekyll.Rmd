---
layout: post
title: "Why I moved to a jekyll blog"
categories: []
tags: [R, leaflet, jekyll]
date: 2015-12-21
description: Blogging with jekyll and avoiding mister Hyde.
photo_url: logo-jekyll.png
---

Last year, I began this blog using wordpress and ended not really satisfied. Mainly for two reason:

 * I can't include javascript in my posts, including the js produced by the functions of the `htmlwidgets` package.
 * I wasn't able to display on my blog the correct rmarkdown syntax color for my code.
 
After a few research, I decided to move to a jekyll blog, and to use the trio jekyll + rmarkdown + github. 

The combination of jekyll, rmarkdown and github allows to create a nice blog, totally customisable and totally free, as the blog could be freely hosted on github.

It is hard to begin from 0. And thanks to [Yihui Xie](https://github.com/yihui/knitr-jekyll), a template exist.

In a couple of click, it is possible to have a template to work on. And with a little bit of head scratching, it is possible to customise it up to your wishes.

## Jekyll

What is [jekyll](https://jekyllrb.com/)? Jekyll is a generator of static websites and blogs.

How does it works?

 * Write your article in markdown or html format.
 * In the header, add the title, date, description, tags, categories, etc.
 * Put the file in the _posts folder.
 * Execute jekyll. Jekyll test all the files in the _posts folders and when one is modified, convert the file in the final post.
     - Add to the index page the link to the modified/new post.
     - Add to the original source post the widgets, tags, categories, etc.
 * The new post is copied in the destination folder, which is your generated blog. 

## R markdown

[R markdown](http://rmarkdown.rstudio.com/) is a way to include chunks of R code into a markdown document.

In the `servr` package, the `jekyll()` function allows to sets up a web server to serve a jekyll-based website:

With jekyll and R markdown, the update process is different:

 * Execute `jekyll()`.
 * Write your article in a .rmd format.
 * Put your .rmd article in the _source folder.
 * The article is automatically compiled using rmarkdown, creating a .md file in the _posts folder.
 * Jekyll convert the .md to the final post format.

The result could be seen in the web browser automatically refreshed, which make the writing process really easy.


## Github

One great thing with jekyll is that it is possible to host your web site on github.

How Github cooperate with R markdown and Jekyll?

Simply coordinate the static website folder with a github repositery. Then parametise this repositery to be  on a gh-pages branch, et voila!, you could see your website.

In the end, updating the blog is as easy as write a .rmd file and coordinate the generated result to github.

## Issues

In the end, the main issue I get is when it comes to write formulas. To display formulas, I have to knit the .Rmd and manually add the YAML Front Matter in the html page. But otherwise, all is automated.

I didn't found that much websites made that way. But a few people have made similar articles. Among them:

 - [Brendan Rocks](http://brendanrocks.com/blogging-with-rmarkdown-knitr-jekyll/)
 - [Nicole White](https://nicolewhite.github.io/2015/02/07/r-blogging-with-rmarkdown-knitr-jekyll.html)
 - [Nicholas Tierney](http://www.njtierney.com/jekyll/2015/11/11/how-i-built-my-site/)
 - [Nicolas Hery](http://nicolashery.com/fast-mobile-friendly-website-with-jekyll/)
 - [Joshua Lande](http://joshualande.com/jekyll-github-pages-poole/)
 - [IALSA tutorial website](https://ialsa.github.io/tutorials/gh-pages-setup.html)
 
