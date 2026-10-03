return {
    cmd = { "svelteserver", "--stdio" },
    filetypes = { "svelte" },
    root_markers = { "package.json", "svelte.config.js", "svelte.config.ts", ".git" },
    settings = {
        svelte = {
            plugin = {
                svelte = { format = { enable = true } },
            },
        },
    },
}
