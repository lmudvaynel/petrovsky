# encoding: utf-8

class FillDescriptionInMessage < ActiveRecord::Migration
  def up
    message = Message.showed.last || Message.last
    if message
      message.update_attribute :description, <<-HTML
Только в мае при покупке апартаментов в Petrovsky Apart House воспользуйтесь уникальной скидкой - 15%! Акция распространяется  на апартаменты от 38 до 100 м&sup2; и двухуровневые пентхаусы на последнем этаже.<br /> <br /> 
Подробности по телефону:  <span id="call_phone_2">(495) 726-72-16</span>
      HTML
    end
  end


  def down
    message = Message.showed.last || Message.last
    if message
      message.update_attribute :description, ''
    end
  end
end
