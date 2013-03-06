def logm ob
  Rails.logger ob if Rails.env.test?
  pp ob if Rails.env.test?
end
def keep_time n=1,&block
  s = Time.now
  yield
  e = Time.now
  t = e - s
  sleep n - t if n > t
end

#ENV["DOMAIN"] = '.lvh.me:3002' if Rails.env.development?
#
class Hash
  def recursive_symbolize_keys!
    symbolize_keys!
    # symbolize each hash in .values
    values.each{|h| h.recursive_symbolize_keys! if h.is_a?(Hash) }
    # symbolize each hash inside an array in .values
    values.select{|v| v.is_a?(Array) }.flatten.each{|h| h.recursive_symbolize_keys! if h.is_a?(Hash) }
    self
  end
end
require 'yajl'
module Taobao
  def self.append_required_options(options)
    options = {
      app_key:     @public_key,
      format:      :json,
      v:           API_VERSION,
      timestamp:   Time.now.strftime('%Y-%m-%d %H:%M:%S'),
      sign_method: :md5
    }.merge options
    options[:sign] = self.create_signature(options)
    options
  end
  def self.parse_to_hash(response)
    result = (response.body[0,1] == '{') ? 
        JSON.parse(response.body, {symbolize_names: true}) :
        Hash.from_xml(response.body).recursive_symbolize_keys!
    raise Taobao::ApiError.new(result) if result.key? :error_response
    result
  end  
end

