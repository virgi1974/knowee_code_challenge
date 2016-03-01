require 'pry'
require 'roo'
require 'csv'

class User < ActiveRecord::Base

  validates :nombre, :apellidos, :email, :incorporacion, presence: true
  validates :email, uniqueness: true
  validates :baja, :inclusion => {:in => [true, false]}
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  # METODO INICIAL PARA 'CSV' EN CARPETA app/csv
  
  def self.set_fields row
    new_user = {}
    new_user[:nombre] = row[0]
    new_user[:apellidos] = row[1]
    new_user[:email] = row[2]
    new_user[:incorporacion] = Date.parse row[3] 
    new_user[:baja] = change_si_no(row[4])
    return new_user
  end

  private

    def self.change_si_no str
      if str == 'si'
        true
      elsif str == 'no'
        false
      end
    end

  # METODO CONJUNTO PARA 'CSV' & 'XLSX'

    def self.import(file)
      extension = File.extname(file.original_filename)
      spreadsheet = open_spreadsheet(file,extension)
      spreadsheet = check_extension(spreadsheet,extension)
      create_user(spreadsheet,extension)
    end

    def self.check_extension spreadsheet,extension
      if extension == '.xlsx'
        spreadsheet = spreadsheet.to_a[1..-1]
      end
      spreadsheet
    end

    def self.clean_row row,extension
      if extension == '.xlsx'
        row = row.split(";")[0]
      elsif extension == '.csv'
        row = row[0].split(";")
      end
      row
    end

    def self.create_user spreadsheet, extension
      spreadsheet.each do |row|
        row = clean_row(row,extension)
        new_user = set_fields(row)
        create(new_user) 
      end
    end

    def self.open_spreadsheet(file,extension)
      case extension
        when ".csv" then Roo::CSV.new(file.path, packed: nil, file_warning: :ignore)
        when '.xls' then Roo::Excel.new(file.path, packed: nil, file_warning: :ignore)
        when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
        else raise "Unknown file type: #{file.original_filename}"
      end
    end

end
