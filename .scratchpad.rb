require 'oauth2'

id = '9a9d96c5208e8ab44c8e29cafbb979feb2518a21db4ac82c127e69a34754c24a'
secret = '9fa862ba98cb14a8637307c7a92a6559f701503e441d4d927cee5e93de7bbd91'
client = OAuth2::Client.new(id, secret, site: 'http://localhost:3000')
access_token = client.password.get_token('john@jg.com', 'password1')
access_token.token # => "723b315d10fb3b23d9b38fd025f598ad5cdbd9b6f338e8d9ab9baf198d73f66a"

#client = OAuth2::Client.new('the_client_id', 'the_client_secret', :site => "http://example.com")
#access_token = client.password.get_token('user@example.com', 'sekret')
#puts access_token.token
