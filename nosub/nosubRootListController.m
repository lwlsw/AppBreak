#include "nosubRootListController.h"
#define nosubPath @"/User/Library/Preferences/com.lwlsw.appbreak.plist"

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;

@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1;
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 inTableView:(id)arg2;
@end
@interface PSTableCell ()
- (id)initWithStyle:(int)style reuseIdentifier:(id)arg2;
@end

@implementation nosubRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];

	}
	return _specifiers;


}

-(id) readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *nosubSettings = [NSDictionary dictionaryWithContentsOfFile:nosubPath];
	if (!nosubSettings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return nosubSettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:nosubPath]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:nosubPath atomically:YES];
	//  NSDictionary *nosubSettings = [NSDictionary dictionaryWithContentsOfFile:nosubPath];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
	//  system("killall -9 Music");
}



- (void)kill {
	CFNotificationCenterPostNotification (CFNotificationCenterGetDarwinNotifyCenter(),
										  CFSTR("respringDevice"),
										  NULL,
										  NULL,
										  false);
}

-(void)git {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Skylerk99/PalBreak"]];
}
@end
