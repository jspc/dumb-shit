require 'json'
require 'redis'
require 'securerandom'
require 'sinatra'


redis_host = ENV.fetch('REDIS_HOST', 'localhost')
redis_port = ENV.fetch('REDIS_PORT', 6379)

redis_object = Redis.new(host: redis_host, port: redis_port)

before do
  content_type 'application/json'
  headers 'Access-Control-Allow-Origin'  => '*',
          'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
end

post '/' do
  uuid = SecureRandom.uuid
  payload = JSON.parse(request.body.read)

  redis_object.set uuid, payload
  return {uuid: uuid}.to_json
end

post '/:uuid' do
  uuid = params[:uuid]
  payload = JSON.parse(request.body.read)

  r = redis_object.set uuid, payload
  return {uuid: uuid}.to_json
end

get '/:uuid' do
  uuid = params[:uuid]
  redis_object.get uuid
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

  halt HTTP_STATUS_OK
end
