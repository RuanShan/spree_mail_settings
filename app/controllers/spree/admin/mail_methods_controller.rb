module Spree
  module Admin
    class MailMethodsController < BaseController
      def update
        permitted_params = permitted_resource_params
        permitted_params.delete(:smtp_password) if permitted_params[:smtp_password].blank?

        Spree::Store.current.update_attributes! permitted_params

        flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:mail_method_settings))
        redirect_to edit_admin_mail_method_url
      end

      def testmail
        if TestMailer.test_email( try_spree_current_user.email ).deliver!
          flash[:success] = Spree.t('testmail.delivery_success')
        else
          flash[:error] = Spree.t('testmail.delivery_error')
        end
      rescue => e
        flash[:error] = Spree.t('testmail.error', e: e)
      ensure
        redirect_to edit_admin_mail_method_url
      end

      def permitted_resource_params
        attrs = [ :enable_mail_delivery, :mail_from_address, :mail_bcc, :mail_host, :mail_domain,:mail_port, :secure_connection_type, :mail_auth_type, :smtp_username, :smtp_password ]
        params.require('store').permit( attrs )
      end
    end
  end
end
