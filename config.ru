require 'rubygems'
require 'bundler'

Bundler.require

require'./translate'
run Sinatra::Application
