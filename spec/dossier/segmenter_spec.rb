require 'spec_helper'

describe Dossier::Segmenter do

  let(:report_class)    { Class.new(Dossier::Report) }
  let!(:segmenter_class) {
    report_class.segmenter_class.tap do |klass|
      klass.instance_eval do
        segment :family
        segment :domestic, display_name: ->(row) { "#{row[:domestic] ? 'Domestic' : 'Wild'} #{row[:group_name]}" } do
          segment :group,  display_name: :group_name, group_by: :group_id
        end
      end
    end
  }
  let(:headers)   { CuteAnimalsReport::HEADERS }
  let(:rows)      { CuteAnimalsReport::ROWS    }
  let(:results)   { mock('Results', headers: headers, rows: rows) }
  let(:report)    { report_class.new.tap { |r| r.stub(:results).and_return(results) } }
  let(:segmenter) { report.segmenter }

  describe "report data" do
    let(:data) {
      {
        'canine.true.10' => [
          ['canine', true,  10, 'foxes', 'fennec',      'tan',    9, true],
          ['canine', true,  10, 'foxes', 'fire',        'orange', 0, false],
        ],
        'canine.false.10' => [
          ['canine', false, 10, 'foxes', 'arctic',      'white',  5, false],
          ['canine', false, 10, 'foxes', 'crab-eating', 'brown',  3, false],
          ['canine', false, 10, 'foxes', 'red',         'orange', 5, false],
        ],
        'canine.true.15' => [
          ['canine', true,  15, 'dog',   'shiba inu',   'tan',    7, true],
          ['canine', true,  15, 'dog',   'labrador',    'varied', 5, true],
          ['canine', true,  15, 'dog',   'beagle',      'mixed',  8, true],
          ['canine', true,  15, 'dog',   'boxer',       'brown',  5, true],
        ],
        'feline.false.22' => [
          ['feline', false, 22, 'tiger', 'bengal',      'orange', 4, false],
          ['feline', false, 22, 'tiger', 'siberian',    'white',  5, false],
        ],
        'feline.false.23' => [
          ['feline', false, 23, 'lion',  'lion',        'tan',    5, false],
        ],
        'feline.true.25' => [
          ['feline', true,  25, 'cat',   'short hair',  'varied', 6, true],
          ['feline', true,  25, 'cat',   'abyssinian',  'tan',    7, true],
          ['feline', true,  25, 'cat',   'persian',     'varied', 6, false],
          ['feline', true,  25, 'cat',   'wirehair',    'grey',   7, true],
        ]
      }
    }

    it "stores the report rows in a hash organized by segment" do
      expect(segmenter.data).to eq(data)
    end
  end

  describe "instances" do
    it "takes a report upon instantiation" do
      expect(segmenter.report).to eq report
    end

    it "has access to the class segment chain" do
      expect(segmenter.segment_chain.length).to eq 3
    end
  end

  describe "class" do
    it "has a reference to the report that created it" do
      expect(segmenter_class.report_class).to eq report_class
    end

    it "determines headers to skip when displaying" do
      expect(segmenter_class.skip_headers.sort).to eq %w[family group_name group_id domestic].sort
    end
  end

  describe "DSL" do
    describe "segment" do
      describe "definition creation" do
        let(:segmenter_class) { report_class.segmenter_class }
        let(:definition)      { segmenter_class.segments.last }

        it "creates a segment definition" do
          segmenter_class.segment :foo
          expect(definition).to be_a Dossier::Segment::Definition
        end

        it "passes the name option" do
          segmenter_class.segment :foo
          expect(definition.name).to eq :foo
        end

        it "passes the group_by option"  do
          segmenter_class.segment :name, group_by: :foo
          expect(definition.group_by).to eq :foo
        end

        it "passes the display_name option" do
          segmenter_class.segment :name, display_name: :foo
          expect(definition.display_name).to eq :foo
        end
      end

      it "keeps an array of segments" do
        expect(segmenter_class.segments.count).to eq 3
      end

      it "keeps the segments in the order defined" do
        expect(segmenter_class.segments[0].name).to eq :family
        expect(segmenter_class.segments[1].name).to eq :domestic
      end

      it "allows nesting segment definations" do
        expect(segmenter_class.segments[2].name).to eq :group
      end
    end
  end

  describe "segment traversal" do

    describe "from the segmenter to the first segment" do
      it "has an array of families" do
        expect(report.segmenter.families.length).to eq 2
      end

      describe "to the second segment" do
        let(:family) { report.segmenter.families.first }

        it "has an array of domestics" do
          expect(family.domestics.length).to eq 2
        end

        describe "to the third segment" do
          let(:domestic) { family.domestics.first }

          it "has an array of groups" do
            expect(domestic.groups.length).to eq 5
          end

          describe "to the rows" do
            let(:group) { domestic.groups.first }

            it "has rows" do
              expect(group.rows.length).to eq 2
            end

            describe "to additional rows" do
              let(:group) { domestic.groups.last }

              it "has rows" do
                # require 'pry';binding.pry
                expect(group.rows.length).to eq 2
              end
            end
          end
        end
      end
    end
  end
end
