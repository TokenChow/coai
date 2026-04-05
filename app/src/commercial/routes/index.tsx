/**
 * [COMMERCIAL] Commercial route definitions
 * These routes are appended to the main router to avoid upstream conflicts
 */
import { lazyFactor } from "@/utils/loader.tsx";
import { Suspense } from "react";
import { AuthRequired } from "@/router.tsx";

// Lazy-load commercial pages
const BillingPage = lazyFactor(
  () => import("@/commercial/routes/Billing.tsx"),
);

export const commercialRoutes = [
  // Add commercial routes here
  // Example:
  // {
  //   id: "commercial-billing",
  //   path: "/billing",
  //   element: (
  //     <AuthRequired>
  //       <Suspense>
  //         <BillingPage />
  //       </Suspense>
  //     </AuthRequired>
  //   ),
  // },
];

export default commercialRoutes;
