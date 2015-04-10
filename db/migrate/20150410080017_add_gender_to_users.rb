class AddGenderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :full_name, :string
    add_column :users, :introduction, :text
  end
end
