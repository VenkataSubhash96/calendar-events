class User < ApplicationRecord
  def self.import_users
    importer = ::Importers::Users::Processor.new('db/csvs/users.csv')
    if importer.valid?
      importer.process
    else
      importer.errors.full_messages
    end
  end
end
