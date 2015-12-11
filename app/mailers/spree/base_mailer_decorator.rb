  Spree::BaseMailer.class_eval do

    def mail(headers={}, &block)
      super if Spree::Store.current.enable_mail_delivery
    end

  end
