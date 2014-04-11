# encoding: utf-8

Message.reset_column_information
content = <<-HTML
<div class="sale-wrapper">
	<div class="sale-shadow"></div>
	<div class="sale-info">
		<h3>СКИДКА <span>8%</span></h3>
		<div class="info">В ЧЕСТЬ МЕЖДУНАРОДНОГО<br />ЖЕНСКОГО ДНЯ!</div>
		<a href="" class="more">ПОДРОБНЕЕ об акции</a>
	</div>
</div>
HTML
Message.create! showed: true, content: content
