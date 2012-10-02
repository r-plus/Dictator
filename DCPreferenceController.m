#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

@interface UIDictationController : NSObject
+ (id)sharedInstance;
- (BOOL)supportsInputMode:(id)arg1 error:(id*)arg2;
@end

@interface UIKeyboardInputModeController : NSObject
+ (id)sharedInputModeController;
- (NSArray *)supportedInputModeIdentifiers;
@end

__attribute__((visibility("hidden")))
@interface DCPreferenceController : PSListController
- (id)specifiers;
- (NSArray *)source:(id)target;
@end

@implementation DCPreferenceController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Dictator" target:self] retain];
  }
	return _specifiers;
}

- (NSArray *)source:(id)target {
  return [[UIKeyboardInputModeController sharedInputModeController] supportedInputModeIdentifiers];
}

@end
