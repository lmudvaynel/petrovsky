class OrderMailer < ActionMailer::Base
  default from: "petrovsky@apart.house.com"

  def order_email(user, apartment)
    @user, @apartment = user, apartment

    mail  to: AdminUser.all.map(&:email),
          subject: 'Заказ апартаментов'
  end
end
