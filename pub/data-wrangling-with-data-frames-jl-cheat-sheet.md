@def title = "Data Wrangling with DataFrames.jl Cheat Sheet"
@def disqus = true
@def page_id = "3cfc1404"
@def rss = "This page contains the Data Wrangling with DataFrames Cheat Sheet."
@def rss_pubdate = Date(2020, 9, 9)

\blogtitle{Data Wrangling with DataFrames.jl Cheat Sheet}
\blogdate{Sep 9, 2020}

![](/assets/pages/data-wrangling-with-data-frames-jl-cheat-sheet/banner.png)

### Download your own copy of PDF

- [Cheat Sheet for DataFrames.jl v0.21.x](/assets/pages/data-wrangling-with-data-frames-jl-cheat-sheet/DataFramesCheatSheet_v0.21.pdf)

### Where to get the data

The examples are based on the [Kaggle Titanic data set](https://www.kaggle.com/c/titanic/data).
You can use the following code to download the data:

```julia
using DataFrames
using CSV

function download_titantic()
    url = "https://www.openml.org/data/get_csv/16826755/phpMYEkMl"
    return DataFrame(CSV.File(download(url); missingstring = "?"))
end
```

If you have any questions/suggestions about this cheat sheet, please submit an issue to
to [this GitHub repo](https://github.com/tk3369/www.ahsmart.com/issues).

