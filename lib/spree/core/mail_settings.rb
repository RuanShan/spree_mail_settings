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
        #ActionMailer::Base.default_url_options[:host] ||= Spree::Store.current.url if Spree::Store.table_exists?
      end

      def mail_server_settings
        settings = if need_authentication?
                     basic_settings.merge(user_credentials)
                   else
                     basic_settings
                   end
        # do not pass domain if domain is blank?
        settings.delete( :domain ) if settings[:domain].blank?
        settings[:enable_starttls_auto] = secure_connection?
        settings
      end

      private

      def user_credentials
        {
          user_name: current_settings[:user_name],
          password: current_settings[:password]
        }
      end

      def basic_settings
        {
          address: current_settings[:address],
          domain: current_settings[:domain],
          port: current_settings[:port],
          authentication: current_settings[:authentication]
        }
      end

      def need_authentication?
        current_settings[:authentication] != 'None'
      end

      def secure_connection?
        current_settings[:secure_connection_type] == 'TLS'
      end

      def current_settings
        return @current_settings if @current_settings.present?

        if Spree::Store.current.mail_host.present? && Spree::Store.current.smtp_username.present?
          @current_settings = {
            address: Spree::Store.current[:mail_host],
            domain: Spree::Store.current[:mail_domain],
            port: Spree::Store.current[:mail_port],
            authentication: Spree::Store.current[:mail_auth_type],
            user_name: Spree::Store.current[:smtp_username],
            password: Spree::Store.current.smtp_password
          }
        else
          @current_settings = default_settings
        end

        @current_settings
      end

      def default_settings
        case ActionMailer::Base.delivery_method
        when :spree, :smtp
          ActionMailer::Base.smtp_settings.dup
        when :sendmail #mainly for test
          ActionMailer::Base.sendmail_settings.dup
        else
          {}
        end

      end

    end
  end
end
