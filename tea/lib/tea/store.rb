class Importer

  def self.scrape_teas
      puts "Here's a list of the teas you asked for."
      doc = Nokogiri::HTML(open('https://meileaf.com/teas/'))
      doc.css('div.product-card__info').each do |tea|
        new_tea = Teas.new
        new_tea.name = tea.css('h2').text
        new_tea.aka = tea.css('h3').text
        new_tea.info = tea.css('div.product-card__info-main p').text
        new_tea.type = tea.css('span.product-card__type').text
        new_tea.url = "https://meileaf.com#{tea.css('div.product-card__info-top a').first['href']}"
      end
  end

  def self.scrape_tea_profile(new_tea)
    puts new_tea
    path = new_tea.url
    i = []
    doc = Nokogiri::HTML(open(path))
    new_tea.notes = doc.css('div.product-tasting-notes dl').text.split('.')
    doc.css('td.brewing-instructions__td').each {|item| i << item.text.split(" ").join(" | ").gsub("&plus;","+")}
    new_tea.gongfu_instructions = {:water_temp => i[0], :grams_per_100ml_water => i[1], :first_infusion => i[2], :additional_infusions => i[3], :total_infusions => i[4]}
    new_tea.western_instructions = {:water_temp => i[0], :grams_per_100ml_water => i[5], :first_infusion => i[6], :additional_infusions => i[7], :total_infusions => i[8]}
    print_info(new_tea)
  end

  def self.print_info(obj, count)
    puts count
    puts obj
    puts "#{obj.name}"
    puts "#{obj.type}"
    puts "#{obj.info}"
    puts "#{obj.url}"
    puts "------------------------------"
    #puts "#{obj.notes}"
    #puts "#{obj.gongfu_instructions}"
    #puts "#{obj.western_instructions}"
  end
end
