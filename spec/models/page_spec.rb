require 'spec_helper'

describe Page do
  let(:page) { FactoryGirl.create :page }

  it 'should be valid with valid attributes' do
    page.should be_valid
  end

  describe '#content' do
    it 'should be valid html' do
      ['<div>', '</div>', '<div></span>'].each do |html|
        page.content = html
        page.should have(1).errors_on(:content)
      end
      page.content = "<div>Strange hedgehogs</div><a href='light'>is illuminated</a>"
      page.should be_valid
    end
  end

  describe '#name' do
    it 'should not be empty' do
      page.name = ' '
      page.should have(1).errors_on(:name)
    end
  end

  describe '#slug' do
    it 'should not be empty' do
      page.slug = ' '
      page.should have(1).errors_on(:slug)
    end

    it 'should be unique' do
      another_page = FactoryGirl.build :page, slug: page.slug
      another_page.should have(1).errors_on(:slug)
    end
  end
end
