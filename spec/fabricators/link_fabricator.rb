Fabricator(:link) do
  short_name { sequence(:short_name) { |i| "short-#{i}" } }
  original_url { sequence(:orig_url) { |i| "http://original-#{i}.com" } }
end
