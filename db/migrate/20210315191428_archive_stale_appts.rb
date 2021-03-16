class ArchiveStaleAppts < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :is_stale, :boolean, default: false
  end
end
