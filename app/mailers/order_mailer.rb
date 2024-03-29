# encoding: utf-8
class OrderMailer < ActionMailer::Base
  default from: "noreply@petrovsky.ru"

  def order_mail(order)
    @order = order
    mail :to => AdminUser.all.map(&:email),
         :subject => "Заказ апартаментов"
  end
end
