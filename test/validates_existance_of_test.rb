require File.join(File.dirname(__FILE__), 'test_helper')

module MyModule
  class Box < ActiveRecord::Base
    has_many :items
  end

  class Item < ActiveRecord::Base
    belongs_to  :box
    validates_existence_of  :box
  end
end

include MyModule

class ValidatesExistenceOfTest < Test::Unit::TestCase
  def setup
  end

  def test_item_with_valid_id
    box = Box.new
    box.save
    item = Item.new
    item.box_id = box.id
    item.valid?
  end

  def test_item_with_invalid_id
    item = Item.new
    item.box_id = 13
    !item.valid?
  end

  def test_item_without_id
    item = Item.new
    item.valid?
  end

  def test_module_item_with_valid_id
    box = MyModule::Box.new
    box.save
    item = MyModule::Item.new
    item.box_id = box.id
    item.valid?
  end

  def test_module_item_with_invalid_id
    item = MyModule::Item.new
    item.box_id = 13
    !item.valid?
  end

  def test_module_item_without_id
    item = MyModule::Item.new
    !item.valid?
  end
end
