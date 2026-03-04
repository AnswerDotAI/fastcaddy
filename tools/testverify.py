from fasthtml.common import *

app = FastHTML()
rt = app.route

@rt
def index(): return Titled( 'Hello', Div(P('click')))

@rt
def verifydom(domain:str):
    print(domain)
    return Response(status_code=200
                    if domain.strip().lower().startswith(('a','j'))
                    else 404)

serve()

