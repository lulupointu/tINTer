["built_value_generator:built_value on lib/models/shared/serializers.dart",["Error in BuiltValueGenerator for /tinter_backend/lib/models/shared/serializers.dart.","Broken @SerializersFor annotation. Are all the types imported?","#0      SerializerSourceLibrary.serializeForClasses (package:built_value_generator/src/serializer_source_library.dart:93:9)\n#1      _$SerializerSourceLibrary.serializeForClasses (package:built_value_generator/src/serializer_source_library.g.dart:47:39)\n#2      SerializerSourceLibrary.serializeForTransitiveClasses (package:built_value_generator/src/serializer_source_library.dart:114:11)\n#3      _$SerializerSourceLibrary.serializeForTransitiveClasses (package:built_value_generator/src/serializer_source_library.g.dart:52:17)\n#4      SerializerSourceLibrary._generateSerializersTopLevelFields.<anonymous closure> (package:built_value_generator/src/serializer_source_library.dart:156:12)\n#5      MappedIterator.moveNext (dart:_internal/iterable.dart:395:18)\n#6      Iterable.join (dart:core/iterable.dart:364:19)\n#7      SerializerSourceLibrary._generateSerializersTopLevelFields (package:built_value_generator/src/serializer_source_library.dart:170:8)\n#8      SerializerSourceLibrary.generateCode (package:built_value_generator/src/serializer_source_library.dart:142:12)\n#9      BuiltValueGenerator.generate (package:built_value_generator/built_value_generator.dart:31:48)\n#10     _generate (package:source_gen/src/builder.dart:301:33)\n<asynchronous suspension>\n#11     _Builder._generateForLibrary (package:source_gen/src/builder.dart:79:15)\n#12     _Builder.build (package:source_gen/src/builder.dart:71:11)\n<asynchronous suspension>\n#13     runBuilder.buildForInput (package:build/src/generate/run_builder.dart:55:21)\n#14     MappedListIterable.elementAt (dart:_internal/iterable.dart:417:29)\n#15     ListIterator.moveNext (dart:_internal/iterable.dart:346:26)\n#16     Future.wait (dart:async/future.dart:393:26)\n#17     runBuilder.<anonymous closure> (package:build/src/generate/run_builder.dart:61:36)\n#18     _rootRun (dart:async/zone.dart:1126:13)\n#19     _CustomZone.run (dart:async/zone.dart:1023:19)\n#20     _runZoned (dart:async/zone.dart:1518:10)\n#21     runZoned (dart:async/zone.dart:1502:12)\n#22     scopeLogAsync (package:build/src/builder/logging.dart:26:3)\n#23     runBuilder (package:build/src/generate/run_builder.dart:61:9)\n#24     _SingleBuild._runForInput.<anonymous closure>.<anonymous closure>.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:486:19)\n#25     _NoOpBuilderActionTracker.trackStage (package:build_runner_core/src/generate/performance_tracker.dart:302:15)\n#26     _SingleBuild._runForInput.<anonymous closure>.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:484:23)\n<asynchronous suspension>\n#27     NoOpTimeTracker.track (package:timing/src/timing.dart:222:44)\n#28     _SingleBuild._runForInput.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:441:22)\n#29     Pool.withResource (package:pool/pool.dart:127:28)\n<asynchronous suspension>\n#30     _SingleBuild._runForInput (package:build_runner_core/src/generate/build_impl.dart:437:17)\n#31     _SingleBuild._runBuilder.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:375:38)\n#32     MappedIterator.moveNext (dart:_internal/iterable.dart:395:18)\n#33     Future.wait (dart:async/future.dart:393:26)\n#34     _SingleBuild._runBuilder (package:build_runner_core/src/generate/build_impl.dart:374:36)\n#35     _AsyncAwaitCompleter.start (dart:async-patch/async_patch.dart:45:6)\n#36     _SingleBuild._runBuilder (package:build_runner_core/src/generate/build_impl.dart:372:40)\n#37     _SingleBuild._runPhases.<anonymous closure>.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:320:20)\n#38     _asyncThenWrapperHelper.<anonymous closure> (dart:async-patch/async_patch.dart:73:64)\n#39     _rootRunUnary (dart:async/zone.dart:1134:38)\n#40     _CustomZone.runUnary (dart:async/zone.dart:1031:19)\n#41     _FutureListener.handleValue (dart:async/future_impl.dart:139:18)\n#42     Future._propagateToListeners.handleValueCallback (dart:async/future_impl.dart:680:45)\n#43     Future._propagateToListeners (dart:async/future_impl.dart:709:32)\n#44     Future._completeWithValue (dart:async/future_impl.dart:524:5)\n#45     _AsyncAwaitCompleter.complete (dart:async-patch/async_patch.dart:32:15)\n#46     _completeOnAsyncReturn (dart:async-patch/async_patch.dart:290:13)\n#47     _SingleBuild._matchingPrimaryInputs (package:build_runner_core/src/generate/build_impl.dart)\n#48     _asyncThenWrapperHelper.<anonymous closure> (dart:async-patch/async_patch.dart:73:64)\n#49     _rootRunUnary (dart:async/zone.dart:1134:38)\n#50     _CustomZone.runUnary (dart:async/zone.dart:1031:19)\n#51     _FutureListener.handleValue (dart:async/future_impl.dart:139:18)\n#52     Future._propagateToListeners.handleValueCallback (dart:async/future_impl.dart:680:45)\n#53     Future._propagateToListeners (dart:async/future_impl.dart:709:32)\n#54     Future._completeWithValue (dart:async/future_impl.dart:524:5)\n#55     Future.wait.<anonymous closure> (dart:async/future.dart:400:22)\n#56     _rootRunUnary (dart:async/zone.dart:1134:38)\n#57     _CustomZone.runUnary (dart:async/zone.dart:1031:19)\n#58     _FutureListener.handleValue (dart:async/future_impl.dart:139:18)\n#59     Future._propagateToListeners.handleValueCallback (dart:async/future_impl.dart:680:45)\n#60     Future._propagateToListeners (dart:async/future_impl.dart:709:32)\n#61     Future._completeWithValue (dart:async/future_impl.dart:524:5)\n#62     Future._asyncComplete.<anonymous closure> (dart:async/future_impl.dart:554:7)\n#63     _rootRun (dart:async/zone.dart:1126:13)\n#64     _CustomZone.run (dart:async/zone.dart:1023:19)\n#65     _CustomZone.runGuarded (dart:async/zone.dart:925:7)\n#66     _CustomZone.bindCallbackGuarded.<anonymous closure> (dart:async/zone.dart:965:23)\n#67     _microtaskLoop (dart:async/schedule_microtask.dart:43:21)\n#68     _startMicrotaskLoop (dart:async/schedule_microtask.dart:52:5)\n#69     _runPendingImmediateCallback (dart:isolate-patch/isolate_patch.dart:118:13)\n#70     _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:175:5)\n"]]