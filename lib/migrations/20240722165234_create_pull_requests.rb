# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:pull_requests) do
      primary_key :id
      datetime :pr_creation, null: false
      String :user_name, null: false
      String :url, null: false
      String :repository, null: false
      Fixnum :number, null: false
    end
  end

  down do
    drop_table(:pull_requests)
  end
end
