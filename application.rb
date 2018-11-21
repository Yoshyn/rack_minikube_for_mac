# frozen_string_literal: true

require 'json'

class Application
  def self.call(env)
    req = Rack::Request.new(env)
    puts req.path_info
    case req.path_info
    when "/"
      [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
    when "/healthz"
      response = {
        server: true,
        database: database_alive?
      }
      code = database_alive? ? 200 : 503
      [code, {"Content-Type" => "application/json"}, [response.to_json]]
    else
      [404, {"Content-Type" => "text/html"}, ["I'm Lost!"]]
    end
  end

  def self.database_alive?
    true #false
  end
end


rack_minikube_for_mac

setup_minimal_project_minikube_for_mac
