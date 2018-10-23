#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include "ExtensionKit.h"
#include "ExtensionKitIPhone.h"

#include "NativeTextIPhone.h"
#include "NativeTextProtocol.h"
#include "NativeTextView.h"

@implementation NativeTextView
{
    BOOL m_autosizeWidth;
    BOOL m_autosizeHeight;
}

- (id)initWithFrame:(CGRect)aRect;
{
    self = [super initWithFrame:aRect];
    if (self)
    {
        self->m_autosizeWidth = YES;
        self->m_autosizeHeight = YES;
    }
    return self;
}

- (void)configure:(const NativeTextFieldConfig&)config
{
    double scale = [[UIScreen mainScreen] scale];

    if (config.fontColor.IsSet())
    {
        self.textColor = extensionkit::iphone::UIColorFromRGB(config.fontColor.Value());
    }

    if (config.fontAsset.IsSet() && config.fontSize.IsSet()) {
        NSString * font = [NSString stringWithUTF8String:config.fontAsset.Value().c_str()];

//        NSLog(font);
//        NSArray *fonts = [UIFont familyNames];
//        for (NSString *item in fonts) {
//            NSLog(@"%@", item);
//        }

        self.font = [UIFont fontWithName:@"ArialMT" size:config.fontSize.Value()/scale];

        //NSLog(self.font.fontName);

        //self.font = [UIFont fontWithName:font size:config.fontSize.Value() / scale];
    }

    /*if (config.fontSize.IsSet())
    {
        self.font = [self.font fontWithSize:config.fontSize.Value() / scale];
        //self.font = [UIFont systemFontOfSize:config.fontSize.Value() / scale];
    }*/

    [self setPositionAndSizeFromConfig:config withScale:scale];

    if (config.visible.IsSet())
    {
        self.hidden = (config.visible.Value() ? NO : YES);
    }

    if (config.enabled.IsSet())
    {
        self.editable = (config.enabled.Value() ? YES : NO);
    }

    if (config.isPassword.IsSet())
    {
        if (config.isPassword.Value()) {
            self.secureTextEntry = YES;
        } else {
            self.secureTextEntry = NO;
        }
    }

    [self setTextAlignmentFromConfig:config];
    [self setKeyboardTypeFromConfig:config];
    [self setReturnKeyTypeFromConfig:config];
}

- (void)setPositionAndSizeFromConfig:(const NativeTextFieldConfig&)config withScale:(double)scale
{
    CGRect frame = self.frame;

    if (config.x.IsSet())
    {
        frame.origin.x = config.x.Value() / scale;
    }

    if (config.y.IsSet())
    {
        frame.origin.y = config.y.Value() / scale;
    }

    if (config.width.IsSet())
    {
        self->m_autosizeWidth = (config.width.Value() <= 0.0);

        if (config.width.Value() > 0.0)
        {
            frame.size.width = config.width.Value() / scale;
        }
    }

    if (config.height.IsSet())
    {
        self->m_autosizeHeight = (config.height.Value() <= 0.0);

        if (config.height.Value() > 0.0)
        {
            frame.size.height = config.height.Value() / scale;
        }
    }

    if (self->m_autosizeWidth)
    {
        frame.size.width = self.intrinsicContentSize.width;
    }

    if (self->m_autosizeHeight)
    {
        frame.size.height = self.intrinsicContentSize.height;
    }

    [[self getView] setFrame:frame];
}

- (void)setTextAlignmentFromConfig:(const NativeTextFieldConfig&)config
{
    if (!config.textAlignment.IsSet())
    {
        return;
    }

    switch (config.textAlignment.Value())
    {
        case NativeTextFieldConfig::TAL_NATURAL:
            self.textAlignment = NSTextAlignmentNatural;
            break;

        case NativeTextFieldConfig::TAL_LEFT:
            self.textAlignment = NSTextAlignmentLeft;
            break;

        case NativeTextFieldConfig::TAL_CENTER:
            self.textAlignment = NSTextAlignmentCenter;
            break;

        case NativeTextFieldConfig::TAL_RIGHT:
            self.textAlignment = NSTextAlignmentRight;
            break;
    }
}

- (void)setKeyboardTypeFromConfig:(const NativeTextFieldConfig&)config
{
    if (!config.keyboardType.IsSet())
    {
        return;
    }

    self.secureTextEntry = NO;
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.spellCheckingType = UITextSpellCheckingTypeNo;

    switch (config.keyboardType.Value())
    {
        case NativeTextFieldConfig::KB_DEFAULT:
            self.keyboardType = UIKeyboardTypeDefault;
            self.spellCheckingType = UITextSpellCheckingTypeDefault;
            self.autocorrectionType = UITextAutocorrectionTypeDefault;
            break;

        case NativeTextFieldConfig::KB_PASSWORD:
            self.keyboardType = UIKeyboardTypeDefault;
            self.secureTextEntry = YES;
            break;

        case NativeTextFieldConfig::KB_DECIMAL:
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;

        case NativeTextFieldConfig::KB_NAME:
            self.keyboardType = UIKeyboardTypeDefault;
            self.autocapitalizationType = UITextAutocapitalizationTypeWords;
            break;

        case NativeTextFieldConfig::KB_EMAIL:
            self.keyboardType = UIKeyboardTypeEmailAddress;
            break;

        case NativeTextFieldConfig::KB_PHONE:
            self.keyboardType = UIKeyboardTypePhonePad;
            break;

        case NativeTextFieldConfig::KB_URL:
            self.keyboardType = UIKeyboardTypeURL;
            break;
    }
}

- (void)setReturnKeyTypeFromConfig:(const NativeTextFieldConfig&)config
{
    if (!config.returnKeyType.IsSet())
    {
        return;
    }

    switch (config.returnKeyType.Value())
    {
        case NativeTextFieldConfig::RK_DEFAULT:
            self.returnKeyType = UIReturnKeyDefault;
            break;

        case NativeTextFieldConfig::RK_GO:
            self.returnKeyType = UIReturnKeyGo;
            break;

        case NativeTextFieldConfig::RK_NEXT:
            self.returnKeyType = UIReturnKeyNext;
            break;

        case NativeTextFieldConfig::RK_SEARCH:
            self.returnKeyType = UIReturnKeySearch;
            break;

        case NativeTextFieldConfig::RK_SEND:
            self.returnKeyType = UIReturnKeySend;
            break;

        case NativeTextFieldConfig::RK_DONE:
            self.returnKeyType = UIReturnKeyDone;
            break;
    }
}

- (UIView *) getView { return self; }

- (NSString *)getNativeText { return self.text; }

- (void)setNativeText: (NSString *)text {
    self.text = text;
}
- (float) getContentHeight {
    return self.contentSize.height;
}

@end