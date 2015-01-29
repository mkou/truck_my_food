require File.expand_path('../application', __FILE__)

use Rack::Static, :urls => [
    "/css",
    "/images",
    "/scripts",
    "/bower_components",
    "/api/docs"
  ], :root => "public", index: 'index.html'

map "/" do
  run API::Root
end