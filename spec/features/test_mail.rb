require "mail"
settings ={:address=>"smtp.getstore.cn",
  :port=>25,
  :domain=>"",
  :user_name=>"notice@getstore.cn",
  :password=>"xxxxxxxx",
  :authentication=>"plain",
  :enable_starttls_auto=>false,
  :openssl_verify_mode=>nil,
  :ssl=>nil,
  :tls=>nil}

#{
#    domain: '',
#    enable_starttls_auto: false,
#    openssl_verify_mode: nil,
#    ssl: nil,
#    tls: nil,
#
#    address: 'smtp.getstore.cn',
#    port: 25,
#    user_name: 'notice@getstore.cn',
#    password: 'ps4GetStore',
#    authentication: :plain
#  }

Mail.defaults do
  delivery_method :smtp, settings
end


mail = Mail.new do
  from    'notice@getstore.cn'
  to      'spree@example.com'
  subject 'This is a test email'
  body    'This is a mail body'
end

mail.deliver!
