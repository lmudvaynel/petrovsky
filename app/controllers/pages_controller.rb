class PagesController < ApplicationController
  def index
    @page = Page.find_by_slug(:home)
  end

  def show
    @page = Page.friendly.find(params[:slug])
    @apartments_json = Apartment.all.map(&:to_hash).to_json if params[:slug].to_s == 'floor-plans'
  end
end
