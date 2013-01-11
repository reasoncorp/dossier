class TotalReport < Dossier::Report

  def sql
    <<-SQL.strip_heredoc
      SELECT
        business_id, 
        sum( IF( `year` = '2011', amount, 0 ) ) AS 2011_total,  
        sum( IF( `year` = '2010', amount, 0 ) ) AS 2010_total, 
        sum( IF( `year` = '2009', amount, 0 ) ) AS 2009_total 
      FROM 
        totals
      WHERE
        business_id IN (:businesses)
      GROUP BY
        business_id
    SQL
  end

  def businesses
    options.fetch(:businesses) { '' }.split(',')
  end

  def format_2011_total(value)
    formatter.currency(value)
  end

  def format_2010_total(value)
    formatter.currency(value)
  end

  def format_2009_total(value)
    formatter.currency(value)
  end

end
