class ExcelGenerate
  attr_accessor :columns, :params

  # params = [['tabname', [[1, 2], [3, 4]]], ['tabname2', [[12, 22], [23, 24]]]]

  def initialize columns, params
    self.columns, self.params = columns, params
  end

  def generate! path, temp_file: false
    file = nil
    file = Tempfile.new(path) if temp_file

    Axlsx::Package.new do |p|
      params.each do |tab, rows|
        p.workbook.add_worksheet(name: tab) do |sheet|
          sheet.add_row self.columns

          rows.each do |row|
            sheet.add_row row
          end
        end
      end

      p.serialize(temp_file ? file.path : add_extension(path))
    end

    temp_file ? file : true
  end

  private

  def add_extension path
    path.end_with?('.xlsx') ? path : path + '.xlsx'
  end
end
