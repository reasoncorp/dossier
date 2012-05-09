class TotalReport < Dossier::Report
  # SELECT business_id, sum( IF( `year` = '2011', amount, 0 ) ) AS A,  
  #   sum( IF( `year` = '2010', amount, 0 ) ) AS B, 
  #   sum( IF( `year` = '2009', amount, 0 ) ) AS C 
  # FROM totals 
  # WHERE business_id IN (233689,233759,234124,234507,235047,235258,235312,235451,235816,235950,236157,236588,237302,237505,237761,238369,238519,239208,239226,239468,239511,239518,239733,239763,240120,241633,242181,242298,243317,243519,243854,244615,244954,245179,245600,245779,245824,265046)
  # GROUP BY business_id
  
  def options
    @options[:businesses] ||= ''
    @options
  end
  
  select <<-SQL
    business_id, 
    sum( IF( `year` = '2011', amount, 0 ) ) AS A,  
    sum( IF( `year` = '2010', amount, 0 ) ) AS B, 
    sum( IF( `year` = '2009', amount, 0 ) ) AS C 
    FROM totals
  SQL

  where do
    conditions << fragment("business_id IN (:businesses)", :businesses => options[:businesses].split(','))
  end

  group "business_id"

end
