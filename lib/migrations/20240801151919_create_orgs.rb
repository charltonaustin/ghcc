# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:orgs) do
      primary_key :id
      TrueClass :to_process
      String :name
    end
  end

  down do
    drop_table(:orgs)
  end
end
