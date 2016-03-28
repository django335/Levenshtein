Pod::Spec.new do |s|
  s.name             = "Levenshtein"
  s.version          = "1.1.0"
  s.summary          = "levenshtein distance"

  s.homepage         = "https://github.com/django335/Levenshtein"
  s.license          = 'MIT'
  s.author           = { "Naoki Morikubo" => "django0820@gmail.com" }
  s.source           = { :git => "https://github.com/django335/Levenshtein.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Sources/*.swift'

end

