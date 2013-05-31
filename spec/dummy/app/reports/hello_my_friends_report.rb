class HelloMyFriendsReport < Dossier::Report
  def sql
    # Doesn't matter; not meant to be run.
    "select * from employees"
  end
end
