require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'google_drive'
require 'rack/contrib/jsonp'
require 'json'
require 'yaml'

# Need "callback" query string parameter
use Rack::JSONP

config = YAML.load_file('config.yaml')
session = GoogleDrive.login(config['google_id'], config['google_passwd'])
ws = session.spreadsheet_by_key(config['spreadsheet_key']).worksheets[0]

get '/translate' do
	content_type :json

	start_time = Time.now
	from = params[:from]
	to = params[:to]
	texts = params[:text]
	result = {}

	column = 1 + rand(200)

	# Call cript from spreadsheet
	texts.each_with_index do |text, index|
		ws[index + 1, column] = "=GoogleTranslate(\"#{text}\", \"#{from}\", \"#{to}\")"
	end

	# Save and reload the worksheet to get my changes effect
	ws.save
	ws.reload

	texts.each_with_index do |text, index|
		result[text] = ws[index + 1, column]
	end

	result[:elapased_time] = Time.now - start_time
	result.to_json
end
