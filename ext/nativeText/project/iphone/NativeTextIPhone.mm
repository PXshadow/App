#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include "ExtensionKit.h"
#include "ExtensionKitIPhone.h"

#include "NativeTextIPhone.h"
#include "NativeTextProtocol.h"
#include "NativeTextContainerView.h"
#include "NativeTextFieldView.h"
#include "NativeTextView.h"

using namespace nativetext;

//-------------------------------------
// External Interface
//-------------------------------------

static NativeTextContainerView* g_textFieldContainerView = NULL;


namespace nativetext
{
    namespace iphone
    {
        //-----------------------------
        // Private Functions
        //-----------------------------
        
        void EnsureTextFieldContainerViewHasBeenCreated()
        {
            if (g_textFieldContainerView == NULL)
            {
                UIView* topView = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
                
                g_textFieldContainerView = [[NativeTextContainerView alloc] initWithFrame:topView.bounds];
                
                g_textFieldContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                g_textFieldContainerView.opaque = NO;
                g_textFieldContainerView.userInteractionEnabled = YES;
                g_textFieldContainerView.multipleTouchEnabled = YES;
                
                [topView addSubview:g_textFieldContainerView];
            }
        }
        
        UIView<NativeTextProtocol>* FindTextFieldById(int eventDispatcherId, bool suppressWarning = false)
        {
            UIView * view = [g_textFieldContainerView viewWithTag:eventDispatcherId];

            //NSLog(@"Is kind of UITextField: %@", ([view isKindOfClass:[UITextField class]] ? @"YES" : @"NO"));

            UIView<NativeTextProtocol>* textField = (UIView<NativeTextProtocol>*) view;
            
            if (!suppressWarning && !textField)
            {
                 printf("[ERROR] NativeText: Unable to find UITextField with ID=%d.\n", eventDispatcherId);
            }
            
            return textField;
        }        
        
        //-----------------------------
        // Public API
        //-----------------------------

        void InitializeIPhone()
        {
        }
                
        void CreateTextField(int eventDispatcherId, bool multiline)
        {
            EnsureTextFieldContainerViewHasBeenCreated();
            
            if (FindTextFieldById(eventDispatcherId, true))
            {
                printf("[ERROR] NativeText: Trying to create a new EditText with a previously used ID (%d), skipping.", eventDispatcherId);
                return;
            }
            
            CGRect frame = CGRectMake(0, 0, 0, 0);			

//            printf("NativeText: creating ID (%d).\n", eventDispatcherId);

            if (! multiline) {
                NativeTextFieldView* textField = [[NativeTextFieldView alloc] initWithFrame:frame];
                textField.tag = eventDispatcherId;
                textField.delegate = g_textFieldContainerView;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;

                frame.size = textField.intrinsicContentSize;
                [textField setFrame:frame];

                [g_textFieldContainerView addSubview:textField];
            } else {
                NativeTextView* textField = [[NativeTextView alloc] initWithFrame:frame];
                textField.tag = eventDispatcherId;
                textField.delegate = g_textFieldContainerView;

                frame.size = textField.intrinsicContentSize;
                [textField setFrame:frame];

                [g_textFieldContainerView addSubview:textField];
            }
        }
        
        void DestroyTextField(int eventDispatcherId)
        {
            UIView<NativeTextProtocol>* textField = FindTextFieldById(eventDispatcherId);
            if (textField)
            {
                [textField removeFromSuperview];
            }
        }
        
        void ConfigureTextField(int eventDispatcherId, const NativeTextFieldConfig& config)
        {
            UIView<NativeTextProtocol>* textField = FindTextFieldById(eventDispatcherId);
            if (textField)
            {
                [textField configure:config];
            }			
        }

        const char* GetText(int eventDispatcherId)
        {
            UIView<NativeTextProtocol>* textField = FindTextFieldById(eventDispatcherId);
            if (textField)
            {
                return [[textField getNativeText] UTF8String];
            }
            
            return NULL;
        }
        
        void SetText(int eventDispatcherId, const char* text)
        {
            UIView<NativeTextProtocol>* textField = FindTextFieldById(eventDispatcherId);
            if (textField)
            {
                [textField setNativeText:[NSString stringWithUTF8String:text]];
            }
        }
        
        bool IsFocused(int eventDispatcherId)
        {
            UIView<NativeTextProtocol>* textField = FindTextFieldById(eventDispatcherId);
            if (textField)
            {
                return (YES == textField.isFirstResponder);
            }
            else
            {
                return false;
            }
        }
        
        void SetFocus(int eventDispatcherId)
        {
            UIView<NativeTextProtocol>* textField = FindTextFieldById(eventDispatcherId);
            if (textField && !textField.isFirstResponder)
            {
                [textField becomeFirstResponder];
            }
        }

        void ClearFocus(int eventDispatcherId)
        {
            UIView<NativeTextProtocol>* textField = FindTextFieldById(eventDispatcherId);
            if (textField && textField.isFirstResponder)
            {
                [textField resignFirstResponder];
            }
        }

        float GetContentHeight(int eventDispatcherId) {
            UIView<NativeTextProtocol>* textField = FindTextFieldById(eventDispatcherId);
            return [textField getContentHeight];
        }
    }
}