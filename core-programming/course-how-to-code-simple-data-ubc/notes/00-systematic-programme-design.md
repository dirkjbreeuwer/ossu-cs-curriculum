# Systematic Program Design

Systematic program design is a methodical approach that requires careful thought, planning, and understanding at each step of the software development process. The approach is broken down into several key steps, each with a specific goal and a set of activities to achieve that goal.

## Design Steps and Activities

| Step                  | Goal                                                                  | Activity                                                                                     |
|-----------------------|-----------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| **Contract, Purpose,<br>and Header**  | Define the function name, its input and output types, its purpose, and the initial function header. | - Choose a function **name** appropriate for the problem.<br>- Analyze the problem to determine the "givens" and how they should be represented as inputs.<br>- Use descriptive names that match the problem's terminology.<br>- Outline what the function should compute with the chosen variable names.<br>- Establish the contract and header according to the Scheme syntax:<br>  `;; name : number ... -> number`<br>  `;; to compute ... from x1 ...`<br>  `(define (name x1 ...) ...)` |
| **Examples**          | Characterize the function's behavior through input-output examples.   | - Identify examples in the problem statement.<br>- Work through these examples to understand the function's behavior.<br>- Validate the outcomes of the examples if possible.<br>- Create additional examples to cover different scenarios.                             |
| **Body**              | Develop the actual function definition.                               | - Determine how the function will compute its results.<br>- Use Scheme’s primitive operations, other functions, and variables to form the function body.<br>- Translate any mathematical expressions from the problem statement into code.                          |
| **Test**              | Identify and correct any errors in the function.                      | - Apply the function to the example inputs.<br>- Verify that the function's outputs match the expected results.<br>- Use these tests as a way to check the function's correctness.                                              |

Following this structured approach ensures that each function is well-defined, purpose-driven, and thoroughly tested, leading to robust and maintainable software.

---
