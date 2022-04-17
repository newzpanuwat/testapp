require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "#Fields" do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:qty).of_type(:integer) }
  end

  describe "#Association" do
    it { should belong_to(:category).class_name('Category') }
  end

  describe "#Validation" do
    let!(:my_category)           { FactoryBot.create(:category) }
    let!(:prd)                   { FactoryBot.build(:product) }

    before do
      prd.category_id = my_category.id
      prd.save!
    end

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_uniqueness_of(:name).scoped_to(:category_id) }

    it { should validate_presence_of(:qty) }
    it { should validate_numericality_of(:qty) }
  end
end
