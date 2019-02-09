require "sinatra"

configure do
  set :bind, "0.0.0.0"
  enable :cross_origin
end

before do
  response.headers["Access-Control-Allow-Origin"] = "http://getto.workstation:30080"
  content_type 'application/json'
end

get "/" do
  { message: "hello, world!!" }.to_json
end

post '/upload' do
  unless file = params[:file]
    halt 400
  end
  unless tmpfile = file[:tempfile]
    halt 400
  end

  buffer = ""

  while blk = tmpfile.read(65536)
    buffer += blk
  end

  response.headers["Access-Control-Expose-Headers"] = "x-upload-id"
  response.headers["x-upload-id"] = "3"
  { content: buffer }.to_json
end

options "*" do
  response.headers["Allow"] = "GET,POST,PUT,DELETE,OPTIONS,HEAD"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type, Access-Control-Allow-Origin, Authorization"
  response.headers["Access-Control-Allow-Origin"] = "http://getto.workstation:30080"
end
