# frozen_string_literal: true

def add_repo(db, org, name)
  Repos.save(db, org, name)
end
