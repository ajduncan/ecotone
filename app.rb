#!/usr/bin/env ruby

ENV['RACK_ENV'] ||= 'production'
ENV['WEBSOCKET_PORT'] ||= '8000'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Faye::WebSocket.load_adapter('thin')

class Ecotone < Sinatra::Base

    set :root, File.dirname(__FILE__)
    set :public_folder, File.dirname(__FILE__) + '/static'
    set :server, :thin

    enable :sessions

    index = lambda do
        erb :index
    end

    messages = lambda do
        if Faye::WebSocket.websocket?(request.env)
            ws = Faye::WebSocket.new(request.env)

            ws.on(:message) do |msg|
                if msg.data == 'pstree'
                    ws.send(`pstree`)
                end
            end

            ws.rack_response
        else
            status 200
            body ''
        end
    end

    get '/', &index
    get '/messages', &messages

end
