module Spree
  module Core
    class MailMethod
      def initialize(*)
      end

      def deliver!(mail)
        mailer.deliver!(mail)
      end

      def mailer
        mailer_class.new(settings)
      end

      # method settting is required by mail-2.6.3/lib/mail/message.rb:254:in `deliver!'
      # settings[:return_response] ? response : self
      def settings
        MailSettings.new.mail_server_settings
      end

      private

      def mailer_class
        Rails.env.test? ? Mail::TestMailer : Mail::SMTP
      end

    end
  end
end
