module Spree
  module Core
    class MailSettings
      MAIL_AUTH = %w(None plain login cram_md5)
      SECURE_CONNECTION_TYPES = %w(None SSL TLS)

      # Override the Rails application mail settings based on preferences
      # This makes it possible to configure the mail settings through an admin
      # interface instead of requiring changes to the Rails envrionment file
      def self.init
        ActionMailer::Base.delivery_method = :spree
        ActionMailer::Base.default_url_options[:host] ||= Spree::Store.current.url if Spree::Store.table_exists?
      end

      def mail_server_settings
        settings = if need_authentication?
                     basic_settings.merge(user_credentials)
                   else
                     basic_settings
                   end

        settings.merge enable_starttls_auto: secure_connection?
      end

      private

      def user_credentials
        {
          user_name: current_settings.smtp_username,
          password: current_settings.smtp_password
        }
      end

      def basic_settings
        {
          address: current_settings.mail_host,
          domain: current_settings.mail_domain,
          port: current_settings.mail_port,
          authentication: current_settings.mail_auth_type
        }
      end

      def need_authentication?
        current_settings.mail_auth_type != 'None'
      end

      def secure_connection?
        current_settings.secure_connection_type == 'TLS'
      end

      def current_settings
        Spree::Store.current
      end

    end
  end
end
