#http://rubyblog.pro/2016/10/factory-method-pattern-in-ruby

class CsvFormatter
  def format(data)
    return "" if data.empty?

    result = data.keys.join(",") + "\n"
    result += data.values.join(",") + "\n"
  end        
end

class JsonFormatter
  def format(data)
    return "" if data.empty?

    data.to_json
  end
end

class TsvFormatter
  def format(data)
    return "" if data.empty?

    result = data.keys.join("\t") + "\n"
    result += data.values.join("\t") + "\n"
  end
end

#Formatter is the factory method
class Formatter
  def self.for(type)
    case type
    when 'csv'
      CsvFormatter.new
    when 'json'
      JsonFormatter.new
    when 'tsv'
      TsvFormatter.new
    else
      raise 'Unsupported type of report'
    end
  end
end

class ReportGenerator
  def self.generate(data, type)
    Formatter.for(type).format(data)
  end
end

report_data = { foo_key: "foo", bar_key: "bar", baz_key: "baz" }
ReportGenerator.generate(report_data, 'tsv')