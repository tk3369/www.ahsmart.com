# Add a sister pager to support pre-v1.0 Franklin paths
# This is needed for all blog posts released prior to Jun 1, 2020
# Usage: {{ add_sister }}
function hfun_add_sister()
    rpath = splitext(locvar(:fd_rpath))[1] # path/file
    sister_url = rpath * ".html" # path/file.html
    redirect_html = 
        """
        <!-- REDIRECT -->
        <!DOCTYPE html>
        <html>
          <head>
            <meta http-equiv="refresh" content="0; url=/$rpath/" />
          </head>
        </html>
        """
    write(joinpath("__site", sister_url), redirect_html)
    return ""
end

function hfun_disqus()
    id = locvar(:page_id)
    s = """
        <hr>
        <div id="disqus_thread">
            <div id="disqus_thread_loader">Loading Comments...</div>
        </div>
        <script>
        var disqus_config = function () {
            this.page.url = window.location.href;
            this.page.identifier = '$id';
        };
        var disqus_observer = new IntersectionObserver(function(entries) {
            // comments section reached
            // start loading Disqus now
            if(entries[0].isIntersecting) {
                (function() {
                    var d = document, s = d.createElement('script');
                    s.src = 'https://ahsmart.disqus.com/embed.js';
                    s.setAttribute('data-timestamp', +new Date());
                    (d.head || d.body).appendChild(s);
                })();

                // once executed, stop observing
                disqus_observer.disconnect();
            }
        }, { threshold: [0] });
        disqus_observer.observe(document.querySelector("#disqus_thread"));
        </script>
        <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
        """
    return s
end
