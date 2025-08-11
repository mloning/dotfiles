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

- Write unit tests using `pytest`.

### Documentation

- Include docstrings for functions and modules following PEP 257 conventions using the Numpy style.
  - Provide clear descriptions of function purpose, intput and output values.
- Add in-code comments on complex or non-obvious code to improve readability, otherwise do not comment.

### Key Conventions

- File Structure
  - Organize code into modules and packages logically.
  - Separate utility functions, core algorithms, and application code.
- Function Design
  - Keep functions small and focused on a single task.
  - Avoid global variables; pass parameters explicitly.
  - Avoid default input arguments.
  - Keep input and return types simple.
- Use dataclasses as lightweight, immutable data containers.
- File Structure
  - Organize code into modules and packages logically.
  - Separate utility functions, core algorithms, and application code.
- For file system paths, always use `pathlib` instead of `os.path`
- Always include type annotations.
- Only implement only one way to do something, don't allow for multiple options to achieve the same.

### Best Practices

- Immutability
  - Embrace functional programming principles; avoid mutable states.
  - Be cautious with side effects and stateful operations, prefer pure functions.
- Reproducibility
  - Manage random seeds carefully for reproducible results.
