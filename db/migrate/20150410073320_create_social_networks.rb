class CreateSocialNetworks < ActiveRecord::Migration
  def change
    create_table :social_networks do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :token
      t.string :token_secret
      t.text :raw_info
      t.boolean :auto_share, default: false
      t.timestamps
    end
  end
end
