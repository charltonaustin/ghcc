# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:reviews) do
      primary_key :id
      datetime :creation, null: false
      String :user, null: false
      String :url, null: false, unique: true
      String :repository, null: false
    end
  end

  down do
    drop_table(:reviews)
  end
end
