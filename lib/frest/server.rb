module Frest
  class Server
    require 'rack'
    require 'frest/dumb_authorizer'
    require 'frest/path_store'

    def self.start
      new.start
    end

    def start
      app = Proc.new do |env|
        req = Rack::Request.new(env)
        res = Rack::Response.new

        Frest::DumbAuthorizer.authorize(req: req, res: res) do |req:, res:, cookie:, **c|
          res.write cookie || Frest::DumbAuthorizer::login_page
          res.status = 200
        end

        res.finish
      end


      Rack::Handler::WEBrick.run(
          app,
          Port: ENV['port'], Host: ENV['local_host'])
    end
  end
end
