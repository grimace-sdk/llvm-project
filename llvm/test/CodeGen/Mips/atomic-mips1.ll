; RUN: llc -mtriple=mipsel-unknown-linux-gnu -mcpu=mips1 -relocation-model=static -verify-machineinstrs < %s | \
; RUN:   FileCheck %s -check-prefix=MIPS1 --implicit-check-not="{{[[:space:]]}}ll{{[[:space:]]}}" \
; RUN:     --implicit-check-not="{{[[:space:]]}}sc{{[[:space:]]}}"
; RUN: llc -mtriple=mipsel-unknown-linux-gnu -mcpu=mips2 -relocation-model=static -verify-machineinstrs < %s | \
; RUN:   FileCheck %s -check-prefix=MIPS2

define i8 @load_i8(ptr %p) {
; MIPS1-LABEL: load_i8:
; MIPS1: jal __atomic_load_1
; MIPS2-LABEL: load_i8:
; MIPS2: lb
; MIPS2: sync
  %v = load atomic i8, ptr %p seq_cst, align 1
  ret i8 %v
}

define void @store_i16(ptr %p, i16 %v) {
; MIPS1-LABEL: store_i16:
; MIPS1: jal __atomic_store_2
; MIPS2-LABEL: store_i16:
; MIPS2: sh
  store atomic i16 %v, ptr %p seq_cst, align 2
  ret void
}

define i32 @load_i32(ptr %p) {
; MIPS1-LABEL: load_i32:
; MIPS1: jal __atomic_load_4
; MIPS2-LABEL: load_i32:
; MIPS2: lw
  %v = load atomic i32, ptr %p seq_cst, align 4
  ret i32 %v
}

define i32 @xchg_i32(ptr %p, i32 %v) {
; MIPS1-LABEL: xchg_i32:
; MIPS1: jal __atomic_exchange_4
; MIPS2-LABEL: xchg_i32:
; MIPS2: ll
; MIPS2: sc
  %old = atomicrmw xchg ptr %p, i32 %v seq_cst
  ret i32 %old
}

define i8 @add_i8(ptr %p, i8 %v) {
; MIPS1-LABEL: add_i8:
; MIPS1: jal __atomic_fetch_add_1
; MIPS2-LABEL: add_i8:
; MIPS2: ll
; MIPS2: sc
  %old = atomicrmw add ptr %p, i8 %v seq_cst
  ret i8 %old
}

define i32 @add_i32(ptr %p, i32 %v) {
; MIPS1-LABEL: add_i32:
; MIPS1: jal __atomic_fetch_add_4
; MIPS2-LABEL: add_i32:
; MIPS2: ll
; MIPS2: sc
  %old = atomicrmw add ptr %p, i32 %v seq_cst
  ret i32 %old
}

define i32 @cmpxchg_i32(ptr %p, i32 %expected, i32 %desired) {
; MIPS1-LABEL: cmpxchg_i32:
; MIPS1: jal __atomic_compare_exchange_4
; MIPS2-LABEL: cmpxchg_i32:
; MIPS2: ll
; MIPS2: sc
  %pair = cmpxchg ptr %p, i32 %expected, i32 %desired seq_cst seq_cst
  %old = extractvalue { i32, i1 } %pair, 0
  ret i32 %old
}
