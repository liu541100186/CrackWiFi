//
//  SOLStumbler.m
//  ScanWiFi
//
//  Created by 时代合盛 on 14-7-8.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "SOLStumbler.h"

@implementation SOLStumbler


- (id)init
{
    self = [super init];
    networks = [[NSMutableDictionary alloc] init];
    libHandle = dlopen("System/Library/SystemConfiguration/IPConfiguration.bundle/IPConfiguration", RTLD_LAZY);
    char *error;
    if (libHandle == NULL && (error = dlerror()) != NULL)  {
        NSLog(@"%s",error);
        exit(1);
    }
    apple80211Open = dlsym(libHandle, "Apple80211Open");
    apple80211Bind = dlsym(libHandle, "Apple80211BindToInterface");
    apple80211Close = dlsym(libHandle, "Apple80211Close");
    apple80211Scan = dlsym(libHandle, "Apple80211Scan");
    apple80211Associate = dlsym(libHandle, "Apple80211Associate");
    apple80211Open(&airportHandle);
    apple80211Bind(airportHandle, @"en0");
    return self;
}
- (NSDictionary *)network:(NSString *) BSSID
{
    return [networks objectForKey:@"BSSID"];
}
- (NSDictionary *)networks
{
    return networks;
}
- (void)scanNetworks
{
    
    NSDictionary *parameters = [[NSDictionary alloc] init];
    NSArray *scan_networks; //is a CFArrayRef of CFDictionaryRef(s) containing key/value data on each discovered network
    apple80211Scan(airportHandle, &scan_networks, (__bridge void *)(parameters));
    NSLog(@"===–======\n%@",scan_networks);
    for (int i = 0; i < [scan_networks count]; i++) {
        [networks setObject:[scan_networks objectAtIndex: i] forKey:[[scan_networks objectAtIndex: i] objectForKey:@"BSSID"]];
    }
    
    
    NSLog(@"Scanning WiFi Channels Finished.");
}
- (int)numberOfNetworks
{
    return (int)networks.count;
}

- (NSMutableDictionary *)getWiFiInfo{
    return networks;
}
- ( NSString * ) description {
    NSMutableString *result = [[NSMutableString alloc] initWithString:@"Networks State: \n"];
    for (id key in networks){
        [result appendString:[NSString stringWithFormat:@"%@ (MAC: %@), RSSI: %@, Channel: %@ \n",
                              [[networks objectForKey: key] objectForKey:@"SSID_STR"], //Station Name
                              key, //Station BBSID (MAC Address)
                              [[networks objectForKey: key] objectForKey:@"RSSI"], //Signal Strength
                              [[networks objectForKey: key] objectForKey:@"CHANNEL"]  //Operating Channel
                              ]];
    }
    return [NSString stringWithString:result];
}

- (int)associateToNetwork:(NSString *)SSID withPassword:(NSString *)password
{
    for (id key in networks) {
        if ([[[networks objectForKey:key] objectForKey:@"SSID_STR"] isEqualToString:SSID]) {
            // For connecting to WPA network, replace NULL below with a string containing the key
            // apple80211Associate;
            int associateResult = apple80211Associate(airportHandle, [networks objectForKey:key],password);
            // int associateResult = 1;
            return associateResult;
        }
    }
    return -1;
}
- (int)linkToNetwork:(NSDictionary *)dic withPassword:(NSString *)password{
    int associateResult = apple80211Associate(airportHandle, dic,password);
    return associateResult;
}

- (void) dealloc {
    apple80211Close(airportHandle);
}
@end
