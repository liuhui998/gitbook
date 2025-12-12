#!/usr/bin/env ruby
# encoding: utf-8
# Sitemap generation script for Git Community Book

require 'builder'
require 'time'

BASE_URL = 'https://gitbook.liuhui998.com'
OUTPUT_DIR = 'output/book'
SITEMAP_FILE = 'output/book/sitemap.xml'

desc "Generate sitemap.xml"
task :sitemap => :html do
  puts "Generating sitemap.xml..."

  # Ensure output directory exists
  unless File.directory?(OUTPUT_DIR)
    puts "Error: #{OUTPUT_DIR} does not exist. Please run 'rake html' first."
    exit 1
  end

  # Get all HTML files
  html_files = Dir.glob("#{OUTPUT_DIR}/*.html").sort

  if html_files.empty?
    puts "Error: No HTML files found in #{OUTPUT_DIR}. Please run 'rake html' first."
    exit 1
  end

  # Get the last modification time of the HTML files
  last_mod = html_files.map { |f| File.mtime(f) }.max

  # Generate sitemap XML
  xml = Builder::XmlMarkup.new(indent: 2)
  xml.instruct!

  sitemap_content = xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
    html_files.each do |file|
      filename = File.basename(file)
      file_mtime = File.mtime(file)

      # Determine priority and change frequency based on file type
      priority = case filename
      when 'index.html'
        '1.0'
      when /^1_\d+\.html$/  # First chapter (introduction)
        '0.9'
      when /^\d+_\d+\.html$/  # Other chapters
        '0.8'
      else
        '0.7'
      end

      changefreq = 'monthly'

      xml.url do
        xml.loc "#{BASE_URL}/#{filename}"
        xml.lastmod file_mtime.strftime('%Y-%m-%d')
        xml.changefreq changefreq
        xml.priority priority
      end
    end
  end

  # Write sitemap to file
  File.open(SITEMAP_FILE, 'w') do |f|
    f.write(sitemap_content)
  end

  puts "✅ Sitemap generated successfully!"
  puts "   Location: #{SITEMAP_FILE}"
  puts "   Total URLs: #{html_files.length}"
  puts "   Base URL: #{BASE_URL}"
end
