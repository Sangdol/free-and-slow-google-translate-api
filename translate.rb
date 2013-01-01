require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'
require 'google_drive'
require 'rack/contrib/jsonp'

# Need "callback" query string parameter
use Rack::JSONP

session = GoogleDrive.login(ENV['GOOGLE_ID'], ENV['GOOGLE_PASSWD'])
ws = session.spreadsheet_by_key(ENV['SPREADSHEET_KEY']).worksheets[0]

MAX_ROW_NUMBER = 1000
row = 0;

get '/translate' do
	content_type :json

	start_time = Time.now
	from = params[:from]
	to = params[:to]
	texts = params[:text]
	result = {}

	if texts.is_a? String
		texts = [texts]
	end

	row = (row + 1) % MAX_ROW_NUMBER

	# Call script from spreadsheet
	texts.each_with_index do |text, index|
		ws[row, index + 1] = "=GoogleTranslate(\"#{text}\", \"#{from}\", \"#{to}\")"
	end

	# Save and reload the worksheet to get my changes effect
	ws.save
	ws.reload

	texts.each_with_index do |text, index|
		result[text] = ws[row, index + 1]
	end

	result[:elapased_time] = Time.now - start_time
	result.to_json
end
