  Spree::BaseMailer.class_eval do
    def from_address
      Spree::Store.current.mail_from_address.present? ? Spree::Store.current.mail_from_address : Spree::Config[:mails_from]
    end

    def mail(headers={}, &block)
      super if Spree::Store.current.enable_mail_delivery
    end

  end
