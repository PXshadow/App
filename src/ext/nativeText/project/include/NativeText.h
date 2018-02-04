#ifndef NATIVETEXT_H
#define NATIVETEXT_H

#include "NativeTextFieldConfig.h"


namespace nativetext
{
    void Initialize();
    void CreateTextField(int eventDispatcherId, bool multiline);
    void DestroyTextField(int eventDispatcherId);
    void ConfigureTextField(int eventDispatcherId, const NativeTextFieldConfig& config);
    const char* GetText(int eventDispatcherId);
    void SetText(int eventDispatcherId, const char* text);
    bool IsFocused(int eventDispatcherId);
    void SetFocus(int eventDispatcherId);
    void ClearFocus(int eventDispatcherId);
    float GetContentHeight(int eventDispatcherId);
}


#endif