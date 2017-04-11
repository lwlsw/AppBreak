@interface FBBundleInfo : NSObject
@property (nonatomic,copy) NSString * displayName;
@property (nonatomic,copy) NSString * bundleIdentifier;
@end

@interface FBApplicationInfo : FBBundleInfo
@end
NSMutableDictionary *blacklist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.skylerk99.nosub.plist"];

static NSString *libPath = @"/usr/lib/AppBreak.dylib";

%hook FBApplicationInfo

- (NSDictionary *)environmentVariables {
	NSDictionary *originalEnv = %orig;
	if ([[blacklist objectForKey:self.bundleIdentifier] boolValue]) {
		NSMutableDictionary *env = [originalEnv mutableCopy] ?: [NSMutableDictionary dictionary];
		NSString *oldDylibs = env[@"DYLD_INSERT_LIBRARIES"];
		NSString *newDylibs = oldDylibs ? [NSString stringWithFormat:@"%@:%@", libPath, oldDylibs] : libPath;
		[env setObject:newDylibs forKey:@"DYLD_INSERT_LIBRARIES"];
		[env setObject:@"1" forKey:@"_MSSafeMode"];
		return env;
	}
	return originalEnv;
}

%end

@interface FBSystemService : NSObject

+(id)sharedInstance;
- (void)exitAndRelaunch:(bool)arg1;

@end

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object,  CFDictionaryRef userInfo) {
   // [(FBSystemService *)[UIApplication sharedApplication] exitAndRelaunch:YES];
//[[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
[[%c(FBSystemService) sharedInstance] exitAndRelaunch:NO];


}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                NULL,
                                (CFNotificationCallback)respring,
                                CFSTR("respringDevice"),
                                NULL,
                                CFNotificationSuspensionBehaviorDeliverImmediately);
}
