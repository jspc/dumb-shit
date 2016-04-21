require 'json'
require 'redis'
require 'securerandom'
require 'sinatra'


redis_host = ENV.fetch('REDIS_HOST', 'localhost')
redis_port = ENV.fetch('REDIS_PORT', 6379)

redis_object = Redis.new(host: redis_host, port: redis_port)

before do
  content_type 'application/json'
end

post '/' do
  uuid = SecureRandom.uuid
  payload = JSON.parse(request.body.read)

  redis_object.set uuid, payload
  return {uuid: uuid}.to_json
end

post '/:uuid' do
  uuid = params[:uuid]

  x = request.body.read
  p x
  payload = JSON.parse(x)

  r = redis_object.set uuid, payload
  p r
  return {uuid: uuid}.to_json
end

get '/:uuid' do
  uuid = params[:uuid]
  redis_object.get uuid
end
