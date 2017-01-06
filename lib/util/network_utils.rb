class Util::NetworkUtils

  def self.valid_url?(url)
    uri = URI.parse(url)
    %w( http https ).include?(uri.scheme)
  rescue
    false
  end

end


