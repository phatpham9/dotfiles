---
name: nest-backend-service-builder
description: 'Scaffold NestJS backend modules, controllers, services, DTOs, REST/GraphQL APIs, WebSocket handlers, validation pipes, guards, interceptors, and Jest integration tests'
---

# Purpose

Build production-ready NestJS backend services using clean architecture, domain-driven design principles, and enterprise patterns.

## When to Use

Use this skill when the task involves:

- Creating or modifying NestJS modules, controllers, or services
- Building REST endpoints or GraphQL resolvers
- Implementing WebSocket/Socket.IO real-time features
- Adding DTOs with class-validator validation
- Setting up guards, interceptors, or exception filters
- Writing integration tests for API endpoints

## Constraints

- Organize by **feature modules**, not file type (avoid `controllers/`, `services/` folders)
- Use **TypeScript strict mode**; define explicit return types
- Apply **class-validator** decorators on all DTOs
- Use **class-transformer** for serialization control
- Version APIs explicitly (`/v1/resource`)
- Follow RFC 7807 Problem Details for error responses
- Apply rate limiting on public endpoints
- Use Helmet for secure HTTP headers

## Execution Steps

1. **Define module boundary** — Identify domain entity and create feature module
2. **Create DTOs** — Define request/response DTOs with validation decorators
3. **Implement service** — Business logic with dependency injection
4. **Build controller** — REST endpoints with proper HTTP methods and status codes
5. **Add guards/interceptors** — Authentication, authorization, logging as needed
6. **Write tests** — Integration tests for endpoint contracts
7. **Document API** — Add Swagger decorators for OpenAPI spec

## Examples

### Input

> Create a user registration endpoint with email validation

### Output

```typescript
// @/modules/users/dto/create-user.dto.ts
import { IsEmail, IsString, MinLength } from 'class-validator';

export class CreateUserDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(8)
  password: string;

  @IsString()
  name: string;
}

// @/modules/users/users.controller.ts
@Controller('v1/users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  async register(@Body() dto: CreateUserDto): Promise<UserResponseDto> {
    return this.usersService.register(dto);
  }
}
```

## Related Skills

- `database-schema-designer` — Design underlying data models
- `jest-testing-generator` — Write service and controller tests
- `senior-code-review` — Review API security and patterns
