require 'spec_helper'

describe "employee report" do

  before :all do
    insert_employees
  end

  it "creates an HTML report" do
    get '/reports/employee'
    expect(response.body).to eq(
      <<-HTML.strip_heredoc
        <!DOCTYPE html>
        <html>
        <head>
          <title>Dummy</title>
          <link href="/assets/application.css" media="all" rel="stylesheet" type="text/css" />
          <script src="/assets/application.js" type="text/javascript"></script>
          
        </head>
        <body>

        <h1>Employee Report</h1>
        <table>
        <thead>
        <tr>
        <th>Id</th>
        <th>Name</th>
        <th>Hired On</th>
        <th>Suspended</th>
        <th>Division</th>
        <th>Salary</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td>3</td>
        <td>Elise Elderberry</td>
        <td>2013-01-11</td>
        <td>0</td>
        <td>Corporate Malfeasance</td>
        <td>99000</td>
        </tr>
        <tr>
        <td>2</td>
        <td>Jimmy Jackalope</td>
        <td>2013-01-11</td>
        <td>1</td>
        <td>Tedious Toiling</td>
        <td>20000</td>
        </tr>
        <tr>
        <td>1</td>
        <td>Moustafa McMann</td>
        <td>2010-10-02</td>
        <td>0</td>
        <td>Tedious Toiling</td>
        <td>30000</td>
        </tr>
        </tbody>
        </table>
        <a href="/reports/employee.csv" class="download-csv">Download CSV</a>


        </body>
        </html>
      HTML
    )
  end

  it "creates an HTML report" do
    get '/reports/employee', options: {
      salary: true, order: 'desc', 
      names: %w[Adam Nathan Marshall Rod],
      divisions: %w[1 3 5]
    }
    expect(response.body).to eq(
      <<-REPORT.strip_heredoc
        <!DOCTYPE html>
        <html>
        <head>
          <title>Dummy</title>
          <link href="/assets/application.css" media="all" rel="stylesheet" type="text/css" />
          <script src="/assets/application.js" type="text/javascript"></script>
          
        </head>
        <body>

        <h1>Employee Report</h1>
        <table>
        <thead>
        <tr>
        <th>Id</th>
        <th>Name</th>
        <th>Hired On</th>
        <th>Suspended</th>
        <th>Division</th>
        <th>Salary</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
        </table>
        <a href="/reports/employee.csv?options%5Bdivisions%5D%5B%5D=1&amp;options%5Bdivisions%5D%5B%5D=3&amp;options%5Bdivisions%5D%5B%5D=5&amp;options%5Bnames%5D%5B%5D=Adam&amp;options%5Bnames%5D%5B%5D=Nathan&amp;options%5Bnames%5D%5B%5D=Marshall&amp;options%5Bnames%5D%5B%5D=Rod&amp;options%5Border%5D=desc&amp;options%5Bsalary%5D=true" class="download-csv">Download CSV</a>


        </body>
        </html>
      REPORT
    )
  end

end
