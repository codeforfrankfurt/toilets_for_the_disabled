class ToiletDetails

  HEADINGS = {
    'Bewegungsfläche vor der Tür' => 'Tür - ',
    'Kabinengröße' => 'Kabine - '
  }


  def initialize(name, address, node)
    @name = name
    @address = address
    @attributes = {}

    lists = node.search('dl')
    lists.each do |dl|
      dl.children.each do |child|
        text = child.text.chomp(':').strip

        if child.name == "h2"
          @current_heading = HEADINGS[text]
        elsif child.name == "dt"
          dt = @current_heading ? @current_heading + text : text
          @current_dt = dt
        else
          @attributes[@current_dt] = text
        end
      end

      @current_dt = @current_heading = nil
    end
  end


  def to_hash
    {"name" => @name, "address" => @address}.merge(@attributes)
  end
end