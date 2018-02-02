#ifndef NATIVETEXTVIEW_H
#define NATIVETEXTVIEW_H

#include "NativeTextIPhone.h"

//--------------------------------------
// UITextField Subclass with Extra State
//--------------------------------------

using namespace nativetext;

@interface NativeTextView : UITextView<NativeTextProtocol>
{
}
- (id)initWithFrame:(CGRect)aRect;
- (void)configure:(const NativeTextFieldConfig&)config;
- (void)setPositionAndSizeFromConfig:(const NativeTextFieldConfig&)config withScale:(double)scale;
- (void)setTextAlignmentFromConfig:(const NativeTextFieldConfig&)config;
- (void)setKeyboardTypeFromConfig:(const NativeTextFieldConfig&)config;
- (void)setReturnKeyTypeFromConfig:(const NativeTextFieldConfig&)config;
- (UIView *)getView;
- (float) getContentHeight;
@end


#endif