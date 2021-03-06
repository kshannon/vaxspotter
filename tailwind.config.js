// tailwind.config.js
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  future: {},
  purge: [
    './app/**/*.html',
    './app/**/*.js',
    './app/**/*.html.erb',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  variants: {},
  plugins: [
    require('@tailwindcss/typography'),
  ],
}