require_relative '../support/api_call_helper'

Before do |scenario|
  ApiCall.set_base_url 'https://jsonplaceholder.typicode.com/'
end
