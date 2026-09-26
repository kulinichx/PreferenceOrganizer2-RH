// PreferenceOrganizer 2 settings pane — RootHide/rootless port.
// KarenPrefs dependency removed; uses stock Preferences.framework only.
#import "../PO2Common.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <UIKit/UIKit.h>
#include <spawn.h>
#include <signal.h>

static NSString *const kPODonateURL = @"https://paypal.me/akemindayo"; // original author
#define POColor [UIColor colorWithRed:1.0 green:168.0/255.0 blue:0.0 alpha:1.0]

@interface PSListController (PO2)
- (NSString *)localizedString:(NSString *)key;
@end

@interface POListController : PSListController
@end

@implementation POListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"PreferenceOrganizer2" target:self];
	}
	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	UIWindow *w = self.view.window ?: [UIApplication sharedApplication].keyWindow;
	w.tintColor = POColor;
	self.navigationController.navigationBar.tintColor = POColor;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.view.window.tintColor = nil;
	self.navigationController.navigationBar.tintColor = nil;
}

- (NSString *)po2String:(NSString *)key {
	return [[NSBundle bundleForClass:[self class]] localizedStringForKey:key value:key table:@"PreferenceOrganizer2"];
}

- (void)po2Alert:(NSString *)title message:(NSString *)message button:(NSString *)button {
	UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	[ac addAction:[UIAlertAction actionWithTitle:button style:UIAlertActionStyleDefault handler:nil]];
	[self presentViewController:ac animated:YES completion:nil];
}

- (void)resetSettings {
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:PO2PreferenceDomain];
	[[NSFileManager defaultManager] removeItemAtPath:PO2PreferencePath error:nil];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("net.angelxwind.preferenceorganizer2-PreferencesChanged"), NULL, NULL, YES);
	[self reloadSpecifiers];
	[self po2Alert:[self po2String:@"PREFS_RESET_SUCCESS"] message:[self po2String:@"PREFS_RESET_SUCCESS_DETAIL"] button:[self po2String:@"OK_WINK"]];
}

// "Apply (Quit Settings)": suspend to Home Screen, then exit so the next launch re-organises.
- (void)closeSettings {
	[self.view endEditing:YES];
	[[NSUserDefaults standardUserDefaults] synchronize];
	UIApplication *app = [UIApplication sharedApplication];
	if ([app respondsToSelector:@selector(suspend)]) {
		[app performSelector:@selector(suspend)];
	}
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		exit(0);
	});
}

- (void)openDonate {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kPODonateURL] options:@{} completionHandler:nil];
}

@end

@interface POSwitchCell : PSSwitchTableCell
@end
@implementation POSwitchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
	if (self) {
		[(UISwitch *)self.control setOnTintColor:POColor];
	}
	return self;
}
@end

@interface POButtonCell : PSTableCell
@end
@implementation POButtonCell
- (void)layoutSubviews {
	[super layoutSubviews];
	self.textLabel.textColor = POColor;
}
@end

@interface POBannerCell : PSTableCell
@end
@implementation POBannerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		UIImage *img = [UIImage imageNamed:@"PreferenceOrganizer2Banner" inBundle:[NSBundle bundleForClass:[POListController class]] compatibleWithTraitCollection:nil];
		UIImageView *iv = [[UIImageView alloc] initWithImage:img];
		iv.contentMode = UIViewContentModeScaleAspectFit;
		iv.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:iv];
		[NSLayoutConstraint activateConstraints:@[
			[iv.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
			[iv.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
			[iv.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
			[iv.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
		]];
	}
	return self;
}
@end
