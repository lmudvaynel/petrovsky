class PagesController < ApplicationController
  def index
    @page = Page.find_by_slug(:home)
    render :show
  end

  def show
    @page = Page.friendly.find(params[:slug])
  end
end
