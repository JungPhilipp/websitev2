---
title: "(Guaranteed) Copy Elision in C++11/14/17"
summary: "Why `auto foo = Foo()` does neither copy nor move a `Foo` object. C++17's mandatory copy elision omits copies and moves when initializing from temporaries, returning temporaries or throwing/catching by value."
draft: false
date: "2021-02-05T00:00:00Z"
authors:
  - admin
tags:
  - C++
  - C++11
  - C++14
  - C++17
  - Copy Elision
---
Compilers have become incredible optimization machines, which use loop unrolling, heap elision, devirtualization and other techniques to turn (regular) code into highly efficient machine instructions.
One if these optimization techniques elides copies and moves by constructing an object directly into the target of the omitted cope/move operation.
This technique is called copy/move elision and is now guaranteed by the C++17 standard to occur in certain situations.

An example of (guaranteed) copy elision occurs when initializing from a temporary.
```cpp
#include <iostream>
struct Foo {
    Foo() {std::cout << "Default Constructor" << std::endl;}
    Foo(Foo const& other) {std::cout<< "Copy Constructor" << std::endl;}
    Foo(Foo &&) {std::cout << "Move Constructor" << std::endl;}
    Foo& operator=(Foo const& other) {std::cout <<" Assignment" << std::endl; return *this;}
    Foo& operator=(Foo &&) {std::cout <<"Move Assignment" << std::endl; return *this;}
    ~Foo() {std::cout << "Destructor" << std::endl;}
};
```
```cpp
  auto foo = Foo();
```
Regardless of the C++ version, compiling and running this with a modern compiler will print:
```
  """
  Default Constructor
  Destructor
  """
```
Even in earlier versions of C++, compilers were allowed to elide copies in this situation.
This is true regardless of potential side-effects of the copy/move constructor.
However, when using C++11/14 `Foo` has to be move-constructable even though the move constructor is not actually called.
Deleting the move constructor `Foo (Foo &&) = delete` results in a compile error when using C++11/14. This is because the program has to be well-formed even when copy elision is not performed, thus requiring the move constructor.
The C++17 standard guarantees copy elision in this case.

The above case is an example of copy elision during initializing from a temporary.
There are three distinct cases where copy elision can occur:
  1. Initializing from a temporary
  2. **R**eturn **V**alue **O**ptimization (RVO) including **N**amed Return Value Optimization (NRVO)
  3. Throwing/catching exceptions by value

I will cover the latter two in future blog posts.
As you might infer from the above results, it is hard to pass non-movable types around without guaranteed copy elision.

### How guaranteed copy elision works[^1]
To understand how guaranteed copy elision is achieved in C++17, we need to take a look at C++ value categories (which confusingly enough categorize expressions, not values).
There are excellent [cpp-reference](https://en.cppreference.com/) sites[^2] and blog posts[^3] explaining value categories and their references. I highly recommend checking them out.

For the purpose of this post it suffices to take a look at ***prvalues*** (pure rvalues) and ***glvalues*** (generalized lvalues).
The proposal for guaranteed copy elision rewords the definition of these two value catagories. Roughly speaking:

* A *glvalue* is an expression whose evaluation computes the location of an object,
* A *prvalue* is an expression whose evaluation initializes an object

In other words, a *glvalue* specifies the object location while a *prvalue* is its initializer.
For all the details take a look at the original proposal[^1].
With these definitions in mind, let us revisit the example from the beginning:
```cpp
auto foo = Foo();
```
here `foo` is an *glvalue* and `Foo()` a *prvalue*. This means, that `Foo()` can directly initialize `foo` without a reachable for copy-/move- constructor.

With the above definitions *gl-* and *pr*-values copy elision occurs naturally and no special rules are required.


[^1]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/p0135r0.html
[^2]: https://en.cppreference.com/w/cpp/language/value_category
[^3]: https://www.fluentcpp.com/2018/02/06/understanding-lvalues-rvalues-and-their-references/ https://medium.com/@barryrevzin/value-categories-in-c-17-f56ae54bccbe

