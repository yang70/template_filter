require 'template_converter'

RSpec.describe TemplateConverter do
  describe "#get_variables" do
    it "returns hash of variables and values" do
      variable_hash = {
        "!name1" => "John Q.",
        "!name2" => "Smith",
        "!salutation" => "Dear @name1 @name2",
        "!product" => "Horcrux Widget"
      }
      tc = TemplateConverter.new
      expect(tc.get_variables('./fixtures/sample_file.txt')).to eq(variable_hash)
    end
  end
end
