class SettingsController < ApplicationController
  before_action :set_setting

  def update
    @setting.update setting_params
    respond_with_bip @setting
  end

  private
  def set_setting
    @setting = Setting.find(params[:id])
  end

  def setting_params
    params.require(:setting).permit(:value)
  end

end
