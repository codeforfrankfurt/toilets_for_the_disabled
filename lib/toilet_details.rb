class ToiletDetails

  HEADINGS = {
    'Bewegungsfläche vor der Tür' => 'Tür - ',
    'Kabinengröße' => 'Kabine - '
  }

  def initialize(attributes)
    @attributes = {}

    # making sure we have string keys
    attributes.each do |key, value|
      @attributes[key.to_s] = value
    end
  end

  def self.from_scraping(name, address, node)
    obj = new(name: name, address: address.join(', '), street: address.first, place: address.last)
    obj.set_attributes_from_scraping(node)
    obj
  end

  def query
    @attributes.select {|key| ["name", "street"].include?(key.to_s)}
  end

  def to_hash
    @attributes
  end

  def self.basic_keys
    ["name", "address", "street", "place"]
  end

  protected

    def set_attributes_from_scraping(node)
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
end
