class PagesController < ApplicationController
  def index
    @page = Page.find_by_slug(:home)
  end

  def show
    @page = Page.friendly.find(params[:slug])
  end
end
