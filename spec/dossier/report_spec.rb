require 'spec_helper'

describe Dossier::Report do

  describe "report instances" do
    it "takes options when initializing" do
      @report = TestReport.new(:foo => 'bar')
      @report.options.should eq(:foo => 'bar')
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
          @report.select.should eq("* from employees")
        end

        it "takes a block" do
          TestReport.select { "* from employees" }
          @report.select.should eq("* from employees")
        end

        it "yields it's options to the block" do
          TestReport.select do
            if options[:suspended]
              "name, hired_on from employees"
            else
              "* from employees"
            end
          end
          @report.select.should eq("name, hired_on from employees")
        end
      end

      describe "where" do
        it "takes a string" do
          TestReport.where "foo = 'bar'"
          @report.where.should eq("foo = 'bar'")
        end

        it "takes a block" do
          TestReport.where { "foo = 'bom'" }
          @report.where.should eq("foo = 'bom'")
        end

        it "yields it's options to the block" do
          TestReport.where { "foo = '#{options[:foo]}'" }
          @report.where.should eq("foo = 'baz'")
        end

        it "allows appending to a condition set" do
          TestReport.where { conditions << "foo = 'bat'" }
          @report.where.should eq("foo = 'bat'")
        end

        it "does not have conditions from having in the where" do
          TestReport.having { conditions << "bing = 'bat'" }
          TestReport.where { conditions << "foo = 'bat'" }
          @report.where.should eq("foo = 'bat'")
        end
      end

      describe "having" do
        it "takes a string" do
          TestReport.having "bing = 'bar'"
          @report.having.should eq("bing = 'bar'")
        end

        it "takes a block" do
          TestReport.having { "bing = 'bom'" }
          @report.having.should eq("bing = 'bom'")
        end

        it "yields it's options to the block" do
          TestReport.having { "bing = '#{options[:foo]}'" }
          @report.having.should eq("bing = 'baz'")
        end

        it "allows appending to a condition set" do
          TestReport.having { conditions << "bing = 'bat'" }
          @report.having.should eq("bing = 'bat'")
        end

        it "does not have the conditions from where in the having" do
          TestReport.where { conditions << "foo = 'bat'" }
          TestReport.having { conditions << "bing = 'bat'" }
          @report.having.should eq("bing = 'bat'")
        end
      end

      describe "order" do
        it "takes a string" do
          TestReport.order "salary DESC"
          @report.order.should eq("salary DESC")
        end

        it "takes a block" do
          TestReport.order { "salary DESC" }
          @report.order.should eq("salary DESC")
        end

        it "yields it's options to the block" do
          TestReport.order do
            if options[:suspended]
              "suspended, salary DESC"
            else
              "salary DESC"
            end
          end
          @report.order.should eq("suspended, salary DESC")
        end
      end
    end

    describe "present" do
    end
  end

end
