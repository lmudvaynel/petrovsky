# encoding: utf-8
ActiveAdmin.register Apartment do
  permit_params :image, :dx, :dy, :number, :floor_number, :sold_out

  index do
    column :floor_number
    column :number
    column :dx
    column :dy
    column :sold_out do |apartment|
      apartment.sold_out ? 'YES' : 'NO'
    end
    default_actions
  end

  show do |apartment|
    attributes_table do
      row 'Image' do
        image_tag apartment.image.url
      end
      row :dx
      row :dy
      row :number
      row :floor_number
      row :sold_out do
        apartment.sold_out ? 'YES' : 'NO'
      end
    end
  end

  form partial: 'form'

end
