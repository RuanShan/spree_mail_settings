  Spree::BaseMailer.class_eval do
    def from_address
      current_settings.mail_from_address.present? ? current_settings.mail_from_address : Spree::Config[:mails_from]
    end

    def bcc_address
      current_settings.mail_bcc
    end

    def mail(headers={}, &block)
      # we have to give delivery method otpions here for threadsafe
      # mail may delivery later by sidekiq
      headers[:delivery_method_options] =  Spree::Core::MailSettings.new.mail_server_settings
      if bcc_address.present?
        headers[:bcc] = bcc_address
      end
      super if Spree::Store.current.enable_mail_delivery
    end


    def current_settings
      Spree::Store.current
    end
  end
