## 0.3.6
New widget ObserverN that accepts List os Reactive variables 

## 0.3.5
implement un-implemented methods in ReactiveSet

## 0.3.4
1. new method added initStateWithContext(BuildContext context)

## 0.3.3
1. Now bind controller needs to be through Function(). e.g, BindController(controller: () => MyCounterController())

## 0.3.2
1. Now bind controller needs to be through Function(). e.g, BindController(controller: () => MyCounterController())

## 0.3.1
1. added listeners getter
2. added option for remove all listeners

## 0.3.0
1. Introduced BindController Class to bind the controllers with the screen smart and seamlessly

## 0.2.6
5. Added support for [dot]reactiv for bool and num types 
6. Update readme.md

## 0.2.5
Update readme.md

## 0.2.4
1. ReactiveBool, ReactiveNum, ReactiveMap, ReactiveSet

## 0.2.3
1. addListener method for Reactive variables
2. Update ReadMe

## 0.2.2
1. new method in Reactive types, bindStream to deal with streams
2. ReactiveStateWidget and ReactiveState

## 0.2.1
1. update readme

## 0.2.0
1. Breaking Change: params change
   1. listen => listenable
   2. update => listener

## 0.1.3
1. Stream change to broadcast stream,
2. params change
   1. listen => listenable
   2. update => listener
3. ReactiveWidget major update :
   1. auto dispose the controller functionality
   2. bindDependency method to Dependency.put() the dependency
   3. life-cycle methods void initState(), void dispose(), methods added in ReactiveWidget

## 0.1.2
1. [dot]reactiv extension added
2. ReactiveList all the methods added for add new element and remove element from the list

## 0.1.1
update documentation

## 0.1.0
update documentation

## 0.0.3
update example and readme

## 0.0.2
Name change
1. Reaction => Observer
2. cause => listen
3. effect => update
4. import file optimisations

## 0.0.1
Initial release.
A new Reactive state management approach and dependency injection  inspired by GetX
