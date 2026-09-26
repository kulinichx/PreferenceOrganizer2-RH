// Replacement for KarenLocalizer (no external dependency).
// Loads <jbroot>/Library/PreferenceOrganizer2/Localizations.bundle/<Lang>.lproj/Localizable.strings
#import <Foundation/Foundation.h>
#import "PO2Common.h"

static inline NSString *PO2LprojNameForLanguage(NSString *lang) {
	lang = [lang lowercaseString];
	if ([lang hasPrefix:@"zh-hant"] || [lang hasPrefix:@"zh-tw"] || [lang hasPrefix:@"zh-hk"]) return @"zh_TW";
	if ([lang hasPrefix:@"zh"]) return @"zh_CN";
	NSDictionary *map = @{
		@"en": @"English", @"ja": @"Japanese", @"de": @"German", @"it": @"Italian",
		@"es": @"Spanish", @"da": @"Danish", @"hr": @"Croatian", @"ar": @"Arabic",
		@"th": @"Thai", @"tr": @"Turkish", @"ms": @"Malay"
	};
	NSString *code = [[lang componentsSeparatedByString:@"-"] firstObject];
	return map[code];
}

static inline NSString *PO2LocalizedString(NSString *key) {
	static NSDictionary *table = nil;
	static NSDictionary *fallback = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		NSString *base = PO2JBPath(@"/Library/PreferenceOrganizer2/Localizations.bundle");
		NSString *(^pathFor)(NSString *) = ^NSString *(NSString *lproj) {
			return [base stringByAppendingFormat:@"/%@.lproj/Localizable.strings", lproj];
		};
		for (NSString *lang in [NSLocale preferredLanguages]) {
			NSString *lproj = PO2LprojNameForLanguage(lang);
			if (!lproj) continue;
			NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:pathFor(lproj)];
			if (d) { table = [d retain]; break; }
		}
		fallback = [[NSDictionary dictionaryWithContentsOfFile:pathFor(@"English")] retain];
	});
	return table[key] ?: fallback[key] ?: key;
}
