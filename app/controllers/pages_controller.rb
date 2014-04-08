class PagesController < ApplicationController
  def index
    @page = Page.find_by_slug(:home)
    @message = Message.showed.first
  end
  def show
    @page = Page.friendly.find(params[:slug])
    render params[:slug] if controller_view_exists?(params[:slug])
    @apartments_json = Apartment.all.map(&:to_hash).to_json if params[:slug].to_s == 'floor_plans'
  end

  def create_order
    @order = Order.create(params.require(:order).permit(:name, :email, :phone, :content))
    if @order.save
      OrderMailer.order_mail(@order).deliver
      redirect_to root_path
    else
      redirect_to root_path
    end
  end
  private

  def view_exists?(view)
    File.exists? Rails.root.join("app", "views", view)
  end

  def controller_view_exists?(name)
    view_exists?("#{params[:controller]}/#{name}.html.erb")
  end

  def layout_exists?(name)
    view_exists?("layouts/#{name}.html.erb")
  end
end
