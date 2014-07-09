//
//  SOLStumbler.h
//  ScanWiFi
//
//  Created by 时代合盛 on 14-7-8.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#include <dlfcn.h>

@interface SOLStumbler : NSObject{
    NSMutableDictionary *networks; //Key: MAC Address (BSSID)
    void *libHandle;
    void *airportHandle;
    int (*apple80211Open)(void *);
    int (*apple80211Bind)(void *, NSString *);
    int (*apple80211Close)(void *);
    int (*apple80211Associate)(void *, NSDictionary*, NSString*);
    int (*apple80211Scan)(void *, NSArray **, void *);
    
}
-(NSDictionary*)networks;                                                             //returns all 802.11 scanned network(s)
- (NSDictionary *)network:(NSString *) BSSID;                   //return specific 802.11 network by BSSID (MAC Address)
- (void)scanNetworks;
- (int)numberOfNetworks;
- (NSMutableDictionary *)getWiFiInfo;
- (int)associateToNetwork:(NSString *)SSID withPassword:(NSString *)password;
- (int)linkToNetwork:(NSDictionary *)dic withPassword:(NSString *)password;
@end
