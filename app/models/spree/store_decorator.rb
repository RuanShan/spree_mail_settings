module Spree
  Store.class_eval do
    # Generates password encryption based on the given value.
    def smtp_password=(new_password)
      @smtp_password = new_password
      self.smtp_encrypted_password = self.class.marshal(@smtp_password) if @smtp_password.present?
    end

    def smtp_password
      @smtp_password ||= self.class.unmarshal(read_attribute(:smtp_encrypted_password)) || ''
    end

    #copy from ActiveRecord::SessionStore::ClassMethods
    def self.marshal(data)
      ::Base64.encode64(Marshal.dump(data))
    end

    def self.unmarshal(data)
      Marshal.load(::Base64.decode64(data))
    end

  end
end
