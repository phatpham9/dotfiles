---
name: template-scaffold
description: 'Generate boilerplate templates and scaffolding for Next.js pages, NestJS modules, React components, API routes, Jest test files, Prisma models, and common project patterns'
---

# Purpose

Provide consistent, production-ready boilerplate templates following project conventions and best practices to accelerate feature development.

## When to Use

Use this skill when the task involves:

- Creating new feature modules or components
- Scaffolding API routes or pages
- Setting up test file structures
- Generating Prisma/database model boilerplate
- Starting new projects with predefined structure

## Constraints

- Templates must follow **TypeScript strict mode**
- Use **path aliases** (`@/`) in all imports
- Include **proper typing** — no implicit any
- Add **placeholder comments** for customization points
- Follow **Atomic Design** for UI components
- Include **basic error handling** patterns

## Available Templates

### Next.js

- `page` — App Router page with metadata
- `layout` — Layout component with providers
- `api-route` — Route handler with validation
- `server-action` — Server action with error handling

### NestJS

- `module` — Feature module with service, controller, DTOs
- `controller` — REST controller with CRUD endpoints
- `service` — Service with repository injection
- `dto` — DTO with validation decorators

### React

- `component` — Typed functional component with props interface
- `hook` — Custom hook with proper cleanup
- `context` — Context provider with typed value

### Testing

- `unit-test` — Jest unit test with mocks
- `e2e-test` — Integration test setup

## Examples

### Input

> Scaffold a new NestJS feature module for "products"

### Output

```typescript
// src/modules/products/products.module.ts
import { Module } from '@nestjs/common';
import { ProductsController } from './products.controller';
import { ProductsService } from './products.service';
import { ProductsRepository } from './products.repository';

@Module({
  controllers: [ProductsController],
  providers: [ProductsService, ProductsRepository],
  exports: [ProductsService],
})
export class ProductsModule {}

// src/modules/products/products.controller.ts
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
} from '@nestjs/common';
import { ProductsService } from './products.service';
import { CreateProductDto, UpdateProductDto, ProductResponseDto } from './dto';

@Controller('v1/products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Get()
  async findAll(): Promise<ProductResponseDto[]> {
    return this.productsService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<ProductResponseDto> {
    return this.productsService.findOne(id);
  }

  @Post()
  async create(@Body() dto: CreateProductDto): Promise<ProductResponseDto> {
    return this.productsService.create(dto);
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateProductDto,
  ): Promise<ProductResponseDto> {
    return this.productsService.update(id, dto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<void> {
    return this.productsService.remove(id);
  }
}

// src/modules/products/dto/create-product.dto.ts
import { IsString, IsNumber, IsOptional, Min } from 'class-validator';

export class CreateProductDto {
  @IsString()
  name: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsNumber()
  @Min(0)
  price: number;
}
```

## Related Skills

- `nest-backend-service-builder` — Full implementation patterns
- `nextjs-react-engineering` — Frontend component patterns
- `jest-testing-generator` — Test file scaffolding
