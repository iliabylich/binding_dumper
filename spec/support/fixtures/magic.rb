module MagicFixtures
  MAGIC_DATA = 'MAGIC TEXT'

  class MagicClass
    @magic = MAGIC_DATA
  end
end

RSpec.configure do |config|
  config.around(:each) do |example|
    begin
      BindingDumper::MagicObjects.register(MagicFixtures::MagicClass)
      example.run
    ensure
      BindingDumper::MagicObjects.flush!
    end
  end
end
