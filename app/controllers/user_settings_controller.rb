class UserSettingsController < ApplicationController
	before_action :set_user_settings, only: [:show, :edit, :update, :destroy]

	def toggle_config_morning_email
    @settings = current_user.settings
    if @settings.receive_morning_emails
      @settings.receive_morning_emails = false
      @settings.save
    else
      @settings.receive_morning_emails = true
      @settings.save
    end
    redirect_to current_user
  end

	private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user_settings]
      params.require(:user_settings).permit(:purchased_dudu, :receive_morning_emails, :view_large_plans)

    end
end
