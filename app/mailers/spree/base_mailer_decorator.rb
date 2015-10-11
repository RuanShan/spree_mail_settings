  Spree::BaseMailer.class_eval do

    #before_action :initialize_mail_settings #it is supported by rails4

    def from_address
      Spree::Store.current.mail_from_address
    end

    def mail(headers={}, &block)
      super if Spree::Store.current.enable_mail_delivery
    end

  end
