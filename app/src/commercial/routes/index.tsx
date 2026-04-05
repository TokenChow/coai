/**
 * [COMMERCIAL] Commercial route definitions
 * These routes are appended to the main router to avoid upstream conflicts
 *
 * Usage: import { commercialRoutes } from "@/commercial/routes";
 * Then spread into router: ...commercialRoutes
 *
 * Example route:
 *   import { lazyFactor } from "@/utils/loader.tsx";
 *   import { Suspense } from "react";
 *   import { AuthRequired } from "@/router.tsx";
 *   const BillingPage = lazyFactor(() => import("@/commercial/routes/Billing.tsx"));
 *   { id: "commercial-billing", path: "/billing", element: <AuthRequired><Suspense><BillingPage /></Suspense></AuthRequired> }
 */

import type { RouteObject } from "react-router-dom";

export const commercialRoutes: RouteObject[] = [];

export default commercialRoutes;
