/// <reference types="vitepress/client" />

declare module "*.vue" {
  import type { DefineComponent } from "vue";
  const component: DefineComponent<{}, {}, any>;
  export default component;
}

declare global {
  interface Window {
    yue?: {
      version: () => string;
      tolua: (code: string, ...args: unknown[]) => [string, string];
      exec: (code: string) => string;
    };
  }
}

export {};
