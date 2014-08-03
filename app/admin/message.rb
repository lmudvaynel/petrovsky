# encoding: utf-8
ActiveAdmin.register Message do
  menu :priority => 2
  permit_params :content, :showed, :description

  index do
    column :id do |message|
      link_to message.id, admin_message_path(message)
    end
    column :showed do |message|
      message.showed ? 'ДА' : 'НЕТ'
    end
    default_actions
  end

  form do |f|
    f.inputs "Сообщение" do
      f.input :content
      f.input :showed
      f.input :description
    end
    f.actions
  end

end
