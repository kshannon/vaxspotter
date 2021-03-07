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
      typography: {
        DEFAULT: {
          css: {
            color: '#333',
            a: {
              textDecorationLine: 'none',
              color: '#2563EB',
              '&:hover': {
                color: '#1E40AF',
              },
            },
          },
        },
      }
    },
  },
  variants: {},
  plugins: [
    require('@tailwindcss/typography'),
  ],
}