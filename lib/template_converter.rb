class TemplateConverter
  
  def initialize(input_file)
    @input_file = input_file
    @vars_hash = {}
    @save_loc = File.dirname(@input_file) # Save new formatted file to same relative location as source
    @file_ext = File.extname(@input_file) # Set file extension for use in renaming formatted file, OK if no file ext
    @new_file = File.new(@save_loc + "/" + File.basename(@input_file, @file_ext) + "_formatted" + @file_ext, "w") # Create new writable file
  end

  def format
    File.foreach(@input_file) do |line|

      if line[0] == '!'
        add_var line
      else
        last_line = line
        new_line = ''

        loop do # Recursive solution 'feels' like it might be better?
          new_line = insert_vars last_line
          break if new_line == last_line
          last_line = new_line
        end

        new_line.gsub!('@@', '@')
        @new_file.puts(new_line)
      end
    end

    @new_file.close
  end

  private

  def add_var(assignment_statement)
    var_name_pattern = Regexp.new(/[^=]*/) # Match chars up to '='
    var_val_pattern = Regexp.new(/(?<==).+/) # Match chars after '='

    name = var_name_pattern.match(assignment_statement).to_s[1..-1]
    val = var_val_pattern.match(assignment_statement).to_s

    @vars_hash['@' + name] = val
    @vars_hash['@{' + name + '}'] = val
  end

  def insert_vars(line)
    var_names = @vars_hash.keys.join("|") # Courtesy Ruby Tapas Ep 190: http://www.rubytapas.com/2014/03/31/episode-190-gsub/
    pattern = Regexp.new(var_names)
    line.gsub(pattern, @vars_hash)
  end
end

