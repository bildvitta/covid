class Array
  def find_by attribute, value
    find { |object| object.send(attribute) == value }
  end

  def select_by attribute, value
    select { |object| object.send(attribute) == value }
  end
end