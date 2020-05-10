class Insint < ApplicationRecord

belongs_to :user
validates :subdomen, uniqueness: true
validates :subdomen, presence: true


def self.setup_ins_shop(insint_id)
  insint = Insint.find(insint_id)
  if insint.inskey.present?
    saved_subdomain = insint.user.subdomain
    # puts saved_subdomain
    Apartment::Tenant.switch!(saved_subdomain)

    uri = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes.json"
    response = RestClient.get(uri)
    data = JSON.parse(response)
    data.each do |d|
      if d['is_published'] == true
        @theme_id = d['id']
      end
    end

    Insint.add_snippet(insint.id, @theme_id)
    Insint.add_snippet_to_layout(insint.id, @theme_id)
  else
    saved_subdomain = "insales"+insint.insalesid.to_s
    Apartment::Tenant.switch!(saved_subdomain)

    uri = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes.json"
    response = RestClient.get(uri)
    data = JSON.parse(response)
    data.each do |d|
      if d['is_published'] == true
        @theme_id = d['id']
      end
    end

    Insint.add_snippet(insint.id, @theme_id)
    Insint.add_snippet_to_layout(insint.id, @theme_id)
  end
  insint.update_attributes(:status => true)
end

def self.add_snippet(insint_id, theme_id)
  insint = Insint.find(insint_id)
  if insint.inskey.present?
    saved_subdomain = insint.user.subdomain
    Apartment::Tenant.switch!(saved_subdomain)
    uri = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"+"/assets.xml"
  else
    saved_subdomain = "insales"+insint.insalesid.to_s
    Apartment::Tenant.switch!(saved_subdomain)
    uri = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"+"/assets.xml"
  end
  liquid_data_hash = []
  js_data_hash = []
  kurs = Kur.last
  kurs_hash = JSON.parse(kurs.to_json)
  kurs_hash.each do |k,v|
    if k != "id" and k != "created_at" and k != "updated_at"
      liquid_data_hash.push('{% assign k_'+k+' = "'+v.to_s+'" %}')
      js_data_hash.push('"k_'+k+'": "'+v.to_s+'"')
    end
  end
  liquid_data = liquid_data_hash.join('')
  js_data = js_data_hash.join(',')
  data = '<?xml version="1.0" encoding="UTF-8"?><asset><name>k-kurs.liquid</name>
  <content><![CDATA['+liquid_data+'<script type="text/javascript">Site.messages = {'+js_data+'};</script> ]]></content><type>Asset::Snippet</type></asset>'

  RestClient.post( uri, data, {:content_type => 'application/xml', accept: :xml}) { |response, request, result, &block|
					puts response.code
								case response.code
								when 200
									puts 'Файл с именем k-kurs.liquid - сохранили'
									puts response
								when 422
									puts '422'
                  puts response
								else
									response.return!(&block)
								end
								}
end

def self.add_snippet_to_layout(insint_id, theme_id)
  insint = Insint.find(insint_id)
  if insint.inskey.present?
    saved_subdomain = insint.user.subdomain
    Apartment::Tenant.switch!(saved_subdomain)
    url = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"+"/assets.json"
    # puts url
    response = RestClient.get(url)
    data = JSON.parse(response)
    data.each do |d|
      if d['inner_file_name'] == "footer.liquid"
        @footer_id = d['id']
      end
    end

    uri = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"+"/assets/"+"#{@footer_id}"+".json"
    resp_get_footer_content = RestClient.get(uri)
    data = JSON.parse(resp_get_footer_content)
    footer_content = data['content']
    new_footer_content = footer_content+' <span class="k-kurs">{% include "k-kurs" %}</span>'
    data = '<asset><content><![CDATA[ '+new_footer_content+' ]]></content></asset>'
    uri_new_footer = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"+"/assets/"+"#{@footer_id}"+".xml"
    resp_change_footer_content = RestClient.put uri_new_footer, data, :accept => :xml, :content_type => "application/xml"
  else
    saved_subdomain = "insales"+insint.insalesid.to_s
    Apartment::Tenant.switch!(saved_subdomain)
    url = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"+"/assets.json"
    # puts url
    response = RestClient.get(url)
    data = JSON.parse(response)
    data.each do |d|
      if d['inner_file_name'] == "footer.liquid"
        @footer_id = d['id']
      end
    end

    uri = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"+"/assets/"+"#{@footer_id}"+".json"
    resp_get_footer_content = RestClient.get(uri)
    data = JSON.parse(resp_get_footer_content)
    footer_content = data['content']
    new_footer_content = footer_content+' <span class="k-kurs">{% include "k-kurs" %}</span>'
    data = '<asset><content><![CDATA[ '+new_footer_content+' ]]></content></asset>'
    uri_new_footer = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"+"/assets/"+"#{@footer_id}"+".xml"
    resp_change_footer_content = RestClient.put uri_new_footer, data, :accept => :xml, :content_type => "application/xml"
  end
end

def self.delete_ins_file(insint_id) # два этапа. это первый этап
  insint = Insint.find(insint_id)
  if insint.inskey.present?
    saved_subdomain = insint.user.subdomain
    Apartment::Tenant.switch!(saved_subdomain)
    puts "удаляем файлы из магазина"
    uri = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes.json"
    response_theme_id = RestClient.get(uri)
    data_theme_id = JSON.parse(response_theme_id)
    data_theme_id.each do |d|
      if d['is_published'] == true
        @theme_id = d['id']
      end
    end
  else
    saved_subdomain = "insales"+insint.insalesid.to_s
    Apartment::Tenant.switch!(saved_subdomain)
    puts "удаляем файлы из магазина"
    uri = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes.json"
    response_theme_id = RestClient.get(uri)
    data_theme_id = JSON.parse(response_theme_id)
    data_theme_id.each do |d|
      if d['is_published'] == true
        @theme_id = d['id']
      end
    end
  end
    Insint.delete_ins_file_next(insint.id, @theme_id)
end

def self.delete_ins_file_next(insint_id, theme_id) # два этапа. это второй этап
  insint = Insint.find(insint_id)
  if insint.inskey.present?
    @uri_delete = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"+"/assets.json"
    @url = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"
  else
    @uri_delete = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"+"/assets.json"
    @url = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{theme_id}"
  end

  response_delete = RestClient.get(@uri_delete)
  data_delete = JSON.parse(response_delete)
  data_delete.each do |d|
    if d['inner_file_name'] == "k-kurs.liquid"
      snippet_product_id = d['id']
      puts "snippet_product_id - "+snippet_product_id.to_s
      url_snip = @url+"/assets/"+"#{snippet_product_id}"+".json"
      resp_get_footer_content = RestClient.delete(url_snip)
    end
    #ниже удаляем запись в футере
    if d['inner_file_name'] == "footer.liquid"
      footer_id = d['id']
      puts "footer_id - "+footer_id.to_s
      url_footer = @url+"/assets/"+"#{footer_id}"+".json"
      # puts url_footer
      resp = RestClient.get(url_footer)
      data = JSON.parse(resp)
      # puts data['content']
      new_footer_content = data['content'].gsub('<span class="k-kurs">{% include "k-kurs" %}</span>','')
      new_data = '<asset><content><![CDATA[ '+new_footer_content+' ]]></content></asset>'
      url_footer_xml = @url+"/assets/"+"#{footer_id}"+".xml"
      remove_our_include = RestClient.put url_footer_xml, new_data, :accept => :xml, :content_type => "application/xml"
    end
  end

  insint.update_attributes(:status => false)
end

def self.update_and_email(insint_id)
  insint = Insint.find(insint_id)
  if !insint.inskey.present?
    url = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/account.json"
  # ниже обновляем адрес почты пользователя после автоустановки магазина
    resp = RestClient.get( url )
    data = JSON.parse(resp)
    shopemail = data['email']
      if shopemail.present?
        insint.user.update_attributes(:email => shopemail)
      end
  end

  UserMailer.test_welcome_email(insint.user.email).deliver_now

end

def self.update_kurs_snippet_all_users
  users = User.all.order(:id)
  users.each do |user|
    Insint.update_kurs_snippet(user.id)
  end
end

def self.update_kurs_snippet(user_id)
  user = User.find_by_id(user_id)
  puts user.id
  insint = user.insints.first
  if insint.present? and insint.status
    if insint.inskey.present?
      # saved_subdomain = insint.user.subdomain
      # Apartment::Tenant.switch!(saved_subdomain)
      uri_get_theme = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes.json"
    else
      # saved_subdomain = "insales"+insint.insalesid.to_s
      # Apartment::Tenant.switch!(saved_subdomain)
      uri_get_theme = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes.json"
    end

    response = RestClient.get(uri_get_theme)
    data = JSON.parse(response)
    data.each do |d|
      if d['is_published'] == true
        @theme_id = d['id']
      end
    end

    if insint.inskey.present?
      url_get_snp = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{@theme_id}"+"/assets.json"
    else
      url_get_snp = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{@theme_id}"+"/assets.json"
    end
    # puts url_get_snp
    response = RestClient.get(url_get_snp)
    data = JSON.parse(response)
    data.each do |d|
      if d['inner_file_name'] == "k-kurs.liquid"
        @k_kurs_id = d['id']
      end
    end

    if insint.inskey.present?
      url_upd_snp = "http://"+"#{insint.inskey}"+":"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{@theme_id}"+"/assets/"+"#{@k_kurs_id}"+".xml"
    else
      url_upd_snp = "http://k-kurs:"+"#{insint.password}"+"@"+"#{insint.subdomen}"+"/admin/themes/"+"#{@theme_id}"+"/assets/"+"#{@k_kurs_id}"+".xml"
    end

    liquid_data_hash = []
    js_data_hash = []
    kurs = Kur.last
    kurs_hash = JSON.parse(kurs.to_json)
    kurs_hash.each do |k,v|
      if k != "id" and k != "created_at" and k != "updated_at"
        liquid_data_hash.push('{% assign k_'+k+' = "'+v.to_s+'" %}')
        js_data_hash.push('"k_'+k+'": "'+v.to_s+'"')
      end
    end
    liquid_data = liquid_data_hash.join('')
    js_data = js_data_hash.join(',')
    data = '<asset><content><![CDATA['+liquid_data+'
    <script type="text/javascript">
      Site.messages = {
        '+js_data+'
        };
    </script>
    ]]></content></asset>'

    RestClient.put( url_upd_snp, data, {:content_type => 'application/xml', accept: :xml}) { |response, request, result, &block|
            puts response.code
                  case response.code
                  when 200
                    puts 'Обновили k-kurs'
                    # puts response
                  when 422
                    puts '422'
                    puts response
                  else
                    response.return!(&block)
                  end
                  }
  end
end

end
