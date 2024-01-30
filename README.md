A simple demo project to show that Delphi's `SetRoundMode` is not thread-safe.

Output:

````
Delphi non-thread-safe SetRoundMode:

MainThread init                def: 1332   current: 1372  RM: 0
MainThread after rmDown        def: 1772   current: 1772  RM: 1
Thread 00:59:59.999            def: 1772   current: 1772  RM: 1
MainThread after rmNearest     def: 1372   current: 1372  RM: 0
Thread 01:00:00.000            def: 1372   current: 1372  RM: 0

Custom thread-safe SetRoundMode:

MainThread init                def: 1372   current: 1372  RM: 0
MainThread after rmDown        def: 1372   current: 1772  RM: 1
Thread 01:00:00.000            def: 1372   current: 1372  RM: 0
MainThread after rmNearest     def: 1372   current: 1372  RM: 0
Thread 01:00:00.000            def: 1372   current: 1372  RM: 0
````
