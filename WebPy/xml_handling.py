import web

render = web.template.render('templates/', cache=False)

urls = ( '/(.*)', 'index')

app = web.application(urls, globals())

class index:
    def GET(self, code):
        web.header('Content-Type', 'text/xml')
        print code
        return render.response(code)

web.webapi.internalerror = web.debugerror

if __name__=="__main__":
    app.run()