---
name: jest-testing-generator
description: 'Generate Jest unit tests, integration tests, React Testing Library component tests, mock implementations, test fixtures, and edge case coverage for TypeScript codebases'
---

# Purpose

Create comprehensive, maintainable Jest test suites for frontend and backend TypeScript code with proper mocking and edge case coverage.

## When to Use

Use this skill when the task involves:

- Writing new unit or integration tests
- Adding tests for uncovered code paths
- Creating test fixtures and mock implementations
- Migrating from other test frameworks to Jest
- Improving test coverage metrics

## Constraints

- Tests must be **deterministic** — no random values, fixed timestamps
- Mock external dependencies **at adapter boundaries**, not deep in business logic
- Use **React Testing Library** for component tests (query by role/label, not test IDs)
- Prefer **integration tests for API boundaries**, unit tests for pure business logic
- Follow **AAA pattern**: Arrange, Act, Assert
- Name tests descriptively: `should [expected behavior] when [condition]`

## Execution Steps

1. **Analyze target** — Identify function/component inputs, outputs, and side effects
2. **Define test cases** — List happy paths, error cases, and edge cases
3. **Create fixtures** — Build reusable test data factories
4. **Write mocks** — Mock external dependencies (APIs, databases, time)
5. **Implement tests** — Write tests following AAA pattern
6. **Verify coverage** — Check uncovered branches and add missing tests

## Examples

### Input

> Write tests for a UserService.register method that validates email and hashes password

### Output

```typescript
// @/modules/users/__tests__/users.service.spec.ts
import { Test } from '@nestjs/testing';
import { UsersService } from '../users.service';
import { UsersRepository } from '../users.repository';
import { ConflictException } from '@nestjs/common';

describe('UsersService', () => {
  let service: UsersService;
  let repository: jest.Mocked<UsersRepository>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: UsersRepository,
          useValue: {
            findByEmail: jest.fn(),
            create: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get(UsersService);
    repository = module.get(UsersRepository);
  });

  describe('register', () => {
    const validDto = {
      email: 'test@example.com',
      password: 'securePass123',
      name: 'Test',
    };

    it('should create user when email is unique', async () => {
      repository.findByEmail.mockResolvedValue(null);
      repository.create.mockResolvedValue({ id: '1', ...validDto });

      const result = await service.register(validDto);

      expect(result.email).toBe(validDto.email);
      expect(repository.create).toHaveBeenCalledWith(
        expect.objectContaining({ email: validDto.email }),
      );
    });

    it('should throw ConflictException when email exists', async () => {
      repository.findByEmail.mockResolvedValue({ id: '1', ...validDto });

      await expect(service.register(validDto)).rejects.toThrow(
        ConflictException,
      );
    });

    it('should hash password before storing', async () => {
      repository.findByEmail.mockResolvedValue(null);
      repository.create.mockResolvedValue({ id: '1', ...validDto });

      await service.register(validDto);

      expect(repository.create).toHaveBeenCalledWith(
        expect.objectContaining({
          password: expect.not.stringMatching(validDto.password),
        }),
      );
    });
  });
});
```

## Related Skills

- `nest-backend-service-builder` — Service implementation patterns
- `nextjs-react-engineering` — Component testing patterns
