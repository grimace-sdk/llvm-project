// RUN: %clang_cc1 -triple armv4-unknown-none-wince -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple sh3el-unknown-none-wince -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple armv4-unknown-none-eabi -emit-llvm -o - %s | FileCheck %s --check-prefix=EABI

// CHECK: @one = global i8 1, align 1
// CHECK: @two = global [2 x i8] c"ab", align 4
// CHECK: @.str = private unnamed_addr constant [5 x i8] c"SHEL\00", align 4
// EABI: @two = global [2 x i8] c"ab", align 1
// EABI: @.str = private unnamed_addr constant [5 x i8] c"SHEL\00", align 1

char one = 1;
char two[2] = {'a', 'b'};

const char *name(void) { return "SHEL"; }
