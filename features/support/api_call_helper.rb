class ApiCall
  @@last_response = nil
  @@base_url = nil

  def self.post(url_path, request_settings={})
    request_settings['Content-Type'] = 'application/json'
    request(:post, get_uri(url_path), request_settings)
  end

  def self.get(url_path, request_settings={})
    request(:get, get_uri(url_path), request_settings)
  end

  def self.patch(url_path, request_settings={})
    request_settings['Content-Type'] = 'application/json'
    request(:patch, get_uri(url_path), request_settings)
  end

  def self.set_base_url(url_path)
    @@base_url = url_path
  end

  def self.get_uri(url_path)
    URI(@@base_url + url_path)
  end

  def self.request(request_type, uri, request_settings={})
    request = case request_type
              when :get
                Net::HTTP::Get.new(uri.request_uri)
              when :post
                Net::HTTP::Post.new(uri.request_uri)
              when :patch
                Net::HTTP::Patch.new(uri.request_uri)
              end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    if(request_settings.has_key? :body)
      request.body = request_settings[:body].to_json
      request_settings.delete :body
    end

    request_settings.each { |header_key, header_value|
      request[header_key] = header_value
    }

    response_object = nil
    time = Benchmark.measure do
      response_object = http.request(request)
    end
    response = parse_response(response_object)
    response[:time] = time.real

    # just for my debug purposes
    if ENV['DEBUG']=='1'
      puts "Request(#{request_type.to_s}): #{uri.to_s}"
      headers = {}
      request.each_header do |header_name, header_value|
        headers[header_name] = header_value
      end
      puts "Request header: #{headers}"
      puts "Request body: #{request.body}" if !request.body.nil? && request.body.length > 0
      puts "Request took #{response[:time]}s"
      puts 'Response body:' + response[:body].to_json
      puts '--------------------------------------------------------------------------------'
    end
    @@last_response = response
  end

  def self.get_last_response
    @@last_response
  end

  def self.parse_response(response)
    result            = {}
    result[:code]     = response.code.to_i
    result[:header]   = response.header.to_s
    result[:body]     = (result[:code] < 299) ? JSON.parse(response.body) : response.body
    result[:response] = response
    result
  end

  def self.parse_last_response
    parse_response(@@last_response)
  end
end
