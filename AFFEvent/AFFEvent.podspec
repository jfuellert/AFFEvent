Pod::Spec.new do |s|

  s.name         = "AFFEvent"
  s.version      = "1.3.1"
  s.summary      = "AFFEvent is an easy to use event system built for both iOS and OSX."

  s.description  = <<-DESC
                   AFFEvent is an alternative event system built for iOS and OSX applications. The event system has an alterable event system that lets you add, remove, and modify events and / or handlers and blocks. It also allows for multiple parameter methods and blocks to be called upon an event being fired.
                   DESC

  s.homepage     = "https://github.com/jfuellert/AFFEvent"

  s.license      = 'MIT'

  s.author       = { "Jeremy Fuellert" => "jfuellert@gmail.com" }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source       = { :git => "https://github.com/jfuellert/AFFEvent.git", :tag => "1.3.1" }

  s.source_files  = ‘AFFEvent/AFFBlock.m’,
    ‘AFFEvent/AFFBlock.h’
    'AFFEvent/AFFEvent.m’,
    'AFFEvent/AFFEvent.h’,
    'AFFEvent/AFFEventAPI.m’,
    'AFFEvent/AFFEventAPI.h’,
    'AFFEvent/AFFEventCenter.h’,
    'AFFEvent/AFFEventHandler.m’,
    'AFFEvent/AFFEventHandler.h’,
    'AFFEvent/AFFEventStatics.h’,
    'AFFEvent/AFFEventSystemHandler.m’,
    'AFFEvent/AFFEventSystemHandler.h’

  non_arc_files = 'AFFEvent/AFFBlock.m’,
    'AFFEvent/AFFEvent.m’,
    'AFFEvent/AFFEventAPI.m’,
    'AFFEvent/AFFEventHandler.m’,
    'AFFEvent/AFFEventSystemHandler.m’

  s.requires_arc = false
  s.subspec 'no-arc' do |sna|
    sna.requires_arc = false
    sna.source_files = non_arc_files

  s.public_header_files = 'AFFEvent.h’,
    'AFFEventAPI.h’,
    'AFFEventCenter.h’

end