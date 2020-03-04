require 'csv'

module Loadable

  def from_csv(file_path, class_name, all)
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      params = row.to_hash
      all << class_name.new(params)
    end
  end

end
