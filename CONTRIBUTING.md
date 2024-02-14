# Contributing

First off, thanks for taking the time to contribute! ❤️

All types of contributions are encouraged and valued.
See the [Table of Contents](#table-of-contents) for different ways to help and details about how we handle them.
Please make sure to read the relevant section before making your contribution.
It will make it a lot easier for us maintainers and smooth out the experience for all involved.
Iconica looks forward to your contributions. 🎉

## Table of contents

- [Code of conduct](#code-of-conduct)
- [I Have a Question](#i-have-a-question)
- [I Want To Contribute](#i-want-to-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Contributing code](#contributing-code)

## Code of conduct

### Legal notice

When contributing to this project, you must agree that you have authored 100% of the content, that you have the necessary rights to the content and that the content you contribute may be provided under the project license.
All accepted pull requests and other additions to this project will be considered intellectual property of Iconica.

All repositories should be kept clean of jokes, easter eggs and other unnecessary additions.

## I have a question

If you want to ask a question, we assume that you have read the available documentation found within the code.
Before you ask a question, it is best to search for existing issues that might help you.
In case you have found a suitable issue but still need clarification, you can ask your question
It is also advisable to search the internet for answers first.

If you then still feel the need to ask a question and need clarification, we recommend the following:

- Open an issue.
- Provide as much context as you can about what you're running into.

We will then take care of the issue as soon as possible.

## I want to contribute

### Reporting bugs

<!-- omit in toc -->

**Before submitting a bug report**

A good bug report shouldn't leave others needing to chase you up for more information.
Therefore, we ask you to investigate carefully, collect information and describe the issue in detail in your report.
Please complete the following steps in advance to help us fix any potential bug as fast as possible.

- Make sure that you are using the latest version.
- Determine if your bug is really a bug and not an error on your side e.g. using incompatible environment components/versions (If you are looking for support, you might want to check [this section](#i-have-a-question)).
- To see if other users have experienced (and potentially already solved) the same issue you are having, check if there is not already a bug report existing for your bug or error.
- Also make sure to search the internet (including Stack Overflow) to see if users outside of Iconica have discussed the issue.
- Collect information about the bug:
- Stack trace (Traceback)
- OS, Platform and Version (Windows, Linux, macOS, x86, ARM)
- Version of the interpreter, compiler, SDK, runtime environment, package manager, depending on what seems relevant.
- Time and date of occurance
- Describe the expected result and actual result
- Can you reliably reproduce the issue? And can you also reproduce it with older versions? Describe all steps that lead to the bug.

Once it's filed:

- The project team will label the issue accordingly.
- A team member will try to reproduce the issue with your provided steps.
  If there are no reproduction steps or no obvious way to reproduce the issue, the team will ask you for additional information.
- If the team is able to reproduce the issue, it will be moved into the backlog, as well as marked with a priority, and the issue will be left to be [implemented by someone](#contributing-code).

### Contributing code

When you start working on your contribution, make sure you are aware of the relevant documentation and the functionality of the component you are working on.

When writing code, follow the style guidelines set by Dart: [Effective Dart](https://Dart.dev/guides/language/effective-Dart). This contains most information you will need to write clean Dart code that is well documented.

**Documentation**

As Effective Dart indicates, documenting your public methods with Dart doc comments is recommended.
Aside from Effective Dart, we require specific information in the documentation of a method:

At the very least, your documentation should first name what the code does, then followed below by requirements for calling the method, the result of the method.
Any references to internal variables or other methods should be done through [var] to indicate a reference.

If the method or class is complex enough (determined by the reviewers) an example is required.
If unsure, add an example in the docs using code blocks.

For classes and methods, document the individual parameters with their implications.

> Tip: Remember that the shortest documentation can be written by having good descriptive names in the first place.

An example:

````Dart
library iconica_utilities.bidirectional_sorter;

part 'sorter.Dart';
part 'enum.Dart';

/// Generic sort method, allow sorting of list with primitives or complex types.
/// Uses [SortDirection] to determine the direction, either Ascending or Descending,
/// Gets called on [List] toSort of type [T] which cannot be shorter than 2.
/// Optionally for complex types a [Comparable] [Function] can be given to compare complex types.
/// ```
/// List<TestObject> objects = [];
///   for (int i = 0; i < 10; i++) {
///     objects.add(TestObject(name: "name", id: i));
///   }
///
/// sort<TestObject>(
///   SortDirection.descending, objects, (object) => object.id);
///
/// ```
/// In the above example a list of TestObjects is created, and then sorted in descending order.
/// If the implementation of TestObject is as following:
/// ```
/// class TestObject {
///  final String name;
///  final int id;
///
///  TestObject({required this.name, required this.id});
/// }
/// ```
/// And the list is logged to the console, the following will appear:
/// ```
/// [name9, name8, name7, name6, name5, name4, name3, name2, name1, name0]
/// ```

void sort<T>(
  /// Determines the sorting direction, can be either Ascending or Descending
  SortDirection sortDirection,

  /// Incoming list, which gets sorted
  List<T> toSort, [

  /// Optional comparable, which is only necessary for complex types
  SortFieldGetter<T>? sortValueCallback,
]) {
  if (toSort.length < 2) return;
  assert(
      toSort.whereType<Comparable>().isNotEmpty || sortValueCallback != null);
  BidirectionalSorter<T>(
    sortInstructions: <SortInstruction<T>>[
      SortInstruction(
          sortValueCallback ?? (t) => t as Comparable, sortDirection),
    ],
  ).sort(toSort);
}

/// same functionality as [sort] but with the added functionality
/// of sorting multiple values
void sortMulti<T>(
  /// Incoming list, which gets sorted
  List<T> toSort,

  /// list of comparables to sort multiple values at once,
  /// priority based on index
  List<SortInstruction<T>> sortValueCallbacks,
) {
  if (toSort.length < 2) return;
  assert(sortValueCallbacks.isNotEmpty);
  BidirectionalSorter<T>(
    sortInstructions: sortValueCallbacks,
  ).sort(toSort);
}

````

**Tests**

For each public method that was created, excluding widgets, which contains any form of logic (e.g. Calculations, predicates or major side-effects) tests are required.

A set of tests is written for each method, covering at least each path within the method. For example:

```Dart
void foo() {
    try {
        var bar = doSomething();
        if (bar) {
            doSomethingElse();
        } else {
            doSomethingCool();
        }
    } catch (_) {
        displayError();
    }
}
```

The method above should result in 3 tests:

1. A test for the path leading to displayError by the cause of an exception
2. A test for if bar is true, resulting in doSomethingElse()
3. A test for if bar is false, resulting in the doSomethingCool() method being called.

This means that we require 100% coverage of each method you test.
