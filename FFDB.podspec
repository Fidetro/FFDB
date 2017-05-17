Pod::Spec.new do |s|

  s.name         = "FFDB"
  s.version      = "1.1.1"
  s.summary      = "easy to use FMDB"
  s.homepage     = "https://github.com/Fidetro/FFDB"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "fidetro" => "zykzzzz@hotmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Fidetro/FFDB.git", :tag => "1.1.1" }
  s.source_files  = "FFDB", "FFDB/*.{h,m}"
  s.library = 'sqlite3'
  s.dependency "FMDB","~> 2.6.2"


end
