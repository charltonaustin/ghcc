Sequel.migration do
  up do
    create_table(:commits) do
      primary_key :id
      datetime :creation, null: false
      String :user_name, null: false
      String :url, null: false
      String :repository, null: false
    end
  end

  down do
    drop_table(:commits)
  end
end