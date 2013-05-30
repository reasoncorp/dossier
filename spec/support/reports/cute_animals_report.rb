class CuteAnimalsReport < Dossier::Report
  HEADERS = %w[family domestic group_id group_name name color cuteness playful]
  ROWS    = [
    ['canine', true,  10, 'foxes', 'fennec',      'tan',    9, true],
    ['canine', true,  10, 'foxes', 'fire',        'orange', 0, false],
    ['canine', false, 10, 'foxes', 'arctic',      'white',  5, false],
    ['canine', false, 10, 'foxes', 'crab-eating', 'brown',  3, false],
    ['canine', false, 10, 'foxes', 'red',         'orange', 5, false],
    ['canine', true,  15, 'dog',   'shiba inu',   'tan',    7, true],
    ['canine', true,  15, 'dog',   'labrador',    'varied', 5, true],
    ['canine', true,  15, 'dog',   'beagle',      'mixed',  8, true],
    ['canine', true,  15, 'dog',   'boxer',       'brown',  5, true],
    ['feline', false, 22, 'tiger', 'bengal',      'orange', 4, false],
    ['feline', false, 22, 'tiger', 'siberian',    'white',  5, false],
    ['feline', false, 23, 'lion',  'lion',        'tan',    5, false],
    ['feline', true,  25, 'cat',   'short hair',  'varied', 6, true],
    ['feline', true,  25, 'cat',   'abyssinian',  'tan',    7, true],
    ['feline', true,  25, 'cat',   'persian',     'varied', 6, false],
    ['feline', true,  25, 'cat',   'wirehair',    'grey',   7, true],
  ]

  def results
    OpenStruct.new(headers: HEADERS, rows: ROWS)
  end

  class Segmenter
    segment :family
    segment :domestic, display_name: ->(row) { "#{row[:domestic] ? 'Domestic' : 'Wild'} #{row[:group_name]}" }
    segment :group,    display_name: :group_name, group_by: :group_id
  end
end

