Pod::Spec.new do |s|

  s.name        	  = 'AFFEvent'
  s.version     	  = '1.3.1'
  s.authors       	  = { 'Jeremy Fuellert' => 'jfuellert@gmail.com' }
  s.summary      	  = 'AFFEvent is an easy to use event system built for both iOS and OSX.'
  s.homepage    	  = 'https://github.com/jfuellert/AFFEvent'
  s.license     	  = 'MIT'
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc 	  = false
  s.source       	  = { :git => 'https://github.com/jfuellert/AFFEvent.git', :tag => '1.3.1' }
  s.source_files 	  = ’AFFEvent/AFFEventCenter/AFFEventCenter.h’
  s.public_header_files   = 'AFFEvent/AFFEventCenter/AFFEventCenter.h’

  s.subspec ‘AFFEvent’ do |ss|
    ss.source_files 	     = ‘AFFEvent/*/*.{h,m}’
    ss.non_arc_files	     = ‘AFFEvent/*/*.{h,m}’
    ss.public_header_files   = 'AFFEvent/AFFEvent/AFFEvent.h’,'AFFEvent/AFFEvent{API,Center}/AFFEvent{API,Center}.h’
  end
end