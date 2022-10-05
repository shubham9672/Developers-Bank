/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    colors: {
      "bright_blue": "hsl(220, 98%, 61%)",
      "light_blue": "hsl(192, 100%, 67%)",
      "light_pink": "hsl(280, 87%, 65%)",
      "light_pink_hover": "hsl(285, 87%, 65%)",
      "light_pink_active": "hsl(295, 87%, 65%)",
      "light_gray": "hsl(0, 0%, 98%)",
      "light_gray1": "hsl(236, 33%, 92%)",
      "light_gray1_hover": "hsl(233, 11%, 84%)",
      "light_gray2": "hsl(236, 9%, 61%)",
      "light_gray2_hover": "hsl(235, 19%, 35%)",
      "dark_blue": "hsl(235, 21%, 11%)",
      "dark_blue_light": "hsl(225, 21%, 11%)",
      "dark_blue2": "hsl(235, 24%, 19%)",
      "dark_blue2_drag": "hsla(235, 25%, 19%, 0.7)",
      "dark_gray1": "hsl(234, 39%, 85%)",
      "dark_gray1_hover": "hsl(236, 33%, 92%)",
      "dark_gray2": "hsl(234, 11%, 52%)",
      "dark_gray3": "hsl(233, 14%, 35%)",
      "dark_gray4": "hsl(237, 14%, 26%)"

    },
    extend: {
      backgroundImage: {
        "mobile-d": "url('/bg-mobile-dark.jpg')",
        "mobile-l": "url('/bg-mobile-light.jpg')",
        "desktop-d": "url('/bg-desktop-dark.jpg')",
        "desktop-l": "url('/bg-desktop-light.jpg')",
        "profile" : "url('/logo.png')",
      }
    },
  },
  plugins: [],
}