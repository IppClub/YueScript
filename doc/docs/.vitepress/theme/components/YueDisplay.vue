<template>
  <div>
    <button class="button" @click="compile()">Compile</button>
    <div style="display: none">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    compile() {
      const node = this.$el.children[1];
      const pre = node.querySelector("pre");
      const codeNode = pre?.querySelector("code") || pre || node;
      const code = (codeNode?.textContent || "").replace(/\r\n?/g, "\n");
      window.dispatchEvent(
        new CustomEvent("yue:open-compiler", { detail: code }),
      );
    },
  },
};
</script>

<style scoped>
.button {
  border: none;
  display: inline-block;
  font-size: 16px;
  color: var(--vp-button-brand-text);
  background-color: var(--vp-button-brand-bg);
  text-decoration: none;
  padding: 0.4rem 0.8rem;
  border-radius: 4px;
  transition: background-color 0.1s ease;
  box-sizing: border-box;
  border-bottom: 1px solid var(--vp-button-brand-border);
  margin-bottom: 1em;
}
.button:hover {
  background-color: var(--vp-button-brand-hover-bg);
}
.button:focus,
.button:active:focus,
.button.active:focus,
.button.focus,
.button:active.focus {
  outline: none;
}
</style>
