<script setup lang="ts">
import { useData } from "vitepress";

const { frontmatter } = useData();
</script>

<template>
  <footer v-if="frontmatter.footer" class="VPFooter has-sidebar">
    <div class="container">
      <p v-if="frontmatter.footer.message" class="message">
        {{ frontmatter.footer.message }}
      </p>
      <p v-if="frontmatter.footer.copyright" class="copyright">
        {{ frontmatter.footer.copyright }}
      </p>
    </div>
  </footer>
</template>

<style scoped>
.VPFooter {
  position: relative;
  z-index: var(--vp-z-index-footer);
  border-top: 1px solid var(--vp-c-gutter);
  padding: 32px 24px;
  background-color: var(--vp-c-bg);
}

.container {
  margin: 0 auto;
  max-width: var(--vp-layout-max-width);
  text-align: center;
}

.message,
.copyright {
  line-height: 24px;
  font-size: 14px;
  font-weight: 500;
  color: var(--vp-c-text-2);
}
</style>
