Sequel.migration do
  up do
    create_table(:repos) do
      primary_key :id
      String :organization, null: false
      String :name, null: false
      TrueClass :to_process, default: false
    end
  end

  down do
    drop_table(:repos)
  end
end