module.exports = {
    content: [
        "Resources/Views/*.leaf",
        "front-end/**/*.svelte"
    ],
    theme: {
        extend: {},
    },
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
    ],
}

