class Kur < ApplicationRecord

  validates :date, uniqueness: true

  def self.updatekur
    puts 'Обновляем курс'
    url = "https://www.cbr-xml-daily.ru/daily_json.js"
    resp = RestClient.get(url)
    data = JSON.parse(resp)
    date = data['Date']
    puts date
    a = date.to_time.in_time_zone('Moscow') +10.minutes
    kur = Kur.where('date BETWEEN ? AND ?', a.beginning_of_day,  a.end_of_day).last
    valutes = data['Valute']
    # puts valutes
    valutes.each do |val|
      if val[0].downcase == 'gbp'
        @gbp = val[1]['Value']
      end
      if val[0].downcase == 'byn'
        @byn = val[1]['Value']
      end
      if val[0].downcase == 'usd'
        @usd = val[1]['Value']
      end
      if val[0].downcase == 'eur'
        @eur = val[1]['Value']
      end
      if val[0].downcase == 'kzt'
        @kzt = val[1]['Value']
      end
      if val[0].downcase == 'cny'
        @cny = val[1]['Value']
      end
      if val[0].downcase == 'uah'
        @uah = val[1]['Value']
      end
      if val[0].downcase == 'chf'
        @chf = val[1]['Value']
      end
      if val[0].downcase == 'jpy'
        @jpy = val[1]['Value']
      end
    end
    if kur.nil?
      Kur.create(:date => date, gbp: @gbp, byn: @byn, usd: @usd, eur: @eur, kzt: @kzt, cny: @cny, uah: @uah, chf: @chf, jpy: @jpy)
    else
      kur.update_attributes(gbp: @gbp, byn: @byn, usd: @usd, eur: @eur, kzt: @kzt, cny: @cny, uah: @uah, chf: @chf, jpy: @jpy)
    end
    puts 'Закончили обновлять курс'
  end

end
