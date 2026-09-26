#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <version.h>

// ---- Jailbreak root path helper (rootful / rootless / roothide) ----
#if defined(PO2_ROOTHIDE)
	#include <roothide.h>
	#define PO2JBPath(p) jbroot(p)
#elif defined(PO2_ROOTLESS)
	#define PO2JBPath(p) ([@"/var/jb" stringByAppendingString:(p)])
#else
	#define PO2JBPath(p) (p)
#endif

#define NSLog(LogContents, ...) NSLog((@"PreferenceOrganizer 2: %s:%d " LogContents), __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define PO2PreferencePath @"/var/mobile/Library/Preferences/net.angelxwind.preferenceorganizer2.plist"

#define STRINGIFY_(x) #x
#define STRINGIFY(x) STRINGIFY_(x)

#define PO2BoolLog(arg) PO2Log([NSString stringWithFormat:@"%s = %d", #arg, arg], shouldSyslogSpam)
#define PO2BoolPref(var, key, default) do {\
	NSNumber *key = PO2Settings[@STRINGIFY(key)];\
	var = key ? [key boolValue] : default;\
	PO2BoolLog(var);\
} while (0)

#define PO2IntLog(arg) PO2Log([NSString stringWithFormat:@"%s = %i", #arg, arg], shouldSyslogSpam)
#define PO2IntPref(var, key, default) do {\
	NSNumber *key = PO2Settings[@STRINGIFY(key)];\
	var = key ? [key intValue] : default;\
	PO2IntLog(var);\
} while (0)

#define PO2FloatLog(arg) PO2Log([NSString stringWithFormat:@"%s = %f", #arg, arg], shouldSyslogSpam)
#define PO2FloatPref(var, key, default) do {\
	NSNumber *key = PO2Settings[@STRINGIFY(key)];\
	var = key ? [key floatValue] : default;\
	PO2FloatLog(var);\
} while (0)

#define PO2StringLog(arg) PO2Log([NSString stringWithFormat:@"%s = %@", #arg, arg], shouldSyslogSpam)
#define PO2StringPref(var, key, default) do {\
	NSString *key = PO2Settings[@STRINGIFY(key)];\
	var = ([key length] > 0) ? key : default;\
	PO2StringLog(var);\
} while (0)

#define PO2Observer(funcToCall, listener) CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)funcToCall, CFSTR(listener), NULL, CFNotificationSuspensionBehaviorCoalesce);
#define PO2PreferenceDomain @"net.angelxwind.preferenceorganizer2"
// Read through cfprefsd (the file on disk can be stale on iOS 8+)
#define PO2SyncPrefs()\
	NSDictionary *PO2Settings = [[NSUserDefaults standardUserDefaults] persistentDomainForName:PO2PreferenceDomain];

#define isJonyIve() (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)