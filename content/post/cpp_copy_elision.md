---
title: "(Guaranteed) Copy elision in C++11/14/17"
summary: "Using modern CMake to test private C/C++ implementation files without exposing them to the library user."
draft: true
date: "2021-02-05T00:00:00Z"
authors:
  - philippjung
tags:
  - C++
  - C++20
  - Copy-Elision
  - RVO
  - NRVO
---
Regardless of what you think of Herb Sutter's [Almost Always Auto (AAA)](https://herbsutter.com/2013/08/12/gotw-94-solution-aaa-style-almost-always-auto/) style, there are situations where using auto helps to not repeat oneself.
For example, when using `std::make_unique<>`[^1] and `std::make_shared<>`.
```cpp
auto some_ptr = std::make_unique<SomeClass>();
```
But wait, isn't there a copy happening here, or at least a move?
According to the C++11 standard: Compilers are allowed to elide such copy and moves.
Meaning, it can construct the object on the right directly in the stack space of the left operant.
In our example, `std::unique_ptr<SomeClass>` could be directly constructed at the memory location of `some_ptr`.
However, prior to C++14 compilers are not required to do so, i.e., the expression on the right must be copy or moveable, even thought the copy and move assignment operators may never be called.

Consider the follow piece of code:
```cpp
#include <iostream>
#include <memory>

struct S {
    S() {std::cout << "Default construct S" << std::endl;}
    S(S const& other) {std::cout<< "Copy construct S" << std::endl;}
    S(S &&) {std::cout << "Move construct S" << std::endl;}
    S& operator=(S const& other) {std::cout <<" Assign S" << std::endl; return *this;}
    S& operator=(S &&) {std::cout <<"Move assign S" << std::endl; return *this;}
};

int main(){
    auto s = S{};
}
```
Even with `-std=c++11` only `"Default construct S"` is printed. Since copy elision is not guarenteed prior to C++17 deleting the move constructor in line 7 will result in a compilation error when using C++11/14.
```cpp
S(S&&) = delete;
```
Even though the move constructor is not actually called as we have seen in the previous example

[^1]: from C++14 upwards