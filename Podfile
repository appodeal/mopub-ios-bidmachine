platform :ios, '9.0'
workspace 'BMIntegrationSample.xcworkspace'

install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'

def bidmachine_header_bidding
  pod "BidMachine", "1.3.1"
  pod "BidMachine/VungleAdapter"
  pod "BidMachine/TapjoyAdapter"
  pod "BidMachine/MyTargetAdapter"
  pod "BidMachine/FacebookAdapter"
  pod "BidMachine/AdColonyAdapter"
  pod "BidMachine/MintegralAdapter"
end

target 'BidMachine' do
    project 'BMIntegrationSample.xcodeproj'
    bidmachine_header_bidding
    pod 'mopub-ios-sdk'
end

target 'BMIntegrationSample' do
    project 'BMIntegrationSample.xcodeproj'
    pod 'mopub-ios-sdk'
    bidmachine_header_bidding
end
