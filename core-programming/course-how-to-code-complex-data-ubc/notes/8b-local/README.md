# Local expressions

Local expressions allow you to define variables or functions within a specific, constrained scope inside a larger expression. This feature helps in managing complexity by limiting the visibility of these definitions to just the part of the program where they are needed.

## Motivation

* Encapsulation: They help in encapsulating details within a function, making the outer function cleaner and more focused on its primary task.
* Avoiding Naming Conflicts: By defining variables or functions locally, you reduce the risk of naming conflicts with definitions elsewhere in your program.
* Improving Readability: Local expressions keep related code together, which can make the program easier to understand and maintain.
* Supporting Recursive Definitions: They are particularly useful for defining helper functions that are recursive or are only relevant within the context of a larger function.


## How to use them

```Lisp
(local [definitions]
  expression)
```

* [definitions]: This is a list where you define one or more variables or functions. Each definition can be either a variable initialization (using define) or a function definition.
* expression: This is the body of the local expression where the defined variables and functions can be used. It represents the scope in which the local definitions are valid. After this block, the local variables and functions are no longer accessible.


Example:

```Lisp
(define (calculate-area radius)
  (local [(define pi 3.14159)
          (define square (lambda (x) (* x x)))]
    (* pi (square radius))))
```

## Lexical scoping

Lexical scoping, also known as static scoping, is a method for resolving variable names in programming languages. Under lexical scoping, the scope of a variable is determined by its physical location in the written code, and nested within the blocks of code in which it is defined. This means that a function's ability to access a variable is determined by the actual structure of the program text, and not by the program's call stack or the sequence of function calls.

### Key Characteristics of Lexical Scoping:

* Definition Context: Variables are visible in the block where they are defined and in any blocks nested within that block, but not outside.
* Closure Behavior: In languages that support closures, functions defined in a lexical scope remember the environment in which they were created. This means a function can access variables from its outer scope even when it is executed outside of that scope.
* Predictability: Because the scope of variables is determined by the code's layout, it is easier to predict and understand variable lifetimes and visibility without knowing the details of the program's execution.

Example

```Lisp
(define (outer-function x)
  (define inner-function (lambda (y) (+ x y)))
  inner-function)

(define add-five (outer-function 5))
(add-five 3) ; This returns 8
```

* outer-function defines inner-function.
* inner-function has access to the variable x defined in outer-function due to lexical scoping. Even though inner-function is called outside of its defining scope (via add-five), it still remembers x's value as 5.
* This demonstrates how closures work under lexical scoping, maintaining access to their lexical environment.

### How local gets evaluated

When we get to evaluate the local expression, three things happen in one step: (1) Renaming the local definition(s) and all its references to a new name (2) Lifting the definitions to the top level scope (3) Replacing the local expression with the body, in which renaming has happened

# Encapsulation

Encapsulation in functional programming languages involves defining a set of functions within a given scope (such as a module or a local environment) that operate on specific data but do not expose the data directly. Data can be encapsulated within functions to hide its details from the outside world and to ensure that data manipulation is controlled and deliberate.

## Motivation for encapsulation

1. Maintainability: Encapsulating operations on data within specific functions or modules helps in maintaining and modifying code with fewer side effects, as the data is not openly modifiable throughout the program.
2. Safety: By restricting direct access to data and exposing only necessary functions to manipulate it, programs become safer and more reliable. This prevents misuse of data and accidental modifications that can lead to bugs.
3. Abstraction: Encapsulation allows programmers to think at a higher level of abstraction. Instead of worrying about the specific details of data manipulation, a programmer can focus on what operations are available and how they can be composed to achieve desired outcomes.
4. Namespace Management: By encapsulating functionality within specific modules or files, you can manage namespaces more effectively, avoiding conflicts and improving code organization.

## Example 

```Lisp
(define (create-counter)
  (let ([count 0])
    (lambda ()
      (set! count (add1 count))
      count)))

(define my-counter (create-counter))

(my-counter) ; => 1
(my-counter) ; => 2
```

