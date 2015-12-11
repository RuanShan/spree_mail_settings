require "mail"

settings = {
    address:              'smtp.getstore.cn',
    port:                 25,
    user_name:            'notice@getstore.cn',
    password:              ENV['NOTICE_AT_GETSTORE'],
    authentication:       'login',
    openssl_verify_mode: 'none',
    enable_starttls_auto: false  }
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
  to      'notice@dalianshops.com'
  subject 'This is a test email'
  body    'This is a mail body'
end

mail.deliver!
