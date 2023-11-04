@def title = "Data Wrangling with DataFrames.jl Cheat Sheet"
@def disqus = true
@def page_id = "3cfc1404"
@def rss = "Official site for the Data Wrangling with DataFrames.jl Cheat Sheet."
@def rss_pubdate = Date(2021, 5, 13)

\blogtitle{Data Wrangling with DataFrames.jl Cheat Sheet}
\blogdate{May 13, 2021}

![banner image](/assets/pages/data-wrangling-with-data-frames-jl-cheat-sheet/banner.png)

### Download your own PDF copy

- [Cheat Sheet for DataFrames.jl v1.x (English)](/assets/pages/data-wrangling-with-data-frames-jl-cheat-sheet/DataFramesCheatSheet_v1.x_rev1.pdf)
- [Cheat Sheet for DataFrames.jl v1.x (Chinese)](/assets/pages/data-wrangling-with-data-frames-jl-cheat-sheet/DataFramesCheatSheet_v1.x_rev1_zh.pdf)

Credit: 
- Chinese translation by [zy](https://github.com/zsz00)

### Where to get the data

The examples are based on the [Kaggle Titanic data set](https://www.kaggle.com/c/titanic/data).
You can use the following code to download the data:

```julia
using DataFrames
using CSV

function download_titanic()
    url = "https://www.openml.org/data/get_csv/16826755/phpMYEkMl"
    return DataFrame(CSV.File(download(url); missingstring = "?"))
end
```

### Questions/Suggestions

If you have any questions/suggestions about this cheat sheet, please submit an issue to
to [this GitHub repo](https://github.com/tk3369/www.ahsmart.com/issues).

### Older versions

- [Cheat Sheet for DataFrames.jl v0.22 (2020-11-20)](/assets/pages/data-wrangling-with-data-frames-jl-cheat-sheet/DataFramesCheatSheet_v0.22_rev1.pdf)
- [Cheat Sheet for DataFrames.jl v0.21 (2020-09-19)](/assets/pages/data-wrangling-with-data-frames-jl-cheat-sheet/DataFramesCheatSheet_v0.21_rev3.pdf)
- [Cheat Sheet for DataFrames.jl v0.21 (2020-09-15)](/assets/pages/data-wrangling-with-data-frames-jl-cheat-sheet/DataFramesCheatSheet_v0.21_rev2.pdf)
- [Cheat Sheet for DataFrames.jl v0.21 (2020-09-10)](/assets/pages/data-wrangling-with-data-frames-jl-cheat-sheet/DataFramesCheatSheet_v0.21.pdf)

