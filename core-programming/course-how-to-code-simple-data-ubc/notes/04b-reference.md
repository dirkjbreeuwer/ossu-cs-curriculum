# Reference 

## Types of Data

- **Primitive (Atomic) Data:** Simple, indivisible types like numbers, strings, and booleans.
- **Compound Data:** Data structures that combine multiple values, potentially of varied types, into a single unit.

## Reference

Reference occurs when a data definition includes or refers to another data definition. This pattern is crucial for creating complex, interconnected data structures like nested records, trees, and graphs. For reference to be effectively used, it must integrate seamlessly with the data definitions it connects.

## Example of Compound Data with Reference

```scheme
(define-struct ball (x y))
;; Ball is (make-ball Number Number)
;; interp. a ball at position x, y
```

```scheme
(define-struct game (ball score))
;; Game is (make-game Ball Number)
;; interp. the current ball and score of the game
```

### Template for Compound Data with Reference

Creating a function that operates on a `game`, which includes a `ball`, demonstrates how to apply the reference rule:

```scheme
(define (fn-for-game g)
  (... (fn-for-ball (game-ball g))  ; Reference to Ball
       (game-score g)))             ; Number
```

- **Reference to Ball:** The use of `(fn-for-ball (game-ball g))` demonstrates applying the reference rule by incorporating the template function for the `ball` data definition.
- **Score as Primitive Data:** Directly uses `game-score`, showing how primitive data types within compound data are handled.

### Function Table for Reference

| Function      | Description |
|---------------|-------------|
| `fn-for-ball` | Template function for operating on `Ball` data, applied when accessing a `ball` within another data structure. |

## Concepts and Definitions

- **Reference:** Inclusion of one data definition within another, creating a relationship between the two.
- **Compound Data:** Data structures defined using `define-struct` that can include both primitive types and references to other compound data types.

  ```scheme
  (define-struct game (ball score))
  ```

- **Constructor, Selectors, and Predicate for Compound Data:**
  - **Constructor:** `make-game`, creates a new `game` instance.
  - **Selectors:** `game-ball`, `game-score`, access the components of a `game`.
  - **Predicate:** `game?`, checks if an object is a `game` instance.
