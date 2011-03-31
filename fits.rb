require "sinatra"
require "open-uri"

get '/fits' do
  content_type 'application/xml'
  if !params[:url].nil?
    identify_with_fits(params[:url])
  end
end

helpers do
  def identify_with_fits(url)
    file = open(url) do |io|
      #fname = io.meta['content-disposition'].split(/;/).last.split(/\=/).last.gsub(/"/,'')
      fname = URI.parse(url).path[%r{[^/]+\z}]
      Dir.mktmpdir { |tmp|
        open("#{tmp}/#{fname}", "wb") { |file|
          file.write(io.read)
          file
         }
        $stderr.puts filepath = File.expand_path(file.path)
        return %x[/home/medusa/fits/fits.sh -x -i #{filepath}]
      }
    end
  end
end

