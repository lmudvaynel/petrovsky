# encoding: utf-8

Message.reset_column_information
content = <<-HTML
<div class="sale-wrapper">
  <div class="sale-shadow"></div>
  <div class="sale-info">
    <h3>Беспрецедентная  скидка - <span>15%</span></h3>
    <div class="info">на апартаменты от 38 до 100 м2<br /> и двухуровневые пентхаусы</div>
    <a href="" class="more">ПОДРОБНЕЕ об акции</a>
  </div>
</div>
HTML
description = <<-HTML
Только в мае при покупке апартаментов в Petrovsky Apart House воспользуйтесь уникальной скидкой - 15%! Акция распространяется  на апартаменты от 38 до 100 кв.м и двухуровневые пентхаусы на последнем этаже. Покупателям также предоставляется возможность индивидуальной рассрочки.
<br /> 
Подробности по телефону:  (495) 726-72-16
HTML
Message.create! showed: true, content: content, description: description
