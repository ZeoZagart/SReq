require("uri")
require("net/http")
require("json")

module SReq
	extend self

	# Example: 
	#	>> SReq::create_url("https://cardanoscan.io/", "/transaction/{{id}}/", ["name", "age"])
	#	=> https://cardanoscan.io/transaction/{{id}}?name={{name}}&age={{age}}
	def create_url(base, added, path_params = [])
		url = trim(base, "/") + "/" + trim(added, "/")
		return url if path_params.empty?
		url = url + "?"
		path_params.each do |name|
			url += "#{name}={{#{name}}}&"
		end
		trim(url, "&")
	end

	def GET(url, data = {})
		url = fill_url_data(url, data)
		puts "making request: #{url}"
		uri = URI(url)
		Net::HTTP.get_response(uri)
	end

	def POST(url, data = {})
		url = fill_url_data(url, data)
		puts "making request: #{url} with data: #{data}"
		uri = URI(url)
		Net::HTTP.post_form(uri, data)
	end

	def test
		base_url = "https://cardanoscan.io/".freeze
		generated_url = SReq::create_url(base_url, "transaction/{{id}}", ["name", "age"]).freeze
		expected_url = "https://cardanoscan.io/transaction/{{id}}?name={{name}}&age={{age}}"
		raise "Output: #{generated_url}, Expected: #{expected_url}" unless generated_url == expected_url
		data = {"id" => "0x123", "age" => 23, "name" => "Oswald"}
		filled_url = fill_url_data(generated_url, data)
		expected_url = "https://cardanoscan.io/transaction/#{data["id"]}?name=#{data["name"]}&age=#{data["age"]}"
		raise "Output: #{filled_url}, Expected: #{expected_url}" unless filled_url == expected_url
		puts "Test succeeded generating: #{expected_url}"
	end

	private
	def trim(inp_str, chars)
		str = inp_str.dup
		chars.each_char do |c|
			deleted = "1"
			while !deleted.nil?
				deleted = str.delete_prefix!(c)
				deleted ||= str.delete_suffix!(c)
			end
		end
		str
	end


	# Example: 
	#	>> SReq::fill_url_data("https://cardanoscan.io/transaction/{{id}}?name={{name}}&age={{age}}", {"id" => "0x123", "age" => 23, "name" => "Oswald"})
	#	=> https://cardanoscan.io/transaction/0x123?name=Oswald&age=23
	def fill_url_data(url, data)
		param_format = /\{\{([a-zA-Z]*)\}\}/
		url.gsub(param_format).each do |m|
			s = trim(m, "{}")
			data[s] || m
		end
	end

end