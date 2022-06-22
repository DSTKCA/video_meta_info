#import "VideoMetaInfoPlugin.h"
#if __has_include(<video_meta_info/video_meta_info-Swift.h>)
#import <video_meta_info/video_meta_info-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "video_meta_info-Swift.h"
#endif

@implementation VideoMetaInfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVideoMetaInfoPlugin registerWithRegistrar:registrar];
}
@end
