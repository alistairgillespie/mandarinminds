require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'https://www.mandarinminds.com'
SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'monthly'
  add '/contact', :changefreq => 'monthly'
  add '/faq', :changefreq => 'monthly'
  add '/tutoring', :changefreq => 'monthly'
  add '/ebooks', :changefreq => 'monthly'
  add '/plans', :changefreq => 'monthly'
  add '/posts', :changefreq => 'monthly'
  add '/privacy', :changefreq => 'monthly'
  add '/terms', :changefreq => 'monthly'
  add '/translation', :changefreq => 'monthly'
end

SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks