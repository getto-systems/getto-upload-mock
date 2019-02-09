require "sinatra"

configure do
  set :bind, "0.0.0.0"
end

options "*" do
  headers(
    "Access-Control-Allow-Origin" => "http://getto.workstation:30080",
    "Access-Control-Allow-Methods" => "GET,POST,PUT,DELETE,OPTIONS,HEAD",
    "Access-Control-Allow-Headers" => "Authorization",
  )
end

get "/" do
  content_type 'application/json'
  { message: "hello, world!!" }.to_json
end

post '/upload' do
  halt 400 unless file = (params[:file] && params[:file][:tempfile])

  buffer = ""

  while blk = file.read(65536)
    buffer += blk
  end

  headers(
    "Access-Control-Allow-Origin" => "http://getto.workstation:30080",
    "Access-Control-Expose-Headers" => "X-Upload-ID",
    "X-Upload-ID" => "3",
  )

  content_type 'application/json'
  { content: buffer, token: env["HTTP_AUTHORIZATION"].to_s }.to_json
end
