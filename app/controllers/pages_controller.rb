class PagesController < ApplicationController
  def index
    @page = Page.find_by_slug(:home)
  end

  def show
    @page = Page.friendly.find(params[:slug])
    @apartments_json = Apartment.all.map(&:to_hash).to_json if params[:slug].to_s == 'floor_plans'
  end

  def create_order
    user = { name: params[:order][:name], email: params[:order][:email] }
    apartment = Apartment.find(params[:order][:apartment_id])
    OrderMailer.order_email(user, apartment)
    redirect_to slug_path('floor-plans')
  end
end
