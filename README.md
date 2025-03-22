# Homework 3: Tiny Calculator parsing with YACC/Bison

This project implements a simple calculator using **Yacc** and **Flex**. It allows users to perform basic arithmetic operations, such as addition, subtraction, multiplication, division, and exponentiation, as well as variable assignment.

## Features
- Evaluate arithmetic expressions like `2 + 3`, `5 * 6`, etc.
- Support for variable assignment (e.g., `x = 10`).
- Basic error handling for invalid input or division by zero.
- Supports commands like `register`, `update_grade`, and `drop` for student management system use.

## Part 1: BNF Grammar

## Part 2: Implementation

### Requirements
- **Flex** (Lexical analyzer generator)
- **Bison** (Yacc parser generator)
- **GCC** or **cc** (C Compiler)

### Installation

Install **Flex** and **Bison**:
   - On Linux/Unix: `sudo apt-get install flex bison`
   - On macOS: `brew install flex bison

Compile and run the program using:
```
flex tinyCalc_parse.l
bison -d tinyCalc_parse.y
cc lex.yy.c tinyCalc_parse.tab.c -lm -o tinyCalc_parse
./tinyCalc_parse
```
## Part 3: Why Bison

Using Flex alone (without Bison) significantly limits the capabilities of the calculator, making several tasks difficult or impossible to implement cleanly. Below are the key limitations:

### 1. Handling Operator Precedence and Associativity

Issue: Flex processes tokens sequentially and does not understand the precedence of operators (e.g., * should be evaluated before +).

Bison Solution: The Bison parser defines operator precedence (%left, %right, etc.), ensuring correct evaluation order.

Flex Workaround: Would require manually managing a stack for operands and operators, which is cumbersome and error-prone.

### 2. Parsing Parentheses () for Grouping

Issue: Flex does not support recursive structures like nested parentheses.

Bison Solution: Bison handles nested expressions naturally using recursive grammar rules.

Flex Workaround: Would require maintaining a manual stack to track open and close parentheses.

### 3. Supporting Variables and Assignments

Issue: Flex can identify variable names but cannot associate them with stored values or track their assignments effectively.

Bison Solution: Bison allows defining rules for <VAR> = <expr> and stores values in a symbol table.

Flex Workaround: Requires manually implementing a dictionary-like structure in Flex, making it more complex.

### 4. Handling Multi-Character Tokens More Efficiently

Issue: Flex processes input character by character, making it hard to recognize multi-character tokens like variable names.

Bison Solution: Bison groups sequences of tokens into meaningful structures (VAR, NUM, expr).

Flex Workaround: Requires manually checking and concatenating characters to form variable names, increasing complexity.

### 5. Providing Detailed and Meaningful Error Messages

Issue: Error handling in Flex is limited; it detects invalid tokens but struggles with deeper syntax errors.

Bison Solution: Bison has built-in error recovery (error token), allowing structured error messages and handling.

Flex Workaround: Error messages must be manually implemented, often leading to vague or incorrect messages.

### 6. Supporting Unary Operators (+5, -3)

Issue: Differentiating between binary (5 - 3) and unary (-3) operators is challenging in Flex.

Bison Solution: Bison allows defining %prec UMINUS to handle unary operators separately.

Flex Workaround: Requires checking operator position manually, which is inefficient.

### 7. Evaluating Expressions in a Single Pass

Issue: Flex lacks a structured way to evaluate expressions as a whole; it can only handle one token at a time.

Bison Solution: Bison processes expressions using a structured AST (Abstract Syntax Tree) approach.

Flex Workaround: Requires manually implementing a stack-based evaluation strategy, which is complex.

### 8. Processing Multi-Line Expressions

Issue: If an expression spans multiple lines (e.g., 3 + \n 5), Flex has difficulty recognizing it as a single expression.

Bison Solution: Bison naturally handles expressions across multiple lines.

Flex Workaround: Requires tracking state across lines manually.

### Conclusion: Why Flex + Bison Is Better

Flex is ideal for tokenizing input (breaking it into meaningful parts like numbers, variables, and operators).

Bison is needed for parsing and evaluating expressions, ensuring correct operator precedence, syntax handling, and structured evaluation.

Without Bison, implementing a robust calculator with correct precedence, parentheses, variables, and structured error handling would be extremely difficult and require manually implementing complex logic.
