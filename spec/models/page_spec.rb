require 'spec_helper'

describe Page do
  let(:page) { FactoryGirl.build(:page) }

  it 'should be valid with valid attributes' do
    page.should be_valid
  end
end
