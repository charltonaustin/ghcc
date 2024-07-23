Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :user_name, null: false, unique: true
      String :name, null: true
    end
  end

  down do
    drop_table(:users)
  end
end