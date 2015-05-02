to setup

~~~
bin/init
~~~


start the server

~~~
bin/http
~~~

sample query
~~~{.js}
g.V("github.com/gin-gonic/gin").Tag('source').Out('depends').Tag('target').Except(g.V('stdlib').In('in')).All()
~~~
