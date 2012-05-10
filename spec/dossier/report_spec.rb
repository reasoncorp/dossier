require 'spec_helper'

describe Dossier::Report do

  describe "report instances" do
    it "takes options when initializing" do
      @report = TestReport.new(:foo => 'bar')
      @report.options.should eq('foo' => 'bar')
    end
  end

  describe "DSL" do
    before :each do 
      @report = TestReport.new(:suspended => true, :foo => 'baz')
    end

    describe "query" do
      describe "select" do
        it "takes a string" do
          TestReport.select "* from employees"
          @report.select.should eq("SELECT * from employees")
        end

        it "takes a block" do
          TestReport.select { "* from employees" }
          @report.select.should eq("SELECT * from employees")
        end

        it "yields it's options to the block" do
          TestReport.select do
            if options[:suspended]
              "name, hired_on from employees"
            else
              "* from employees"
            end
          end
          @report.select.should eq("SELECT name, hired_on from employees")
        end
      end

      describe "where" do
        it "takes a string" do
          TestReport.where "foo = 'bar'"
          @report.where.should eq("WHERE foo = 'bar'")
        end

        it "takes a block" do
          TestReport.where { "foo = 'bom'" }
          @report.where.should eq("WHERE foo = 'bom'")
        end

        it "yields it's options to the block" do
          TestReport.where { "foo = '#{options[:foo]}'" }
          @report.where.should eq("WHERE foo = 'baz'")
        end

        it "allows appending to a condition set" do
          TestReport.where { conditions << "foo = 'bat'" }
          @report.where.should eq("WHERE (foo = 'bat')")
        end

        it "does not have conditions from having in the where" do
          TestReport.having { conditions << "bing = 'bat'" }
          TestReport.where { conditions << "foo = 'bat'" }
          @report.where.should eq("WHERE (foo = 'bat')")
        end
      end

      describe "having" do
        it "takes a string" do
          TestReport.having "bing = 'bar'"
          @report.having.should eq("HAVING bing = 'bar'")
        end

        it "takes a block" do
          TestReport.having { "bing = 'bom'" }
          @report.having.should eq("HAVING bing = 'bom'")
        end

        it "yields it's options to the block" do
          TestReport.having { "bing = '#{options[:foo]}'" }
          @report.having.should eq("HAVING bing = 'baz'")
        end

        it "allows appending to a condition set" do
          TestReport.having { conditions << "bing = 'bat'" }
          @report.having.should eq("HAVING (bing = 'bat')")
        end

        it "does not have the conditions from where in the having" do
          TestReport.where { conditions << "foo = 'bat'" }
          TestReport.having { conditions << "bing = 'bat'" }
          @report.having.should eq("HAVING (bing = 'bat')")
        end
      end

      describe "order_by" do
        it "takes a string" do
          TestReport.order_by "salary DESC"
          @report.order_by.should eq("ORDER BY salary DESC")
        end

        it "takes a block" do
          TestReport.order_by { "salary DESC" }
          @report.order_by.should eq("ORDER BY salary DESC")
        end

        it "has it's options in the block" do
          TestReport.order_by do
            if options[:suspended]
              "suspended, salary DESC"
            else
              "salary DESC"
            end
          end
          @report.order_by.should eq("ORDER BY suspended, salary DESC")
        end
      end

      describe "group_by" do
        it "takes a string" do
          TestReport.group_by "business_id"
          @report.group_by.should eq("GROUP BY business_id")
        end

        it "takes a block" do
          TestReport.group_by { "business_id" }
          @report.group_by.should eq("GROUP BY business_id")
        end

        it "has it's options in the block" do
          TestReport.group_by do
            if options[:suspended]
              "suspended"
            else
              "business_id"
            end
          end
          @report.group_by.should eq("GROUP BY suspended")
        end
      end
    end

    describe "sql statement" do
      it "can generate a valid sequel statement" do
        @report = EmployeeReport.new(:names => %w[Long Hunter])
        @report.sql.should eq("SELECT * from employees WHERE (name like '%Long%' or name like '%Hunter%')")
      end
    end

    describe "run" do
      it "will execute the generated sql query" do
        @report = EmployeeReport.new
        Dossier.client.should_receive(:query).with(@report.sql)
        @report.run
      end

      it "will cache the results of the run in `results`" do
        @report = EmployeeReport.new
        Dossier.client.stub(:query).and_return(@mock = mock('results'))
        @report.run
        @report.results.should eq(@mock)
      end
    end

    describe "view" do
      it "will infer its view name from the class name" do
        EmployeeReport.new.view.should eq("employee")
      end
    end

    describe "present" do
    end
  end

end
