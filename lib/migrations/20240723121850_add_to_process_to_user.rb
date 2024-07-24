Sequel.migration do
  up do
    add_column :users, :to_process, TrueClass, default: false
  end

  down do
    drop_column :users, :to_process
  end
end