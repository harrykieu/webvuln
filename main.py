import source.core.backendFlask as beFlask
import source.core.backend as be

if __name__ == '__main__':
    beFlask.app.run(debug=True, use_reloader=False)
