---
title: "(Guaranteed) Copy Elision in C++11/14/17"
summary: "Why `auto foo = Foo()` does neither copy nor move construct. C++17's mandatory copy elision simplifies value categories to omit copy and moves when initializing from temporaries, returning temporaries from functions and throwing/catching by value."
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
Copy elision is a common compiler technique to omit certain copy and move (C++11) operations by constructing an object directly into the target of the omitted operation.
A typical situation where copy elision is used is during the initialization of a variable from a temporary:
```cpp
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
Prior to C++17 `Foo` needed to be move-constructable even though the move constructor may not be called.
Deleting the move constructor `Foo (Foo &&) = delete` results in a compile error when using C++11/14. This is because the program needs to be well-formed when copy elision is not performed, thus requiring the move constructor.
The C++17 standard guarantees copy elision in the above case.

The above case is an example of copy elision when initializing an object from a temporary. In this case passing `Foo()` to the move-constructor of `Foo`.
There are three cases in total where copy elision can happen:
  1. Initializing from a temporary
  2. **R**eturn **V**alue **O**ptimization (RVO) including **N**amed Return Value Optimization (NRVO)
  3. Throwing/catching exceptions by value

I will cover the latter two in future blog posts.
As you might see from the above results without guaranteed copy elision, it is hard to pass non-moveable types around.

### How guaranteed copy elision works[^1]
To understand how guaranteed copy elision is achieved in C++17, we need to take a look at C++ value categories (which confusingly enough categorize expressions, not values).
There are excellent [cpp-reference](https://en.cppreference.com/) sites[^2] and blog posts[^3] explaining value categories and their references. I highly recommend checking them out.

For this purpose it suffices to take a look at ***prvalues*** (pure rvalues) and ***glvalues*** (generalized lvalues).
Roughly speaking:

* *glvalue* is an expression whose evaluation computes the location of an object
* *prvalue* is an expression whose evaluation initializes an object

In other words, a *glvalue* specifies the object location while a *prvalue* is its initializer.
For all the details take a look at the original proposal[^1].

Let's revisit our example from the beginning:
```cpp
auto foo = Foo();
```
where `foo` is an *glvalue* and `Foo()` a *prvalue*. This means, that `Foo()` directly initializes `foo` without the need for copy-/move- constructors.


[^1]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/p0135r0.html
[^2]: https://en.cppreference.com/w/cpp/language/value_category
[^3]: https://www.fluentcpp.com/2018/02/06/understanding-lvalues-rvalues-and-their-references/ https://medium.com/@barryrevzin/value-categories-in-c-17-f56ae54bccbe

