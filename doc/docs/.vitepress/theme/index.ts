import DefaultTheme from 'vitepress/theme'
import type { Theme } from 'vitepress'
import { h } from 'vue'
import './custom.css'

// @ts-ignore
import CompilerModal from './components/CompilerModal.vue'
// @ts-ignore
import HomeFooter from './components/HomeFooter.vue'
// @ts-ignore
import YueCompiler from './components/YueCompiler.vue'
// @ts-ignore
import YueDisplay from './components/YueDisplay.vue'

const theme: Theme = {
  extends: DefaultTheme,
  Layout: () =>
    h(DefaultTheme.Layout, null, {
      'layout-bottom': () => [h(HomeFooter), h(CompilerModal)]
    }),
  enhanceApp({ app }) {
    app.component('CompilerModal', CompilerModal)
    app.component('YueCompiler', YueCompiler)
    app.component('YueDisplay', YueDisplay)
  }
}

export default theme
