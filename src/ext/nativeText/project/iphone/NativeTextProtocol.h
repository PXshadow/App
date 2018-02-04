#ifndef NATIVETEXTPROTOCOL_H
#define NATIVETEXTPROTOCOL_H

using namespace nativetext;

@protocol NativeTextProtocol
- (id)initWithFrame:(CGRect)aRect;
- (void)configure:(const NativeTextFieldConfig&)config;
- (void)setPositionAndSizeFromConfig:(const NativeTextFieldConfig&)config withScale:(double)scale;
- (void)setTextAlignmentFromConfig:(const NativeTextFieldConfig&)config;
- (void)setKeyboardTypeFromConfig:(const NativeTextFieldConfig&)config;
- (void)setReturnKeyTypeFromConfig:(const NativeTextFieldConfig&)config;
- (UIView *)getView;

- (NSString *)getNativeText;
- (void)setNativeText: (NSString *)text;

- (float) getContentHeight;
@end
#endif