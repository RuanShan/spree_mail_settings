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
          user_name: current_settings[:smtp_username],
          password: current_settings[:smtp_password]
        }
      end

      def basic_settings
        {
          address: current_settings[:mail_host],
          domain: current_settings[:mail_domain],
          port: current_settings[:mail_port],
          authentication: current_settings[:mail_auth_type]
        }
      end

      def need_authentication?
        current_settings[:mail_auth_type] != 'None'
      end

      def secure_connection?
        current_settings[:secure_connection_type] == 'TLS'
      end

      def current_settings
        return @current_settings if @current_settings.present?

        if Spree::Store.current.mail_host.present? && Spree::Store.current.smtp_username.present?
          @current_settings = {
            mail_host: Spree::Store.current[:mail_host],
            mail_domain: Spree::Store.current[:mail_domain],
            mail_port: Spree::Store.current[:mail_port],
            mail_auth_type: Spree::Store.current[:mail_auth_type],
            smtp_username: Spree::Store.current[:smtp_username],
            smtp_password: Spree::Store.current.smtp_password
          }
        else
          @current_settings = default_settings
        end

        @current_settings
      end

      def default_settings
        case ActionMailer::Base.delivery_method
        when :spree, :smtp
          {
            mail_host: ActionMailer::Base.smtp_settings[:address],
            mail_domain: ActionMailer::Base.smtp_settings[:domain],
            mail_port: ActionMailer::Base.smtp_settings[:port],
            mail_auth_type: ActionMailer::Base.smtp_settings[:authentication],
            smtp_username: ActionMailer::Base.smtp_settings[:smtp_username],
            smtp_password: ActionMailer::Base.smtp_settings[:smtp_password]
          }
        when :sendmail #mainly for test
          ActionMailer::Base.sendmail_settings.dup
        else
          {}
        end

      end

    end
  end
end
