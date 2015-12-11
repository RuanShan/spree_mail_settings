# Allows us to intercept any outbound mail message and make last minute changes
# (such as specifying a "from" address or sending to a test email account)
#
# See http://railscasts.com/episodes/206-action-mailer-in-rails-3 for more details.
module Spree
  module Core
    class MailInterceptor
      def self.delivering_email(message)
        if current_settings[:intercept_email].present?
          message.subject = "#{message.to} #{message.subject}"
          message.to = current_settings[:intercept_email]
        end

        message.bcc ||= current_settings[:mail_bcc] if current_settings[:mail_bcc].present?
      end

      def self.current_settings
        Spree::Store.current
      end

    end
  end
end
