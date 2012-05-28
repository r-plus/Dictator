#define PREF_PATH @"/var/mobile/Library/Preferences/jp.r-plus.Dictator.plist"

static BOOL dictatorEnabled;
static NSString *dictatorLang;

static NSString *BCP47LanguageCode(NSString *identifier)
{
  NSMutableString *im = [NSMutableString string];
  if ([identifier rangeOfString:@"_"].location == NSNotFound)
    [im appendString:identifier];
  else {
    [im appendFormat:@"%@-", [identifier substringToIndex:2]];
    if ([identifier rangeOfString:@"-"].location == NSNotFound)
      [im appendString:[identifier substringWithRange:NSMakeRange(3, [identifier length] - 3)]];
    else
      [im appendString:[identifier substringWithRange:NSMakeRange(3, [identifier rangeOfString:@"-"].location -3)]];
  }
  return im;
}

%hook UIDictationController
- (NSString *)assistantCompatibleLanguageCodeForLanguage:(NSString *)lang region:(NSString *)originRegion
{
  if (dictatorEnabled && ![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Preferences"])
    return BCP47LanguageCode(dictatorLang);
  else
    return %orig;
}
%end

static void LoadSettings()
{	
  NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
  id existEnabled = [dict objectForKey:@"Enabled"];
  dictatorEnabled = existEnabled ? [existEnabled boolValue] : YES;
  id existLang = [dict objectForKey:@"Lang"];
  dictatorLang = existLang ? [existLang copy] : @"en_US";
}

static void PostNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
  LoadSettings();
}

%ctor
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PostNotification, CFSTR("jp.r-plus.Dictator.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  LoadSettings();
  [pool drain];
}
