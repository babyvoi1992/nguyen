class Template

  attr_accessor :render

  def initialize(str)
    @remder =str
  end


  def render(agr)


    (agr[:animal_type].nil?) ? return agr[:name]+ " likes " : return agr[:name]+ " likes "+agr[:animal_type]
  end


end