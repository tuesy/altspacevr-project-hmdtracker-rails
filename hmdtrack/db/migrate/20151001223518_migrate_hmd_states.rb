class MigrateHmdStates < ActiveRecord::Migration
  def up
    # reset
    HmdState.delete_all

    # should only be a handful of these so don't need to do batch querying
    Hmd.all.each do |hmd|
      x = HmdState.new
      x.hmd_id = hmd.id
      x.state = hmd.state || :announced
      x.save! # yes, we'd like to know if this breaks
    end

    remove_column :hmds, :state
  end

  def down
    add_column :hmds, :state, :string, limit: 64, null: false, default: :announced
  end
end
