class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :get_menu

  private

  def get_menu
    @home_page = Page.find_by_slug(:home)
    @pages = Page.for_menu.where_slug_is_not :home
  end
end
