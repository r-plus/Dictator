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

- (NSArray *)source:(id)target
{
  NSMutableArray *array = [NSMutableArray array];

  for (NSString *identifier in [[UIKeyboardInputModeController sharedInputModeController] supportedInputModeIdentifiers])
    if ([[objc_getClass("UIDictationController") sharedInstance] supportsInputMode:identifier error:nil])
      [array addObject:identifier];

  return array;
}

@end
