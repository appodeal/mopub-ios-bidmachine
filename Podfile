# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

install! 'cocoapods', :warn_for_multiple_pod_sources => false

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'

def bidmachine_header_bidding
  pod "BidMachine", "1.3.0-Alpha"
  pod "BidMachine/VungleAdapter", "1.3.0-Alpha"
  pod "BidMachine/TapjoyAdapter", "1.3.0-Alpha"
  pod "BidMachine/MyTargetAdapter", "1.3.0-Alpha"
  pod "BidMachine/FacebookAdapter", "1.3.0-Alpha"
  pod "BidMachine/AdColonyAdapter", "1.3.0-Alpha"
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
