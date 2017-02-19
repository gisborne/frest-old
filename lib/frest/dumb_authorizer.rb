require 'frest/erb_file'

module Frest
  module DumbAuthorizer
    @@login_page ||= Frest::ERBFile.new().render('assets/html/dumb_login.html.erb')

    def self.authorize(req:, **c)
      if req.path == "/login"
        login(req: req, **c)
      elsif cookie = req.cookies['login']
        yield req: req, cookie: cookie, **c
      else
        send_login_page(req: req, **c)
      end

    end

    # module_function :authorize



    private

    def self.login(req:, res:, **c)
      res.set_cookie('login', req.params['name'])
    end

    def self.send_login_page(req:, res:, **c)
      res.write @@login_page
      res.status = 200
    end
  end
end
