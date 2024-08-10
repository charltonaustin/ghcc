# frozen_string_literal: true

Sequel.migration do
  up do
    add_column :users, :to_process, TrueClass
  end

  down do
    drop_column :users, :to_process
  end
end
