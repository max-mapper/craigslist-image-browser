get '/' do
  haml :index
end

def listings
  doc = Nokogiri::HTML(open('http://portland.craigslist.org/mlt/zip/'))
  posts = {}
  doc.css('.p').each_with_index do |link, index|
    href = link.parent.css('a').first['href'].split('.')[0].gsub('/mlt/zip/', '')
    posts.merge!({index => href})
  end
  posts
end

def images(post_id)
  images = {}
  postdetails = Nokogiri::HTML(open("http://portland.craigslist.org/mlt/zip/#{post_id}.html"))
  date = postdetails.css('.posting').to_s.split("Date: ")[1].split("<br>")[0].gsub("  ", " ")
  postdetails.css('img').each do |image|
    images[date] = image['src']
  end
  images
end

get '/listings' do
  content_type :json
  listings.to_json
end

get '/images/:post_id' do
  content_type :json
  images(params[:post_id]).to_json
end

get '/rss.xml' do
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "Portland OR Free Craigslist Images"
        xml.description "Portland OR Free Craigslist Images"
        xml.link "http://www.maxogden.com/freecraigslist"
        listings.sort.each do |listing|
          listing_index = listing[0]
          post_id = listing[1]
          images(post_id).each do |date, image_url|
            xml.item do
              xml.title post_id
              xml.link "http://portland.craigslist.org/mlt/zip/#{post_id}.html"
              xml.description "<img src='#{image_url}'/>"
              xml.pubDate Time.parse(date).rfc822()
              xml.guid "http://portland.craigslist.org/mlt/zip/#{post_id}.html"
            end
          end
        end
      end
    end
  end
end