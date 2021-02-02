platform :ios, '10.0'
workspace 'BidMachineIntegrationSample.xcworkspace'

install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'

def bidmachine_header_bidding
  pod "BDMAdColonyAdapter", "1.7.0.2.0-Beta"
  pod "BDMAmazonAdapter", "1.7.0.2.0-Beta"
  pod "BDMAppRollAdapter", "1.7.0.2.0-Beta"
  pod "BDMCriteoAdapter", "1.7.0.2.0-Beta"
  pod "BDMFacebookAdapter", "1.7.0.2.0-Beta"
  pod "BDMMyTargetAdapter", "1.7.0.2.0-Beta"
  pod "BDMSmaatoAdapter", "1.7.0.2.0-Beta"
  pod "BDMTapjoyAdapter", "1.7.0.2.0-Beta"
  pod "BDMVungleAdapter", "1.7.0.2.0-Beta"
  pod "BDMIABAdapter", "1.7.0.2.0-Beta"
end

def mopub 
  pod 'mopub-ios-sdk', '5.15.0'
end

target 'BidMachineMopubAdapter' do
    project 'BidMachineMopubAdapter/BidMachineMopubAdapter.xcodeproj'
    bidmachine_header_bidding
    mopub
end

target 'BidMachineMopubClassicSample' do
    project 'BidMachineMopubClassicSample/BidMachineMopubClassicSample.xcodeproj'
    bidmachine_header_bidding
    mopub
end

target 'BidMachineMopubPreBidSample' do
    project 'BidMachineMopubPreBidSample/BidMachineMopubPreBidSample.xcodeproj'
    bidmachine_header_bidding
    mopub
end
