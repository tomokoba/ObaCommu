class RenamePhotosImageColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :photos, :image, :image_id
  end
end
