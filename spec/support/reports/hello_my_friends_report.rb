class HelloMyFriendsReport < Dossier::Report
  def sql
    "select * from employees where friends = true and me = :self group by this is not a real query"
  end
end
