; RUN: llc -mtriple=armv4t-unknown-none-wincecoff -mcpu=arm926ej-s < %s | FileCheck %s
; RUN: llc -mtriple=armv4t-unknown-none-wincecoff -mcpu=arm926ej-s -filetype=obj < %s \
; RUN:   | llvm-readobj --file-headers -r - | FileCheck %s --check-prefix=OBJ
; RUN: llc -mtriple=armv4t-unknown-none-wincecoff -mcpu=arm926ej-s -filetype=obj < %s \
; RUN:   | llvm-objdump -d - | FileCheck %s --check-prefix=DIS

@counter = global i32 3

declare i32 @external(i32)
declare dllimport i32 @imported(i32)

define i32 @caller(i32 %value) {
  %loaded = load i32, ptr @counter
  %first = call i32 @external(i32 %loaded)
  %second = call i32 @imported(i32 %first)
  ret i32 %second
}

; CHECK-LABEL: caller:
; CHECK-NOT: movw
; CHECK: bl external
; CHECK: .long counter
; CHECK: .long __imp_imported

; OBJ: Machine: IMAGE_FILE_MACHINE_ARM (0x1C0)
; OBJ-DAG: IMAGE_REL_ARM_BRANCH24 external
; OBJ-DAG: IMAGE_REL_ARM_ADDR32 counter
; OBJ-DAG: IMAGE_REL_ARM_ADDR32 __imp_imported

; DIS: eb000000 bl
