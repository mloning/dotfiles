---
name: write-tests
description: Write tests using red-green-refactor — test behavior through public interfaces, not implementation details. Use when writing tests for new or existing code, or driving a new implementation test-first.
disable-model-invocation: true
---

# Write Tests

Tests verify behavior, not implementation. A test that breaks on refactoring without changing behavior is a bad test.

**NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST** when driving new code test-first.

1. **Identify behaviors to test.** List the distinct behaviors (not code paths) the unit should exhibit. Each behavior = one test. If a test description starts with "and", split it into two tests.
2. **Write the test first (for new code).** Write the test against the wished-for public API before writing the implementation. If the test is hard to write, the design is too complicated.
3. **Arrange / Act / Assert.** Each test: set up state (Arrange), invoke the unit under test once (Act), verify the outcome (Assert). One logical assertion per test. No logic (loops, conditionals) inside tests.
4. **Test through public interfaces only.** Never reach into private methods or internal state. If you can't test behavior through the public interface, the interface is wrong — fix the design, not the test.
5. **Verify RED first.** Run the test before writing any implementation — it must fail for the right reason (behavior doesn't exist yet, not a syntax error or import failure).
6. **Write minimal code to go GREEN.** Make the test pass with the least code possible. Resist the urge to generalize.
7. **Refactor only while GREEN.** Clean up duplication, improve names, extract abstractions — but only with all tests passing. Never refactor on red.
8. **Mock only at system boundaries.** Mock external I/O (network, filesystem, databases, time), never internal code. If you need to mock an internal dependency, that's a coupling problem — fix the design.
9. **Name tests as behavior descriptions.** `test_returns_empty_list_when_no_items` not `test_get_items`. The test name is the spec.
