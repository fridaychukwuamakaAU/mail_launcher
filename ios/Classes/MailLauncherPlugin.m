#import "MailLauncherPlugin.h"
#if __has_include(<mail_launcher/mail_launcher-Swift.h>)
#import <mail_launcher/mail_launcher-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mail_launcher-Swift.h"
#endif

@implementation MailLauncherPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMailLauncherPlugin registerWithRegistrar:registrar];
}
@end
