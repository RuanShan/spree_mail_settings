module Spree
  module Admin
    class MailMethodsController < BaseController
      def update
        params.delete(:smtp_password) if params[:smtp_password].blank?

        Spree::Store.current.attributes = permitted_resource_params
        Spree::Store.current.save!
        
        flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:mail_method_settings))
        redirect_to edit_admin_mail_method_url
      end

      def testmail
        if TestMailer.test_email(try_spree_current_user.email).deliver_now
          flash[:success] = Spree.t('mail_methods.testmail.delivery_success')
        else
          flash[:error] = Spree.t('mail_methods.testmail.delivery_error')
        end
      rescue => e
        flash[:error] = Spree.t('mail_methods.testmail.error', e: e)
      ensure
        redirect_to edit_admin_mail_method_url
      end

      def permitted_resource_params
        attrs = [  :mail_host, :mail_domain,:mail_port, :secure_connection_type, :mail_auth_type, :smtp_username, :smtp_password ]
        params.permit( attrs )
      end
    end
  end
end
