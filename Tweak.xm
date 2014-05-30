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
            [im appendString:[identifier substringWithRange:NSMakeRange(3, [identifier rangeOfString:@"-"].location - 3)]];
    }
    return im;
}

%hook UIDictationController
// iOS 7.0 -
- (NSString *)assistantCompatibleLanguageCodeForInputMode:(NSString *)langAndKeyboard//en_US@hw=US;sw=QWERTY
{
    NSString *tmp = %orig;
    if (dictatorEnabled)
        return BCP47LanguageCode(dictatorLang);
    else
        return tmp;
}
// iOS 5.1 - 6.1
- (NSString *)assistantCompatibleLanguageCodeForLanguage:(NSString *)lang region:(NSString *)originRegion
{
    NSString *tmp = %orig;
    if (dictatorEnabled)
        return BCP47LanguageCode(dictatorLang);
    else
        return tmp;
}
- (BOOL)supportsInputMode:(id)arg1 error:(id*)arg2
{
    BOOL tmp = %orig;
    return dictatorEnabled ? YES : tmp;
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
    @autoreleasepool {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PostNotification, CFSTR("jp.r-plus.Dictator.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        LoadSettings();
    };
}
