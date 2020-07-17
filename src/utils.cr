require "yaml"

module Utils
  def count_spaces(content : String) : Int32
    space_count = 0
    lines = content.lines
    lines.each_with_index do |line, i|
      next if line.chomp.size > 0
      space_count += 1
      break if i+1 < lines.size && lines[i+1].chomp.size > 0
    end
    return space_count
  end

  def field_names(content : Hash(YAML::Any, YAML::Any)) : Array(String)
    content.keys.map { |k| k.as_s }
  end

  def is_field_string(c : Hash(YAML::Any, YAML::Any), a : Array(String), idx : Int32) : Bool
    return idx < a.size && c[a[idx]].raw.is_a?(String)
  end

  def process_output(content : Hash(YAML::Any, YAML::Any), spaces : Int32 = 1) : String
    fields = field_names(content)
    output = ""

    fields.each_with_index do |name, i|
      val = content[name]
      output += YAML.dump({ name => val }).gsub("---\n", "")

      if !val.raw.is_a?(String) || !is_field_string(content, fields, i+1) 
        output += ("\n" * spaces)
      end
    end

    return output
  end
end
