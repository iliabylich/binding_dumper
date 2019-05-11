module MagicFixtures
  MAGIC_DATA = { key: 'MAGIC TEXT' }

  class MagicClass
    @magic = MAGIC_DATA
  end
end

RSpec.configure do |config|
  config.around(:each) do |example|
    if example.metadata[:file_path].include?('functional')
      example.run
    else
      BindingDumper::MagicObjects.flush_while do
        BindingDumper::MagicObjects.register(MagicFixtures::MagicClass)

        example.run
      end
    end
  end
end
