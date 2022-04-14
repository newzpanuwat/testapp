require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "#Fields" do
    it { should have_db_column(:name).of_type(:string) }
  end

  describe "#Validation" do
    let!(:my_category)           { FactoryBot.create(:category) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "#Association" do
    it { should have_many(:products) }
  end
end
