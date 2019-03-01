#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include "ExtensionKit.h"
#include "ExtensionKitIPhone.h"

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
    extensionkit::DispatchEventToHaxeInstance(
        textField.tag,
        "nativetext.event.NativeTextEvent",
        extensionkit::CSTRING, "nativetext_focus_in",
        extensionkit::CEND);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
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

//Declare a delegate, assign your textField to the delegate and then include these methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view 
    [self.view setFrame:CGRectMake(0,-110,320,460)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.

}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,320,460)];
}

@end