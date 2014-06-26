# encoding: utf-8

class AddNewPagePenthouses < ActiveRecord::Migration
  def up
    Page.create! slug: :penthouses, name: 'ПЕНТХАУСЫ', title: 'ПЕНТХАУСЫ', content: ''
  end

  def down
    Page.find_by_slug(:penthouses).try :destroy
  end
end
