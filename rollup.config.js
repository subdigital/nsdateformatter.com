import svelte from 'rollup-plugin-svelte';
import resolve from '@rollup/plugin-node-resolve';
import livereload from 'rollup-plugin-livereload';
import postcss from 'rollup-plugin-postcss';

export default {
    input: 'front-end/main.js',
    output: {
        sourcemap: true,
        file: 'Public/bundle.js',
        format: 'iife',
        name: 'app'
    },
    plugins: [
        postcss({
            extensions: ['.css'],
            plugins: []
        }),
        // svelte({
        //     include: 'front-end/**/*.svelte',
        //     preprocess: {
        //         style: ({ content }) => {
        //             return transformStyles(content);
        //         }
        //     },

        //     // Emit CSS as 'files' for other tools to process. Default is true
        //     emitCss: false,

        //     // warnings are passed to rollup, but we can intercept them here if needed
        //     onwarn: (warning, handler) => {
        //         // optionally intercept, or
        //         // pass to rollup
        //         handler(warning);
        //     }
        // })
    ]
};

