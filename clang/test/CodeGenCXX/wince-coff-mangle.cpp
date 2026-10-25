// RUN: %clang_cc1 -triple armv4t-unknown-none-wincecoff -emit-llvm -o - %s | FileCheck %s

struct HWND__;
typedef HWND__ *HWND;

class CWindow {
public:
  static unsigned int GetStyle_I(HWND window);
  virtual int Paint(int flags);
  int count;
};

class MsgQueue {
public:
  MsgQueue *UserInterfaceContextOwner();
};

unsigned int CWindow::GetStyle_I(HWND window) { return window ? 1 : 0; }
int CWindow::Paint(int flags) { return flags + count; }
MsgQueue *MsgQueue::UserInterfaceContextOwner() { return this; }

// CHECK: define {{.*}} @"?GetStyle_I@CWindow@@SAIPAUHWND__@@@Z"
// CHECK: define {{.*}} @"?Paint@CWindow@@UAAHH@Z"
// CHECK: define {{.*}} @"?UserInterfaceContextOwner@MsgQueue@@QAAPAV1@XZ"
