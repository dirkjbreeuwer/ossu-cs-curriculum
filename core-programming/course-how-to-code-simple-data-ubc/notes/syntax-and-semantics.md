# Intermezzo 1 - Syntax and semantics

## The scheme vocabulary & grammar

```
variables (var) = x | area-of-disk | perimeter | ... 
constants (con) = true | false | "a" | "b" | 1 | ... 
primitives (prm) = + | - | ... 
definitions (def) = (define ( (var) (var) ... (var)) (exp))
expressions (exp) = (var) |
                    (con) |
                    ((prm) (exp) ... (exp))
                    ((var) (exp) ... (exp))
                    (cond ((exp) (exp)) ... ((exp) (exp)))
                    (cond ((exp) (exp)) ... (else (exp)))
```

* variables (var): These are identifiers like x, area-of-disk, or perimeter that are used to name values or functions.
* constants (con): These are literal values like true, false, "a", "b", 1, etc.
* primitives (prm): These are built-in operators or functions like +, -, etc.
* definitions (def): These are constructs that define new variables or functions.
* expressions (exp): These are constructs that evaluate to values. They can be variables, constants, applications of primitive operators, applications of user-defined functions, conditional expressions, etc.

## Functions

In Racket, a function is typically defined using the define syntax, and it includes a header, body, and parameters.

* Header: This is the part of the function definition that specifies the function's name and parameters. It indicates how the function is called and what arguments it takes.
* Body: The body of a function consists of the expressions that are evaluated when the function is called. It contains the computational logic of the function and determines what the function will return.
* Parameter: Parameters are the variables listed in the function header that are used to pass values into the function. Each parameter corresponds to an argument that the function can accept when it is called.

 ```Lisp
(define ((function-name) (parameter) ... (parameter)) (body))

((function) (argument) ... (argument))

(cond ((question) (answer)) (cond-clause) ...)
```
