<!--
Add here global page variables to use throughout your
website.
The website_* must be defined for the RSS to work
-->
@def website_title = "Tom Kwong's Infinite Loop"
@def website_descr = "Technology ideas never end..."
@def website_url   = "hnology ideas never end..."

@def author = "Tom Kwong"

@def mintoclevel = 2

<!--
Add here files or directories that should be ignored by Franklin, otherwise
these files might be copied and, if markdown, processed by Franklin which
you might not want. Indicate directories by ending the name with a `/`.
-->
<!--
@def ignore = ["node_modules/", "franklin", "franklin.pub"]
-->
@def ignore = ["node_modules/"]

@def hasmath = false
@def hascode = true
<!-- Note: by default hasmath == true and hascode == false. You can change this in
the config file by setting hasmath = false for instance and just setting it to true
where appropriate -->

<!-- Enable AddThis widget by default? See https://www.addthis.com/ -->
@def addthis = false

<!-- Enable Disqus widget by default? See https://disqus.com/ -->
@def disqus = false

<!--
Add here global latex commands to use throughout your
pages. It can be math commands but does not need to be.
For instance:
* \newcommand{\phrase}{This is a long phrase to copy.}
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}

<!-- Put a box around something and pass some css styling to the box
(useful for images for instance) e.g.:
\style{width:80%;}{![](path/to/img.png)} -->
\newcommand{\style}[2]{~~~<div style="!#1;margin-left:auto;margin-right:auto;">~~~!#2~~~</div>~~~}

<!-- Blogging commands -->
\newcommand{\splash}[3]{~~~<div><img alt="#1" src="#2"><br/><div class="blog-image-credit">#3</div></div>~~~}

\newcommand{\blogyear}[1]{~~~<div class="blog-year">#1</div>~~~}

\newcommand{\blogmonth}[1]{~~~<div class="blog-month">#1</div>~~~}

\newcommand{\blogtitle}[1]{~~~<h1>#1</h1>~~~}

\newcommand{\blogdate}[1]{~~~<p><span class="blog-date">#1</span></p>~~~}

<!-- More flexible image command with CSS class -->
\newcommand{\image}[3]{~~~<img src="#2" alt="#1" class="#3">~~~}

<!-- generic div with CSS class -->
\newcommand{\textcss}[2]{~~~<div class="#1">#2</div>~~~}

<!-- lazy load image -->
\newcommand{\lazyimage}[2]{~~~<img data-src="#2" alt="#1" class="lazyload">~~~}
\newcommand{\lazyimagestyled}[3]{~~~<img data-src="#2" alt="#1" class="#3 lazyload">~~~}

