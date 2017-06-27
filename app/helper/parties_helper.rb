module PartiesHelper
  def get_lname(string)
    if string.include? '_'
      # "S._Doe_Truman" => "Truman"
      a = string.split('_')
      return a[-1]
    else
      return string
    end
  end
end