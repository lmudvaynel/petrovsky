# encoding: utf-8
ActiveAdmin.register Apartment do
  permit_params :image, :image_sold, :dx, :dy, :number, :floor_number, :sold_out, :price, :area

  index do
    column :image do |apartment|
      link_to image_tag(apartment.image.thumb.url), admin_apartment_path(apartment)
    end
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
      row 'Image Sold' do
        image_tag apartment.image_sold.url
      end
      row :dx
      row :dy
      row :number
      row :floor_number
      row :sold_out do
        apartment.sold_out ? 'YES' : 'NO'
      end
      row :price
      row :area
    end
  end

  form partial: 'form'

end
