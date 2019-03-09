#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include "ExtensionKit.h"
#include "ExtensionKitIPhone.h"
//#include "NSNotificationCenter.h"

#include "NativeTextContainerView.h"

@implementation NativeTextContainerView
{
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{	
    [super touchesCancelled:touches withEvent:event];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //event
    extensionkit::DispatchEventToHaxeInstance(
        textField.tag,
        "nativetext.event.NativeTextEvent",
        extensionkit::CSTRING, "nativetext_focus_in",
        extensionkit::CEND);
}
    
    // Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        
    }

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //event
    extensionkit::DispatchEventToHaxeInstance(
        textField.tag,
        "nativetext.event.NativeTextEvent",
        extensionkit::CSTRING, "nativetext_focus_out",
        extensionkit::CEND);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    extensionkit::DispatchEventToHaxeInstance(
        textField.tag,
        "nativetext.event.NativeTextEvent",
        extensionkit::CSTRING, "nativetext_change",
        extensionkit::CEND);

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (UIReturnKeyNext == textField.returnKeyType)
    {
        int viewIndex = [self.subviews indexOfObject:textField];
        
        for (int i = viewIndex + 1; i < self.subviews.count; i++)
        {
            UIView* currentSubview = [self.subviews objectAtIndex:i];			
            if (!currentSubview.hidden)
            {
                [currentSubview becomeFirstResponder];
                break;
            }
        }
    }
    
    extensionkit::DispatchEventToHaxeInstance(
        textField.tag,
        "nativetext.event.NativeTextEvent",
        extensionkit::CSTRING, "nativetext_return_key_pressed",
        extensionkit::CEND);
    
    return NO;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    UIView.view.frame = CGRectMake(0,-300,UIView.view.frame.width,UIView.view.frame.height);
    [UIView commitAnimations];
    
      extensionkit::DispatchEventToHaxeInstance(
      textView.tag,
      "nativetext.event.NativeTextEvent",
      extensionkit::CSTRING, "nativetext_focus_in",
      extensionkit::CEND);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    extensionkit::DispatchEventToHaxeInstance(
        textView.tag,
        "nativetext.event.NativeTextEvent",
        extensionkit::CSTRING, "nativetext_focus_out",
        extensionkit::CEND);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    extensionkit::DispatchEventToHaxeInstance(
        textView.tag,
        "nativetext.event.NativeTextEvent",
        extensionkit::CSTRING, "nativetext_change",
        extensionkit::CEND);

    return YES;
}

@end
