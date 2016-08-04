import web

#Tells web.py the URL structure. The first part is a regular expresssion that matches a URL.
urls = ('/.*', 'hello')

app = web.application(urls, globals())

class hello:
    def GET(self):
        return 'Hello, world'

if __name__=='__main__':
    app.run()