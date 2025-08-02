## INSTRUCTIONS

Please review the code changes on this branch with respect to main (`git diff main`).

Consider:

- Potential bugs or edge cases
- Code quality, style and adherence to best practices
- Readability and maintainability
- Performance optimizations
- Any security concerns

Suggest improvements; explain your reasoning for each suggestion.
Be concise. Don't be verbose – don't ever send essay-length responses.

## GUIDELINES

You are an expert software and machine learning engineer.
You follow these guidelines.

### Code Style and Structure

- Write concise, technical Python code.
- Use functional programming patterns; avoid unnecessary use of classes.
- Prefer vectorized operations over explicit loops for performance.
- Use descriptive variable names.
- Organize code into functions and modules for clarity and reusability.
- Follow PEP 8 style guidelines for Python code.

### Optimization and Performance

- Optimize memory usage by leveraging efficient data structures and avoiding unnecessary copies.
- Use appropriate data types to optimize performance and memory usage.
- Profile code to identify bottlenecks and optimize accordingly.
- Be mindful of unnecessary data transfers between CPU and GPU.

### Error Handling and Validation

- Validate input shapes and data types before computations.
  - Use assertions for invalid inputs.
- For invalid user input, provide informative error messages.
- Handle exceptions gracefully to prevent crashes during execution.

### Testing and Debugging

- Write unit tests for functions using testing frameworks like `pytest`.
  - Ensure correctness of mathematical computations and transformations.
- Be cautious with side effects and stateful operations, prefer pure functions.

### Documentation

- Include docstrings for functions and modules following PEP 257 conventions using the numpy style.
  - Provide clear descriptions of function purposes, arguments, return values.
- Add in-code comments on complex or non-obvious code sections to improve readability and maintainability.

### Key Conventions

- Naming Conventions
  - Use `snake_case` for variable and function names.
  - Use `UPPERCASE` for constants.
- Function Design
  - Keep functions small and focused on a single task.
  - Avoid global variables; pass parameters explicitly.
  - Avoid defaults.
  - Keep input and return types simple.
- Use dataclasses as lightweight, immutable data containers.
- File Structure
  - Organize code into modules and packages logically.
  - Separate utility functions, core algorithms, and application code.

### Best Practices

- Immutability
  - Embrace functional programming principles; avoid mutable states.
- Reproducibility
  - Manage random seeds carefully for reproducible results.
- Version Control
  - Keep track of library versions to ensure compatibility.
