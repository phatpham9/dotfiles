---
name: nextjs-react-engineering
description: 'Build React and Next.js components, pages, layouts, and hooks with App Router, RSC, Tailwind CSS or Styled Components, responsive design, accessibility, and PWA features'
---

# Purpose

Build production-ready React and Next.js components following Atomic Design, modern frontend patterns, and performance best practices.

## When to Use

Use this skill when the task involves:

- Creating or modifying React/Next.js components
- Building pages, layouts, or route handlers with App Router
- Implementing UI with Tailwind CSS or Styled Components
- Adding responsive design, accessibility, or PWA features
- Optimizing Core Web Vitals or client/server component decisions

## Constraints

- Default to **React Server Components (RSC)**; use `"use client"` only when interactivity is required
- Use **TypeScript with strict mode** enabled; avoid `any` types
- Apply **Atomic Design** principles (atoms → molecules → organisms → templates → pages)
- Use path aliases (`@/`) for all imports
- Use `next/image` and `next/font` for automatic optimization
- Ensure all interactive elements have accessible labels and keyboard support
- Prefix client-exposed env vars with `NEXT_PUBLIC_`

## Execution Steps

1. **Identify scope** — Determine component level (atom/molecule/organism/page) and RSC vs client boundary
2. **Scaffold structure** — Create component file with TypeScript interface for props
3. **Implement styling** — Use Tailwind utilities or Styled Components with design tokens
4. **Add accessibility** — Include ARIA labels, keyboard handlers, focus management
5. **Optimize performance** — Apply Suspense, streaming, dynamic imports where beneficial
6. **Verify responsiveness** — Test across breakpoints (mobile-first approach)

## Examples

### Input

> Create a product card component with image, title, price, and add-to-cart button

### Output

```tsx
// @/components/molecules/ProductCard/ProductCard.tsx
'use client';

import Image from 'next/image';
import { Button } from '@/components/atoms/Button';

interface ProductCardProps {
  id: string;
  title: string;
  price: number;
  imageUrl: string;
  onAddToCart: (id: string) => void;
}

export function ProductCard({
  id,
  title,
  price,
  imageUrl,
  onAddToCart,
}: ProductCardProps) {
  return (
    <article className="rounded-lg border p-4 hover:shadow-md transition-shadow">
      <Image
        src={imageUrl}
        alt={title}
        width={200}
        height={200}
        className="rounded"
      />
      <h3 className="mt-2 font-semibold">{title}</h3>
      <p className="text-lg font-bold">${price.toFixed(2)}</p>
      <Button
        onClick={() => onAddToCart(id)}
        aria-label={`Add ${title} to cart`}
      >
        Add to Cart
      </Button>
    </article>
  );
}
```

## Related Skills

- `jest-testing-generator` — Write tests for components
- `template-scaffold` — Generate boilerplate structures
