#!/usr/bin/env ruby

require 'rubygems'

require 'active_support/inflector'
require 'cgi'
require 'date'
require 'fileutils'
require 'json'
require 'rest-client'

def pages()
  result = []
  url = "https://www.onenote.com/api/Beta/pages/"

  while url
    response = RestClient::Request.execute :url => url, :headers => {:authorization => ENV["AUTH_TOKEN"]}, :method => :get, :ssl_version => :TLSv1
    json = JSON.parse response, :symbolize_names => true
    result += json[:value]
    url = json[:"@odata.nextLink"]
  end

  result
end

def page_content(page)
    RestClient::Request.execute :url => page[:contentUrl], :headers => {:authorization => ENV["AUTH_TOKEN"]}, :method => :get, :ssl_version => :TLSv1
end

all_pages = pages()
$stderr.puts "Got #{all_pages.size} pages"

all_pages.each do |page|
  # Retrieve the relevant content
  title = page[:title]
  content = page_content(page).encode(universal_newline: true)
  notebook = page[:parentNotebook][:name]
  section = page[:parentSection][:name]
  date = DateTime.parse(page[:createdTime]).strftime("%Y-%m-%d")

  # Augment the body, as to include information about the notebook and section
  content.sub!(/(\s*)<\/head>/, "\\1\t<meta name=\"notebook\" content=\"#{CGI.escapeHTML(notebook)}\" />\\1</head>")
  content.sub!(/(\s*)<\/head>/, "\\1\t<meta name=\"section\" content=\"#{CGI.escapeHTML(section)}\" />\\1</head>")

  # Save everything to a file
  filename = File.join(notebook.parameterize, section.parameterize, "#{date}-#{title.parameterize}.html")
  $stderr.puts "Creating #{filename}"
  FileUtils.mkdir_p(File.dirname(filename))
  IO.write(filename, content)
end
