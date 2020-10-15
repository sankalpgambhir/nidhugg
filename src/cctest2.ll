; ModuleID = 'cctest2.cc'
source_filename = "cctest2.cc"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"struct.std::atomic" = type { %"struct.std::__atomic_base" }
%"struct.std::__atomic_base" = type { i32 }
%class.anon = type { i8 }
%class.anon.0 = type { i8 }
%union.pthread_attr_t = type { i64, [48 x i8] }

$_ZStanSt12memory_orderSt23__memory_order_modifier = comdat any

$__clang_call_terminate = comdat any

@x = dso_local global { i32 } zeroinitializer, align 4
@y = dso_local global { i32 } zeroinitializer, align 4
@v = dso_local global [1 x %"struct.std::atomic"] zeroinitializer, align 4

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @_Z2t0v() #0 personality i32 (...)* @__gxx_personality_v0 {
  %1 = alloca %"struct.std::__atomic_base"*, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %"struct.std::__atomic_base"* bitcast ({ i32 }* @x to %"struct.std::__atomic_base"*), %"struct.std::__atomic_base"** %1, align 8
  store i32 1, i32* %2, align 4
  store i32 0, i32* %3, align 4
  %6 = load %"struct.std::__atomic_base"*, %"struct.std::__atomic_base"** %1, align 8
  %7 = load i32, i32* %3, align 4
  %8 = invoke i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 %7, i32 65535)
          to label %9 unwind label %19

9:                                                ; preds = %0
  store i32 %8, i32* %4, align 4
  %10 = getelementptr inbounds %"struct.std::__atomic_base", %"struct.std::__atomic_base"* %6, i32 0, i32 0
  %11 = load i32, i32* %3, align 4
  %12 = load i32, i32* %2, align 4
  store i32 %12, i32* %5, align 4
  switch i32 %11, label %13 [
    i32 3, label %15
    i32 5, label %17
  ]

13:                                               ; preds = %9
  %14 = load i32, i32* %5, align 4
  store atomic i32 %14, i32* %10 monotonic, align 4
  br label %22

15:                                               ; preds = %9
  %16 = load i32, i32* %5, align 4
  store atomic i32 %16, i32* %10 release, align 4
  br label %22

17:                                               ; preds = %9
  %18 = load i32, i32* %5, align 4
  store atomic i32 %18, i32* %10 seq_cst, align 4
  br label %22

19:                                               ; preds = %0
  %20 = landingpad { i8*, i32 }
          catch i8* null
  %21 = extractvalue { i8*, i32 } %20, 0
  call void @__clang_call_terminate(i8* %21) #6
  unreachable

22:                                               ; preds = %13, %15, %17
  ret void
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @_Z2t1v() #0 personality i32 (...)* @__gxx_personality_v0 {
  %1 = alloca %"struct.std::__atomic_base"*, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca %"struct.std::__atomic_base"*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store %"struct.std::__atomic_base"* bitcast ({ i32 }* @x to %"struct.std::__atomic_base"*), %"struct.std::__atomic_base"** %5, align 8
  store i32 2, i32* %6, align 4
  store i32 0, i32* %7, align 4
  %11 = load %"struct.std::__atomic_base"*, %"struct.std::__atomic_base"** %5, align 8
  %12 = load i32, i32* %7, align 4
  %13 = invoke i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 %12, i32 65535)
          to label %14 unwind label %24

14:                                               ; preds = %0
  store i32 %13, i32* %8, align 4
  %15 = getelementptr inbounds %"struct.std::__atomic_base", %"struct.std::__atomic_base"* %11, i32 0, i32 0
  %16 = load i32, i32* %7, align 4
  %17 = load i32, i32* %6, align 4
  store i32 %17, i32* %9, align 4
  switch i32 %16, label %18 [
    i32 3, label %20
    i32 5, label %22
  ]

18:                                               ; preds = %14
  %19 = load i32, i32* %9, align 4
  store atomic i32 %19, i32* %15 monotonic, align 4
  br label %27

20:                                               ; preds = %14
  %21 = load i32, i32* %9, align 4
  store atomic i32 %21, i32* %15 release, align 4
  br label %27

22:                                               ; preds = %14
  %23 = load i32, i32* %9, align 4
  store atomic i32 %23, i32* %15 seq_cst, align 4
  br label %27

24:                                               ; preds = %0
  %25 = landingpad { i8*, i32 }
          catch i8* null
  %26 = extractvalue { i8*, i32 } %25, 0
  call void @__clang_call_terminate(i8* %26) #6
  unreachable

27:                                               ; preds = %18, %20, %22
  store %"struct.std::__atomic_base"* bitcast ({ i32 }* @x to %"struct.std::__atomic_base"*), %"struct.std::__atomic_base"** %1, align 8
  store i32 0, i32* %2, align 4
  %28 = load %"struct.std::__atomic_base"*, %"struct.std::__atomic_base"** %1, align 8
  %29 = load i32, i32* %2, align 4
  %30 = invoke i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 %29, i32 65535)
          to label %31 unwind label %40

31:                                               ; preds = %27
  store i32 %30, i32* %3, align 4
  %32 = getelementptr inbounds %"struct.std::__atomic_base", %"struct.std::__atomic_base"* %28, i32 0, i32 0
  %33 = load i32, i32* %2, align 4
  switch i32 %33, label %34 [
    i32 1, label %36
    i32 2, label %36
    i32 5, label %38
  ]

34:                                               ; preds = %31
  %35 = load atomic i32, i32* %32 monotonic, align 4
  store i32 %35, i32* %4, align 4
  br label %43

36:                                               ; preds = %31, %31
  %37 = load atomic i32, i32* %32 acquire, align 4
  store i32 %37, i32* %4, align 4
  br label %43

38:                                               ; preds = %31
  %39 = load atomic i32, i32* %32 seq_cst, align 4
  store i32 %39, i32* %4, align 4
  br label %43

40:                                               ; preds = %27
  %41 = landingpad { i8*, i32 }
          catch i8* null
  %42 = extractvalue { i8*, i32 } %41, 0
  call void @__clang_call_terminate(i8* %42) #6
  unreachable

43:                                               ; preds = %34, %36, %38
  %44 = load i32, i32* %4, align 4
  store i32 %44, i32* %10, align 4
  ret void
}

; Function Attrs: noinline norecurse optnone sspstrong uwtable
define dso_local i32 @main() #1 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x i64], align 16
  %3 = alloca %class.anon, align 1
  %4 = alloca %class.anon.0, align 1
  %5 = alloca [2 x i64]*, align 8
  %6 = alloca i64*, align 8
  %7 = alloca i64*, align 8
  %8 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  %9 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 0
  %10 = call i8* (i8*)* @"_ZZ4mainENK3$_0cvPFPvS0_EEv"(%class.anon* %3) #7
  %11 = call i32 @pthread_create(i64* %9, %union.pthread_attr_t* null, i8* (i8*)* %10, i8* null) #7
  %12 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 1
  %13 = call i8* (i8*)* @"_ZZ4mainENK3$_1cvPFPvS0_EEv"(%class.anon.0* %4) #7
  %14 = call i32 @pthread_create(i64* %12, %union.pthread_attr_t* null, i8* (i8*)* %13, i8* null) #7
  store [2 x i64]* %2, [2 x i64]** %5, align 8
  %15 = load [2 x i64]*, [2 x i64]** %5, align 8
  %16 = getelementptr inbounds [2 x i64], [2 x i64]* %15, i64 0, i64 0
  store i64* %16, i64** %6, align 8
  %17 = load [2 x i64]*, [2 x i64]** %5, align 8
  %18 = getelementptr inbounds [2 x i64], [2 x i64]* %17, i64 0, i64 0
  %19 = getelementptr inbounds i64, i64* %18, i64 2
  store i64* %19, i64** %7, align 8
  br label %20

20:                                               ; preds = %29, %0
  %21 = load i64*, i64** %6, align 8
  %22 = load i64*, i64** %7, align 8
  %23 = icmp ne i64* %21, %22
  br i1 %23, label %24, label %32

24:                                               ; preds = %20
  %25 = load i64*, i64** %6, align 8
  %26 = load i64, i64* %25, align 8
  store i64 %26, i64* %8, align 8
  %27 = load i64, i64* %8, align 8
  %28 = call i32 @pthread_join(i64 %27, i8** null)
  br label %29

29:                                               ; preds = %24
  %30 = load i64*, i64** %6, align 8
  %31 = getelementptr inbounds i64, i64* %30, i32 1
  store i64* %31, i64** %6, align 8
  br label %20

32:                                               ; preds = %20
  ret i32 0
}

; Function Attrs: nounwind
declare !callback !4 i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #2

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define internal i8* (i8*)* @"_ZZ4mainENK3$_0cvPFPvS0_EEv"(%class.anon* %0) #0 align 2 {
  %2 = alloca %class.anon*, align 8
  store %class.anon* %0, %class.anon** %2, align 8
  %3 = load %class.anon*, %class.anon** %2, align 8
  ret i8* (i8*)* @"_ZZ4mainEN3$_08__invokeEPv"
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define internal i8* (i8*)* @"_ZZ4mainENK3$_1cvPFPvS0_EEv"(%class.anon.0* %0) #0 align 2 {
  %2 = alloca %class.anon.0*, align 8
  store %class.anon.0* %0, %class.anon.0** %2, align 8
  %3 = load %class.anon.0*, %class.anon.0** %2, align 8
  ret i8* (i8*)* @"_ZZ4mainEN3$_18__invokeEPv"
}

declare i32 @pthread_join(i64, i8**) #3

; Function Attrs: noinline optnone sspstrong uwtable
define internal i8* @"_ZZ4mainEN3$_08__invokeEPv"(i8* %0) #4 align 2 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  %3 = load i8*, i8** %2, align 8
  %4 = call i8* @"_ZZ4mainENK3$_0clEPv"(%class.anon* undef, i8* %3)
  ret i8* %4
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define internal i8* @"_ZZ4mainENK3$_0clEPv"(%class.anon* %0, i8* %1) #0 align 2 {
  %3 = alloca %class.anon*, align 8
  %4 = alloca i8*, align 8
  store %class.anon* %0, %class.anon** %3, align 8
  store i8* %1, i8** %4, align 8
  %5 = load %class.anon*, %class.anon** %3, align 8
  call void @_Z2t0v()
  ret i8* null
}

; Function Attrs: noinline optnone sspstrong uwtable
define internal i8* @"_ZZ4mainEN3$_18__invokeEPv"(i8* %0) #4 align 2 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  %3 = load i8*, i8** %2, align 8
  %4 = call i8* @"_ZZ4mainENK3$_1clEPv"(%class.anon.0* undef, i8* %3)
  ret i8* %4
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define internal i8* @"_ZZ4mainENK3$_1clEPv"(%class.anon.0* %0, i8* %1) #0 align 2 {
  %3 = alloca %class.anon.0*, align 8
  %4 = alloca i8*, align 8
  store %class.anon.0* %0, %class.anon.0** %3, align 8
  store i8* %1, i8** %4, align 8
  %5 = load %class.anon.0*, %class.anon.0** %3, align 8
  call void @_Z2t1v()
  ret i8* null
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define linkonce_odr dso_local i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 %0, i32 %1) #0 comdat {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %3, align 4
  %6 = load i32, i32* %4, align 4
  %7 = and i32 %5, %6
  ret i32 %7
}

declare i32 @__gxx_personality_v0(...)

; Function Attrs: noinline noreturn nounwind
define linkonce_odr hidden void @__clang_call_terminate(i8* %0) #5 comdat {
  %2 = call i8* @__cxa_begin_catch(i8* %0) #7
  call void @_ZSt9terminatev() #6
  unreachable
}

declare i8* @__cxa_begin_catch(i8*)

declare void @_ZSt9terminatev()

attributes #0 = { noinline nounwind optnone sspstrong uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { noinline norecurse optnone sspstrong uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noinline optnone sspstrong uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noinline noreturn nounwind }
attributes #6 = { noreturn nounwind }
attributes #7 = { nounwind }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{!"clang version 10.0.1 "}
!4 = !{!5}
!5 = !{i64 2, i64 3, i1 false}
