#!/usr/bin/env ruby

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

class Ecotone < Sinatra::Base

    helpers Sinatra::Streaming

    set :root, File.dirname(__FILE__)
    set :public_folder, File.dirname(__FILE__) + '/static'
    set :server, :thin

    enable :sessions

    index = lambda do
        erb :index
    end

    pstree = lambda do
        content_type :txt

        `pstree`

    end

    log_messages = lambda do
        content_type :txt
        stream do |out|
            out << "DERP\n\n"
        end
    end


    get '/', &index
    get '/pstree', &pstree
    get '/log/messages', &log_messages

end
